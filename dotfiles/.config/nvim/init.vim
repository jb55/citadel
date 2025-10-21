inoremap <Esc> <Nop>
inoremap <special> fd <Esc>

set tabstop=8
set shiftwidth=8
set ai
set hlsearch
set colorcolumn=80
set nowrap
set hidden
set rnu nu
set wrap

"hi ColorColumn ctermbg=254
"hi StatusLine ctermbg=254
hi ColorColumn ctermbg=240
hi StatusLine ctermbg=240

map Y y$

syntax on

set clipboard=unnamedplus

let mapleader = "\\"
let maplocalleader = "\\"
nmap <Leader>xda ma:%s/\s\+$//g<CR>`a

nmap <C-q> :q<CR>
nmap <C-x> :x<CR>
nmap <C-s> ^D
nmap <C-n> :tn<CR>
nmap <C-p> :tp<CR>

" autoparens
"ino " ""<left>
"ino ' ''<left>
"ino ( ()<left>
"ino [ []<left>
"ino { {}<left>
"ino {<CR> {<CR>}<ESC>O

imap <A-j> {
imap <A-k> }
imap <A-n> [
imap <A-m> ]
imap <A-h> (
imap <A-l> )
imap <A-u> _
imap <A-i> -
imap <A-o> +
imap <A-,> =
imap <A-Space> <CR>

autocmd FileType go autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe gofmt\<esc>:loadview\<esc>`z"
autocmd FileType go set wrap
"autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"
"autocmd FileType javascript autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe jsfmt\<esc>:loadview\<esc>`z"
"autocmd BufEnter,BufNew *.js set sw=2 ts=2 expandtab

autocmd FileType rust nnoremap <buffer> <leader>f :call RustFormat()<CR>

"autocmd filetype html set sw=2 ts=2 expandtab

autocmd BufEnter,BufNew *.nix set sw=2 ts=2 expandtab
autocmd BufEnter,BufNew *.gmi set wrap linebreak

au BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

function! RustFormat()                                                          
    let l:view = winsaveview()                                                  
    silent! mkview                                                              
    silent! %!fmtsafe rustfmt                                                   
    call winrestview(l:view)                                                    
endfunction                                                                     

