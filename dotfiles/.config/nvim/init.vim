inoremap <Esc> <Nop>
inoremap <special> fd <Esc>

set tabstop=8
set shiftwidth=8
set ai
set hlsearch
set colorcolumn=80
set nowrap
set hidden

map Y y$

highlight ColorColumn ctermbg=8
syntax on

set clipboard+=unnamedplus

let mapleader = "\\"
let maplocalleader = "\\"
nmap <Leader>xda ma:%s/\s\+$//g<CR>`a

autocmd FileType go autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!gofmt-safe\<esc>:loadview\<esc>`z"
