set nocompatible

"change leader key
"let mapleader = ','
"let g:mapleader = ','
let mapleader = "\<Space>"
"let g:mapleader = "\<Space>"

syntax on

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set autoread " auto load modified config file
set shortmess=atI

"fugang added
set clipboard=unnamedplus

set nobackup
set noswapfile

"create undo file
if has('persistent_undo')
  set undolevels=1000         " How many undos
  set undoreload=10000        " number of lines to save for undo
  set undofile                " So is persistent undo ...
  set undodir=/tmp/vimundo/
endif

set wildignore=*.swp,*.bak,*.pyc,*.class,.svn

" mouse setting
set mouse-=a
" set mouse=a
set mousehide

" No annoying sound on errors
set title                " change the terminal's title
set novisualbell         " don't beep
set noerrorbells         " don't beep
set t_vb=
set tm=500

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" search setting
set hlsearch
set incsearch
set ignorecase
set smartcase     " ignore case if search pattern is all lowercase, case-sensitive otherwise

" indent config
set smartindent
set autoindent

" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab " change Tab key to space, if you input real tab, you should input C+V+Tab
set shiftround

"==========================================
" FileEncode Settings
"==========================================
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set helplang=cn
set termencoding=utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"==========================================
" others
"==========================================
autocmd! bufwritepost _vimrc source % " auto load vimrc config file in Window
autocmd! bufwritepost .vimrc source % " auto load vimrc config file in Linux

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.class

"==========================================
" HotKey Settings
"==========================================
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

"Smart way to move between windows 分屏窗口移动
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Go to home and end using capitalized directions
noremap H ^
noremap L $

" for # indent, python文件中输入新行时#号注释不切回行首
autocmd BufNewFile,BufRead *.py inoremap # X<c-h>#

" remap U to <C-r> for easier redo
nnoremap U <C-r>

"==========================================
" FileType Settings
"==========================================
autocmd FileType matlab set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd

" 保存python文件时删除多余空格
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,lisp,tex,matlab autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" define function AutoSetFileHead，automatic insert header
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(1, "\# encoding: utf-8")
    endif

    normal G
    normal o
    normal o
endfunc

" color theme
set background=dark
set t_Co=256
colorscheme distinguished

" When editing a file, always jump to the last cursor position.
" This must be after the uncompress commands.
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif

" line status
set laststatus=2 " Always display the statusline in all windows
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" format entire file
map <F7> mzgg=G`z

" suport latex file
let g:tex_flavor = "latex"

" to solve the problems made by the showmarks plugin that the next mess
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" sudo save current file
map <Space>w :w !sudo tee %

" remove noise bell voice
:set vb t_vb=
