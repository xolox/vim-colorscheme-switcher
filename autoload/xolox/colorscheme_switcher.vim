" Vim plug-in
" Maintainer: Peter Odding <peter@peterodding.com>
" Last Change: May 21, 2013
" URL: http://peterodding.com/code/vim/colorscheme-switcher

let g:xolox#colorscheme_switcher#version = '0.2.3'

" Dictionary with previously seen links between highlighting groups.
if !exists('s:known_links')
  let s:known_links = {}
endif

function! xolox#colorscheme_switcher#next() " {{{1
  " Switch to the next color scheme.
  return xolox#colorscheme_switcher#cycle(1)
endfunction

function! xolox#colorscheme_switcher#previous() " {{{1
  " Switch to the previous color scheme.
  return xolox#colorscheme_switcher#cycle(0)
endfunction

function! xolox#colorscheme_switcher#cycle(forward) " {{{1
  " Switch to the next or previous color scheme.

  " Get a sorted list with the available color schemes.
  let list = xolox#colorscheme_switcher#find_names()

  " Find the index of the currently loaded color scheme.
  let index = exists('g:colors_name') ? index(list, g:colors_name) : 0

  " Find the color scheme that should be loaded next.
  let old_bg = &background
  let prev_name = exists('g:colors_name') ? g:colors_name : ''
  while 1

    " Get the index of the next/previous color scheme.
    if a:forward
      let index = (index + 1) % len(list)
    else
      let index = (index ? index : len(list)) - 1
    endif

    " Find and remember links between highlighting groups before switching to
    " the next or previous color scheme.
    call xolox#colorscheme_switcher#find_links()

    " Load the selected color scheme.
    execute 'colorscheme' fnameescape(list[index])

    " For highlighting groups that used to be linked and are now "cleared",
    " we'll restore the link to the last known target group.
    call xolox#colorscheme_switcher#restore_links()

    " Stop searching when we've found the right color scheme.
    if !g:colorscheme_switcher_keep_background || &background == old_bg
      break
    endif

    let prev_name = list[index]

  endwhile

  " Set the global colors_name variable because some color scheme scripts fail
  " to do so or use the wrong name (for example rainbow_autumn uses autumn).
  let g:colors_name = list[index]

  " Enable the user to customize the loaded color scheme.
  silent execute 'doautocmd ColorScheme' fnameescape(list[index])

  " Print the name of the loaded color scheme?
  call xolox#misc#msg#info('colorscheme-switcher.vim %s: Loaded color scheme %s (%i/%i)', g:xolox#colorscheme_switcher#version, list[index], index, len(list))

endfunction

function! xolox#colorscheme_switcher#find_names() " {{{1
  " Get a sorted list with the available color schemes.
  let list = []
  for fname in split(globpath(&runtimepath, 'colors/*.vim'), '\n')
    let name = fnamemodify(fname, ':t:r')
    if index(list, name) == -1 && index(g:colorscheme_switcher_exclude, name) == -1
      call add(list, name)
    endif
  endfor
  return sort(list, 1)
endfunction

function! xolox#colorscheme_switcher#find_links() " {{{1
  " Find and remember links between highlighting groups.
  call xolox#misc#msg#info('colorscheme-switcher.vim %s: Using :highlight command to discover links between highlighting groups ..', g:xolox#colorscheme_switcher#version)
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx links to Constant" in the
    " output of the :highlight command.
    if len(tokens) == 5 && tokens[1] == 'xxx' && tokens[2] == 'links' && tokens[3] == 'to'
      let fromgroup = tokens[0]
      let togroup = tokens[4]
      let s:known_links[fromgroup] = togroup
    endif
  endfor
  call xolox#misc#msg#info('colorscheme-switcher.vim %s: Found %i links between highlighting groups in output of :highlight command.', g:xolox#colorscheme_switcher#version, len(s:known_links))
endfunction

function! xolox#colorscheme_switcher#restore_links() " {{{1
  " Restore broken links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  let num_restored = 0
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx cleared" in the
    " output of the :highlight command.
    if len(tokens) == 3 && tokens[1] == 'xxx' && tokens[2] == 'cleared'
      let fromgroup = tokens[0]
      let togroup = get(s:known_links, fromgroup, '')
      if !empty(togroup)
        execute 'hi link' fromgroup togroup
        let num_restored += 1
      endif
    endif
  endfor
  if num_restored > 0
    call xolox#misc#msg#info('colorscheme-switcher.vim %s: Restored %i links between highlighting groups.', g:xolox#colorscheme_switcher#version, num_restored)
  endif
endfunction

" vim: ts=2 sw=2 et fdm=marker
