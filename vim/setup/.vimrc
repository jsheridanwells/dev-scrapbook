" l/u 2024-11-08
" Disable annoying beeping
set noerrorbells
set vb t_vb=
set number relativenumber

" splits
set splitbelow
set splitright
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" enable folding
set foldmethod=indent
set foldlevel=99
" enable folding with the spacebar
nnoremap <space> za

" python code quality
" python indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
" python bad whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" full stack indentation
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" everything else
set encoding=utf-8
