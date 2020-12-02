colorscheme zenburn 		" colorscheme
syntax enable			" enable syntax processing

" python indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" js/html/css
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ | set softtabstop=2
    \ | set shiftwidth=2

" otherwise....
set tabstop=4 			" visual spaces per tab
set softtabstop=4		" spaces when editing
set expandtab

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

set number              " line numbers
set showcmd             " show last command
set cursorline          " highlight current line
filetype indent on      " indent config for specific files
set wildmenu            " autocomplete commands
set lazyredraw          " redraw screen only when necessary
set showmatch           " show matching bracket, paren, etc.
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" save session, recover session with vim -S
nnoremap <leader>s :mksession<CR>
" move to beginning/end of line
nnoremap B ^
nnoremap E $

" cursor is vertical in insert, block in normal
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" ht -> https://dougblack.io/words/a-good-vimrc.html
