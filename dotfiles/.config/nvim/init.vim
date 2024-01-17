inoremap <Esc> <Nop>
inoremap <special> fd <Esc>

"execute pathogen#infect()

set tabstop=8
set shiftwidth=8
set ai
set hlsearch
set colorcolumn=80
set nowrap
set hidden
set rnu nu
set wrap


" set this when theme is dark
"hi ColorColumn ctermbg=235

" set this when theme is light
"hi ColorColumn ctermbg=255

hi StatusLine ctermbg=254

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

" Function to set ColorColumn based on the current theme
function! SetColorColumn()
    " Read the current theme from the symlink
    let theme = system("readlink ~/.Xresources.d/themes/current")

    " Trim any trailing whitespace or newline
    let theme = substitute(theme, '\n\+$', '', '')

    " Check if the theme is dark or light and set ColorColumn
    if theme =~ 'dark'
        " Set for dark theme
        hi ColorColumn ctermbg=235
    elseif theme =~ 'light'
        " Set for light theme
        hi ColorColumn ctermbg=255
    else
        " Default setting or error handling
    endif
endfunction

autocmd VimEnter * call SetColorColumn()

autocmd FileType go autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe gofmt\<esc>:loadview\<esc>`z"
autocmd FileType go set wrap
autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"
"autocmd FileType javascript autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe jsfmt\<esc>:loadview\<esc>`z"
"autocmd BufEnter,BufNew *.js set sw=2 ts=2 expandtab

"autocmd filetype html set sw=2 ts=2 expandtab

autocmd BufEnter,BufNew *.nix set sw=2 ts=2 expandtab
autocmd BufEnter,BufNew *.gmi set wrap linebreak

au BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
