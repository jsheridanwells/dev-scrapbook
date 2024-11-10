" BASIC
set nocompatible              " be iMproved, required
set encoding=utf-8
filetype off                  
set noerrorbells
set vb t_vb=
set number relativenumber
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect

"split navigations
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
" BASIC
     13 set nocompatible              " be iMproved, required
     12 set encoding=utf-8
     11 filetype off
     10 set noerrorbells
      9 set vb t_vb=
      8 set number relativenumber
      7 set clipboard=unnamedplus
      6 set completeopt=noinsert,menuone,noselect
      5
      4 "split navigations
      3 set splitbelow
      2 set splitright
      1 nnoremap <C-J> <C-W><C-J>
15      nnoremap <C-K> <C-W><C-K>
      1 nnoremap <C-L> <C-W><C-L>
      2 nnoremap <C-H> <C-W><C-H>
      3                                                                          4 " enable folding                                                         5 set foldmethod=indent                                                    6 set foldlevel=99                                                         7 " enable folding with the spacebar                                       8 nnoremap <space> za                                                      9                                                                         10                                                                         11 " BEGIN VUNDLE  see: https://github.com/VundleVim/Vundle.vim            12 " set the runtime path to include Vundle and initialize                 13 set rtp+=~/.vim/bundle/Vundle.vim                                       14 call vundle#begin()                                                     15                                                                         16 Plugin 'VundleVim/Vundle.vim'                                           17 Plugin 'tmhedberg/SimpylFold'                                           18 Plugin 'vim-scripts/indentpython.vim'                                   19 Bundle 'Valloric/YouCompleteMe'                                         20 Plugin 'vim-syntastic/syntastic'                                        21 Plugin 'nvie/vim-flake8'                                                22 Plugin 'jnurmine/Zenburn'                                               23 Plugin 'altercation/vim-colors-solarized'                               24 Plugin 'scrooloose/nerdtree'                                            25 Plugin 'jistr/vim-nerdtree-tabs'                                        26 Plugin 'kien/ctrlp.vim'                                                 27 Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}         28                                                                         29 call vundle#end()            " required                            nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable folding
set foldmethod=indent
set foldlevel=99
" enable folding with the spacebar
nnoremap <space> za


" BEGIN VUNDLE  see: https://github.com/VundleVim/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

call vundle#end()            " required
filetype plugin indent on    " required
" END VUNDLE

" BEGIN APPEARANCE
colorscheme zenburn
" END APPEARANCE
"
" BEGIN NERDTREE
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
" END NERDTREE

" BEGIN PYTHON SETTINGS
" python indentationhttps://dev.to/mr_destructive/setting-up-vim-for-python-ej
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 
" python bad whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
let python_highlight_all=1
syntax on
"python with virtualenv support
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
" END PYTHON SETTINGS

" full stack indentation
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" ycm
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>


