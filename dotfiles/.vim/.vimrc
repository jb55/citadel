inoremap <Esc> <Nop>
inoremap <special> fd <Esc>

set tabstop=8
set shiftwidth=8
set ai
set hlsearch
set colorcolumn=80
set nowrap
set hidden

hi ColorColumn ctermbg=8

map Y y$

syntax on

set clipboard=unnamed

let mapleader = "\\"
let maplocalleader = "\\"
nmap <Leader>xda ma:%s/\s\+$//g<CR>`a

nmap <C-q> :q<CR>
nmap <C-x> :x<CR>
nmap <C-s> ^D
nmap <C-n> :tn<CR>
nmap <C-p> :tp<CR>

autocmd FileType go autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe gofmt\<esc>:loadview\<esc>`z"
autocmd FileType go set wrap rnu
autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"
"autocmd filetype html set sw=2 ts=2 expandtab

autocmd BufEnter,BufNew *.nix set sw=2 ts=2 expandtab
autocmd BufEnter,BufNew *.gmi set wrap linebreak

au BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1
