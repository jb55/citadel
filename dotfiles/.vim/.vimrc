execute pathogen#infect()
syntax on
filetype plugin indent on

inoremap <Esc> <Nop>
inoremap <special> fd <Esc>

set backspace=indent,eol,start
set tabstop=8
set shiftwidth=8
set ai
set hlsearch
set colorcolumn=80
set nowrap
set hidden
set wrap
set rnu nu

"hi ColorColumn ctermbg=6

map Y y$
map Z zz

syntax on

set clipboard=unnamed

let mapleader = "\\"
let maplocalleader = "\\"
nmap <Leader>xda ma:%s/\s\+$//g<CR>`a
nmap <Leader>f ma:%!

nmap <C-q> :q<CR>
nmap <C-x> :x<CR>
nmap <C-s> ^D
nmap <C-n> :tn<CR>
nmap <C-p> :tp<CR>

" quick switch between buffers
" 1) Pick a key to act as Tab *from mappings* in the cmdline
set wildcharm=<C-Z>

" 2) (Optional but nice) show a completion menu and cycle through matches
set wildmenu
set wildmode=longest:full,full
" In Neovim you can also do:
" set wildoptions=pum

" 3) Now map Tab in NORMAL mode to start :b and invoke completion
nnoremap <Tab> :b <C-Z>

nmap <Leader>co :cfile build.log<CR>:copen<CR>:wincmd k<CR>
nmap <Leader>cl :close<CR>:q<CR>
nmap <Leader>cx :close<CR>:x<CR>
nmap <Leader>cm :!make >& build.log<CR>:cfile build.log<CR>:copen<CR>:wincmd k<CR>
nmap <Leader>cr :!bash .buildcmd >& build.log<CR>:cfile build.log<CR>:copen<CR>:wincmd k<CR>
nmap <Leader>ct :!cargo test >& build.log<CR>:cfile build.log<CR>:copen<CR>:wincmd k<CR>

nmap ]t :tn<CR>
nmap [t :tp<CR>

" Custom key binding for :cn (next quickfix) with window adjustments
nnoremap <silent> <C-n> :cn<CR>:wincmd j<CR>zt:wincmd k<CR>

" Optional: Custom key binding for :cp (previous quickfix) with window adjustments
nnoremap <silent> <C-p> :cp<CR>:wincmd j<CR>zt:wincmd k<CR>

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
autocmd FileType go set wrap rnu
"autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"
"autocmd FileType rust nnoremap <buffer> <leader>f :mkview<CR>:%!fmtsafe rustfmt<CR>:loadview<CR>
autocmd FileType rust setlocal tags=./rusty-tags.vi;/
autocmd FileType rust nnoremap <buffer> <leader>f :call RustFormat()<CR>
"autocmd filetype html set sw=2 ts=2 expandtab
autocmd FileType c nnoremap <buffer> <leader>f :call ClangFormat()<CR>
autocmd FileType cpp nnoremap <buffer> <leader>f :call ClangFormat()<CR>
"autocmd VimEnter *.rs cgetfile build.log
"autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd filetype js set sw=2 ts=2 expandtab

autocmd BufEnter,BufNew *.nix set sw=2 ts=2 expandtab
autocmd BufEnter,BufNew *.gmi set wrap linebreak

autocmd QuickFixCmdPost * if &buftype == 'quickfix' |
      \ execute 'wincmd j' | execute 'normal! zt' | execute 'wincmd k' |
      \ endif

" Automatically scroll the window so the current error is at the top
au BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

" Automatically move the cursor to the last editing position in a file when you open it, provided that position is valid.
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

function! RustFormat()
    let l:view = winsaveview()
    silent! mkview
    silent! %!fmtsafe fmtrust
    call winrestview(l:view)
endfunction

function! ClangFormat()
    let l:view = winsaveview()
    silent! mkview
    silent! %!fmtsafe clang-format
    call winrestview(l:view)
endfunction

