" settings specific to plugins

" emmet
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" nerdtree, netrw, etc...
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
map <C-\> :NERDTreeToggle<CR>
" remove ? help menu in nerdtree
let NERDTreeMinimalUI=1

" FZF
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }

" ctl p
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {'dir': '\.git$\|\.yardoc\|node_modules\|log\|tmp$'}