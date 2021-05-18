" Options that need to be set before loading plugins
" ==================================================

" Enable completion for language servers through Ale.
let g:ale_completion_enabled = 1

" Enable Pathogen.
execute pathogen#infect()

" Generic
" =======

" Use UTF-8 as encoding.
set encoding=utf-8
set fileencoding=utf-8

" Indent by two spaces please.
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Enable auto-indent (copies the indent of the current line when starting a
" new line). Do *not* enable smart indent, it breaks stuff for many languages
" (including comments in Python), and the filetype specific plugins should
" have a better indentation scheme anyway.
set autoindent
set nosmartindent

" Do not insert a line break when I type past the text width.
set formatoptions-=t

" Highlight the column after the text width.
set colorcolumn=+1

" Show line numbers. In the past I also had 'relativenumber' enabled, but in
" practice having absolute line numbers is more useful.
set number

" Highlight search results, do incremental search.
" set hlsearch -- or not, looks ugly
set incsearch

" Highlight matching brackets for 0.2 seconds.
set showmatch
set matchtime=2

" Enable filetype detection, and load filetype-specific plugins and
" indentation.
filetype plugin indent on

" Enable visual autocomplete of commands.
set wildmenu

" Enable the ruler that shows the cursor position.
set ruler

" Automatically reload files if they changed outside of Vim, do not ask.
set autoread

" It's not the 80s any more, why should I have to save my file all the time? I
" use source control, those are the states of the files I care about. In
" between commits, there should be no distinction between a file on disk or a
" file in memory. Some interesting background reading:
"
"   https://ngnghm.github.io/blog/2015/08/03/chapter-2-save-our-souls
"   http://tunes.org/wiki/orthogonal_20persistence.html
"
" Write when changing buffer, doing a make, quitting, Vim, etc.
" There is also the 'autosave' option, which is documented, but not yet
" implemented in Vim 7.4.
set autowriteall

" Use Solarized Dark. (But not in a Windows terminal that does not support 256
" colours.)
if &term != 'win32'
  set background=dark
  colorscheme solarized
endif

" Enable syntax highlighting.
syntax enable

" Set up the FZF fuzzy file finder.
"
" Previously I also used CtrlP, but there are two advantages to FZF over CtrlP:
" * It is faster, which matters on large repositories such as Chromium.
" * It is better at ranking relevant matches. In the Nixpkgs repository, I often
"   fail to locate a file with CtrlP, but FZF does find it.
"
" There are also disadvantages:
" * FZF needs to be installed, pure Vim does not suffice.
" * In the past FZF did not integrate as nicely with the Vim window as CtrlP
"   did, but nowadays it does.
"
" For FZF, suggest files from a Git repository. First list all tracked files
" (ls-files), then list all untracked files that are not ignored (second
" invocation of ls-files). Git can list them in one command, but listing
" untracked files is noticeably slower and introduces a delay. By listing these
" files last, FZF can start scanning through the tracked files immediately,
" which are also accessed most often.
command! FuzzyFindFile call fzf#run(fzf#wrap({
    \ 'source':'git ls-files && git ls-files --other --exclude-standard' }))

" Open the FZF fuzzy finder on Leader + F. It is more ergonomic than the more
" common Ctrl + P.
noremap <Leader>f :FuzzyFindFile<Return>

" Save and save-quit with Leader + W and Leader + X. in addition to :w. The
" colon requires holding shift, which is hurting my fingers.
noremap <Leader>w :w<Return>
noremap <Leader>x :x<Return>

" Select clipboard with Leader + c, paste immediately with Leader + p/P.
noremap <Leader>c "+
noremap <Leader>p "+p
noremap <Leader>P "+P

" Find all references through a language server.
noremap <Leader>r :ALEFindReferences<Return>

" Look for a tag file (generated by ctags) adjacent to the current file, but
" if none is found, search in the parent directory and keep going up.
set tags=tags;/

" Filetype specific
" =================

" See also the files in after/ftplugin.

" Use the Haskell file type to highlight Purescript; it's close enough
autocmd BufRead,BufNewFile *.purs setlocal filetype=haskell

" Disable folding of markdown files.
let g:vim_markdown_folding_disabled=1

" Graphical options
" =================

if has("gui_running")
  " Use Consolas at size 12.
  if has("gui_win32")
    set guifont=Consolas:h12:cANSI
  elseif has("gui_gtk2")
    set guifont=Consolas\ 12
  elseif has("gui_gtk3")
    set guifont=Consolas\ 12
  endif

  " Make the window wider and higher.
  set columns=110
  set lines=31

  " Code needs room to breathe, especially if the convention is
  " to use Egyptian brackets. Add more space between the lines.
  set linespace=7

  " Backspace behaves odd in gVim. Fix that.
  set backspace=2

  " Remove the menu bar and toolbar.
  set guioptions-=m
  set guioptions-=T
endif
