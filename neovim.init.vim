" neovim init.vim
set relativenumber
set number
set autochdir

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set breakindent linebreak
set spellfile=~/.config/nvim/spell/en.utf-8.add
set nospell spelllang=en_us 

syntax on
set nocompatible " be iMproved, required
filetype off     " required

set completeopt=longest,menuone

" fancy tab-completion menu in vim cmdline
set wildmenu
set wildmode=full

" check for modelines (whthin the top 5 lines of a file?)
" not security-good for editing files from sketchy sources
set modeline
set modelines=5

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" more visible colors for hilights
hi SpellBad ctermbg=9
hi SpellCap ctermbg=6
"hi SpellBad ctermfg=254 ctermbg=52 guifg=#ffffff guibg=#FF55FF
"hi SpellCap ctermfg=254 ctermbg=17 guifg=#ffffff guibg=#FF55FF
set cursorline 
hi CursorLine   cterm=underline
hi Visual ctermbg=250
hi VisualBlock ctermbg=250
hi Pmenu ctermfg=16 " fix completion popup color

" be like spacemacs
inoremap fd <ESC>
noremap <Space>fs :w<CR>

call plug#begin()
Plug 'wincent/command-t'
Plug 'airblade/vim-gitgutter'
Plug 'haya14busa/incsearch.vim'
Plug 'pelodelfuego/vim-swoop'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'ap/vim-buftabline'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'epeli/slimux'

Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
" (Optional) Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'

Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

Plug 'fatih/vim-go'

call plug#end()

" for buftabline
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" vimtex
let g:vimtex_echo_ignore_wait = 1
autocmd filetype tex  setlocal spell
autocmd filetype text setlocal spell
" maybe this will work
autocmd FileType tex set shiftwidth=2

" multi cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" comment (_ is actually /)
map <C-_> :Commentary<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" not actually very good, come back to this later
" (maybe find an actual plugin to do this)
autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
nnoremap <silent> <F3> :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>
let HlUnderCursor=0

" autopairs: just added $ for latex
autocmd FileType tex let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '$':'$'}

" let g:slime_target = "tmux"
" let g:slime_paste_file = "$HOME/.slime_paste"
let g:slimux_select_from_current_window = 1
map <Leader>s      :SlimuxREPLSendLine<CR>
vmap <Leader>s     :SlimuxREPLSendSelection<CR>
map <Leader>b      :SlimuxREPLSendBuffer<CR>
map <Leader>a      :SlimuxShellLast<CR>
map <Leader>k      :SlimuxSendKeysLast<CR>
map <C-c><C-c> vip :SlimuxREPLSendSelection<CR>
vmap <C-c><C-c>    :SlimuxREPLSendSelection<CR>

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 200
" deoplete tab-complete
inoremap <expr><tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<tab>"

" language server, for rust
" Required for operations modifying multiple buffers like rename.
set hidden
autocmd BufReadPost *.rs setlocal filetype=rust
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    \ }
" Automatically start language servers.
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
" deoplete clang config
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-3.8/lib/clang/3.8.0/include/'

