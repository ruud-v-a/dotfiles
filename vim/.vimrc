" Enable Pathogen
execute pathogen#infect()

" Use UTF-8 as encoding
set encoding=utf-8
set fileencoding=utf-8

" Indent by two spaces please
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" I cannot get ~/vimfiles/ftplugin working, so this is the second option:
au FileType rust set tabstop=4 shiftwidth=4

" Enable auto-indent and smart indent
set ai
set si

" Highlight search results, do incremental search
" set hlsearch -- or not, looks ugly
set incsearch

" Highlight matching brackets for 0.2 seconds
set showmatch
set mat=2

" Detect filetypes
filetype plugin indent on

" Enable the ruler
set ru

" Enable syntax highlighting
syntax enable

if has("gui_running")
  " Use Consolas in gVim
  set guifont=Consolas:h12:cANSI

  " Use Solarized Dark
  set background=dark
  colorscheme solarized

  " Make the window wider
  set columns=170

  " Backspace behaves odd in gVim. Fix that.
  set backspace=2
endif
