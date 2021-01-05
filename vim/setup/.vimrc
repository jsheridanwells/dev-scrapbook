" update 2020-12-18 -- modularized, 

" TODO : check if it's actually necessary to load settings from here, or if this is just a debian thing
source /etc/vim/vimrc
" " modules
source $HOME/.vim/config/colors.vimrc
source $HOME/.vim/config/init.vimrc
source $HOME/.vim/config/general.vimrc
source $HOME/.vim/config/keys.vimrc
source $HOME/.vim/config/coc.vimrc
source $HOME/.vim/config/plugins.vimrc
" change status lines to make active window more obvious
" TODO : find out where this is getting overwritten so it can go back in the modules properly, for now it's nice to have so here it is
source /etc/vim/vimrc
hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=22 guibg=#003300 cterm=bold gui=bold
hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none