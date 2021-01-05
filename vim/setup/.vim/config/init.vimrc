" w/ vim-plug
call plug#begin()
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'mattn/emmet-vim'
  Plug 'prettier/vim-prettier', { 'do': 'npm install'  }
  Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
  Plug 'preservim/nerdtree'
  Plug 'ctrlpvim/ctrlp.vim'
"   Plugin 'OmniSharp/omnisharp-vim'    " omnisharp
call plug#end()