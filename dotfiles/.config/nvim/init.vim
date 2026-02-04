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
"set wrap


" set this when theme is dark
"hi ColorColumn ctermbg=235

" set this when theme is light
"hi ColorColumn ctermbg=255

hi StatusLine ctermbg=254

"hi ColorColumn ctermbg=237
"hi ColorColumn ctermbg=254
"hi StatusLine ctermbg=254

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
nmap <C-N> :cn<CR>
nmap <C-P> :cp<CR>

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
"autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"
autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"

augroup Rust
    autocmd!
    "autocmd FileType rust autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe rustfmt\<esc>:loadview\<esc>`z"
    "autocmd FileType rust nnoremap <buffer> <leader>f :mkview<CR>:%!fmtsafe rustfmt<CR>:loadview<CR>
    "autocmd FileType rust nnoremap <buffer> <leader>f :execute 'mkview | %!fmtsafe rustfmt | loadview'<CR>
    "autocmd FileType rust nnoremap <buffer> <leader>f :%!fmtsafe rustfmt<CR>
    autocmd FileType rust nnoremap <buffer> <leader>f :call RustFormat()<CR>
    autocmd FileType rust CompilerSet errorformat=
            \%-G,%
            \%-Gerror:\ aborting\ %.%#,%
            \%-Gerror:\ Could\ not\ compile\ %.%#,%
            \%Eerror:\ %m,%
            \%Eerror[E%n]:\ %m,%
            \%Wwarning:\ %m,%
            \%Inote:\ %m,%
            \%C\ %#-->\ %f:%l:%c,%
            \%E\ \ left:%m,%C\ right:%m\ %f:%l:%c,%Z
augroup END

"autocmd FileType javascript autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:%!fmtsafe jsfmt\<esc>:loadview\<esc>`z"
autocmd BufEnter,BufNew *.js set sw=2 ts=2 expandtab

autocmd FileType rust nnoremap <buffer> <leader>f :call RustFormat()<CR>

"autocmd filetype html set sw=2 ts=2 expandtab

autocmd BufEnter,BufNew *.nix set sw=2 ts=2 expandtab
autocmd BufEnter,BufNew *.gmi set wrap linebreak

au BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

" Automatically move the cursor to the last editing position in a file when you open it, provided that position is valid.
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

