set relativenumber
set number
set autochdir
augroup myvimrc
    au!
    au BufWritePost .neovim.init.vim so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

"set tabstop=4
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
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
Plug 'davidhalter/jedi-vim'
Plug 'wincent/command-t'
Plug 'eagletmt/neco-ghc'
" Plug 'Shougo/vimproc.vim'
Plug 'eagletmt/ghcmod-vim'
Plug 'rdnetto/YCM-Generator'
" Plug 'lervag/vimtex'
" Plug 'Rename'
" Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
" Plug 'KabbAmine/vCoolor.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'pelodelfuego/vim-swoop'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'ap/vim-buftabline'
Plug 'Shougo/vimproc.vim'

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
autocmd filetype tex  setlocal spell
autocmd filetype text setlocal spell
" check for modelines (whthin the top 5 lines of a file?)
" not security-good for editing files from sketchy sources
set modeline
set modelines=5
" maybe this will work
autocmd FileType tex set shiftwidth=2

" multi cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" comment (_ is actually /)
map <C-_> :Commentary<CR>

" more visible colors for hilights
hi Visual ctermbg=8
hi SpellBad ctermfg=254 ctermbg=52 guifg=#ffffff guibg=#FF55FF
hi SpellCap ctermfg=254 ctermbg=17 guifg=#ffffff guibg=#FF55FF
set cursorline 
hi CursorLine   cterm=NONE ctermbg=235
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" not actually very good, come back to this later
" (maybe find an actual plugin to do this)
autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
nnoremap <silent> <F3> :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>
let HlUnderCursor=0
"autocmd FileType python let HlUnderCursor=1
"autocmd FileType rust   let HlUnderCursor=1
"autocmd FileType cpp    let HlUnderCursor=1
"autocmd FileType c      let HlUnderCursor=1

" autopairs: just added $ for latex
autocmd FileType tex let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '$':'$'}

