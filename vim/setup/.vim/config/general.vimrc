" global settings

syntax enable
syntax on
set number relativenumber               " Show line numbers  - hybrid numbers, see below for line number and focus settings
set wrap                        " wrap lines
set linebreak	                        " Break lines at word (requires Wrap lines)
set showbreak=+++	                    " Wrap-broken line prefix
set textwidth=100	                    " Line wrap (number of cols)
set showmatch	                        " Highlight matching brace
set noerrorbells visualbell t_vb=       " disable error bells, blinks, and all that other nonsense
autocmd GUIEnter * set visualbell t_vb=
set hlsearch	                " Highlight all search results
set smartcase	                " Enable smart-case search
set ignorecase	                " Always case-insensitive
set incsearch	                " Searches for strings incrementally
set autoindent	                " Auto-indent new lines
set cindent	                    " Use 'C' style program indenting
set shiftwidth=2	            " Number of auto-indent spaces
set smartindent	                " Enable smart-indent
set smarttab	                " Enable smart-tabs
set softtabstop=2	            " Number of spaces per Tab
set confirm	                " Prompt confirmation dialogs
set ruler	                " Show row and column ruler information
set showtabline=4	        " Show tab bar
set undolevels=1000	            " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
set encoding=utf-8              " utf-8 encoding
set showmatch                   " highligh matching punctuation, e.g. [] {}
set mouse=a                     " use mouse in all modes
set cmdheight=2                 " view command window better

" change cursor shape between normal and insert modes
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" Optionally reset the cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" settings to toggle absolute and relative line numbers depending on focus/mode
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" file tree explorer behaves as assumed
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25