set relativenumber
set number
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

"set tabstop=4
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set breakindent
set linebreak
set spellfile=~/.vim/spell/en.utf-8.add
set nospell spelllang=en_us 

syntax on
set nocompatible              " be iMproved, required
filetype off                  " required

" https://twitter.com/chordbug/status/1260649460612206594?s=19
nmap q: :q

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/syntastic'
Plugin 'racer-rust/vim-racer'
Plugin 'Valloric/YouCompleteMe'
Plugin 'jiangmiao/auto-pairs'
Plugin 'godlygeek/tabular'
Plugin 'davidhalter/jedi-vim'
Plugin 'ap/vim-buftabline'
Plugin 'wincent/command-t'
Plugin 'eagletmt/neco-ghc'
Plugin 'Shougo/vimproc.vim'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'rdnetto/YCM-Generator'
Plugin 'lervag/vimtex'
Plugin 'Rename'
Plugin 'terryma/vim-multiple-cursors'

call vundle#end()            " required
filetype plugin indent on    " required


" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_tags_files = 1
map <leader>s :SyntasticToggleMode<CR>

set completeopt=longest,menuone

set hidden
" rust
let g:racer_cmd = "/home/j0sh/.cargo/bin/racer"
let $RUST_SRC_PATH="/home/j0sh/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/"
let g:ycm_rust_src_path="/home/j0sh/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/"
let g:ycm_python_binary_path = '/usr/bin/python3'

" fancy tab-completion menu in vim cmdline
set wildmenu
set wildmode=full

" for buftabline
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" haskell
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

" vimtex
let g:vimtex_echo_ignore_wait = 1
autocmd filetype tex setlocal spell

" multi cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" be like spacemacs
inoremap fd <ESC>
noremap <Space>fs :w<CR>
