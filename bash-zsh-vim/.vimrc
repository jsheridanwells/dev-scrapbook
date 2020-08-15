set number	                            " Show line numbers
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
set showtabline=2	        " Show tab bar
 
set undolevels=1000	            " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
 
syntax on                       " enable syntax highlighting
set wrap                        " wrap lines
set encoding=utf-8              " utf-8 encoding
set showmatch                   " highligh matching punctuation, e.g. [] {}
set mouse=a                     " use mouse in all modes
set cmdheight=2                 " view command window better

