*Please note that the vim-colorscheme-switcher plug-in requires my vim-misc plug-in which is separately distributed.*

Unzip the most recent ZIP archives of the [vim-colorscheme-switcher] [dcs] and [vim-misc] [dms] plug-ins inside your Vim profile directory (usually this is `~/.vim` on UNIX and `%USERPROFILE%\vimfiles` on Windows), restart Vim and execute the command `:helptags ~/.vim/doc` (use `:helptags ~\vimfiles\doc` instead on Windows). Now try it out: Execute `:NextColorScheme` to switch to the next color scheme.

If you didn't change the plug-in's configuration you can now use the `F8` and `Shift-F8` keys to switch to the next/previous color scheme.

If you prefer you can also use [Pathogen] [pathogen], [Vundle] [vundle] or a similar tool to install & update the [vim-colorscheme-switcher] [github-colorscheme-switcher] and [vim-misc] [github-misc] plug-ins using a local clone of the git repository.


[dcs]: http://peterodding.com/code/vim/downloads/colorscheme-switcher.zip
[dms]: http://peterodding.com/code/vim/downloads/misc.zip
[github-colorscheme-switcher]: http://github.com/xolox/vim-colorscheme-switcher
[github-misc]: http://github.com/xolox/vim-misc
[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332
[vundle]: https://github.com/gmarik/vundle
