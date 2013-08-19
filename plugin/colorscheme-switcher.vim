" Vim plug-in
" Maintainer: Peter Odding <peter@peterodding.com>
" Last Change: August 19, 2013
" URL: http://peterodding.com/code/vim/colorscheme-switcher

" This Vim plug-in defines two commands and four key mappings to quickly
" switch between color schemes (with the same &background if so desired).

if &cp || exists('g:loaded_colorscheme_switcher')
  finish
endif

" Make sure vim-misc is installed.
try
  " The point of this code is to do something completely innocent while making
  " sure the vim-misc plug-in is installed. We specifically don't use Vim's
  " exists() function because it doesn't load auto-load scripts that haven't
  " already been loaded yet (last tested on Vim 7.3).
  call type(g:xolox#misc#version)
catch
  echomsg "Warning: The vim-colorscheme-switcher plug-in requires the vim-misc plug-in which seems not to be installed! For more information please review the installation instructions in the readme (also available on the homepage and on GitHub). The vim-colorscheme-switcher plug-in will now be disabled."
  let g:loaded_colorscheme_switcher = 1
  finish
endtry

" You can set this variable to 0 (false) in your vimrc script to disable the
" default mappings (F8 in insert and normal mode).
if !exists('g:colorscheme_switcher_define_mappings')
  let g:colorscheme_switcher_define_mappings = 1
endif

" You can set this variable to 1 in your "vimrc" or interactively when you
" only want to switch between color schemes of the same &background color.
if !exists('g:colorscheme_switcher_keep_background')
  let g:colorscheme_switcher_keep_background = 0
endif

" If you want to ignore specific color schemes you can set this variable to a
" list with the names of the excluded color schemes.
if !exists('g:colorscheme_switcher_exclude')
  " Note: The following color scheme scripts breaks cycling through the
  " color schemes because of their use of linked highlight groups!
  let g:colorscheme_switcher_exclude = []
endif

if g:colorscheme_switcher_define_mappings
  inoremap <silent> <F8> <C-O>:NextColorScheme<CR>
  nnoremap <silent> <F8> :NextColorScheme<CR>
  inoremap <silent> <S-F8> <C-O>:PrevColorScheme<CR>
  nnoremap <silent> <S-F8> :PrevColorScheme<CR>
endif

command! -bar -bang NextColorScheme call xolox#colorscheme_switcher#next()
command! -bar -bang PrevColorScheme call xolox#colorscheme_switcher#previous()

" Don't reload the plug-in once it has loaded successfully.
let g:loaded_colorscheme_switcher = 1

" vim: ts=2 sw=2 et
