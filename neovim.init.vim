set relativenumber
set number
set autochdir
hi Visual ctermbg=8
augroup myvimrc
    au!
    au BufWritePost .neovim.init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

"set tabstop=4
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set breakindent
set linebreak
set spellfile=~/.config/nvim/spell/en.utf-8.add
set nospell spelllang=en_us 

syntax on
set nocompatible              " be iMproved, required
filetype off                  " required


call plug#begin()
Plug 'VundleVim/Vundle.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
Plug 'racer-rust/vim-racer'
Plug 'Valloric/YouCompleteMe'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'davidhalter/jedi-vim'
Plug 'ap/vim-buftabline'
Plug 'wincent/command-t'
Plug 'eagletmt/neco-ghc'
Plug 'Shougo/vimproc.vim'
Plug 'eagletmt/ghcmod-vim'
Plug 'rdnetto/YCM-Generator'
Plug 'lervag/vimtex'
Plug 'Rename'
Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'KabbAmine/vCoolor.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'pelodelfuego/vim-swoop'
call plug#end()

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

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
