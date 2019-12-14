" neovim minimal init.vim

set nocompatible " be iMproved, required
"set relativenumber
syntax on
set number
set cursorline
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set breakindent linebreak
set spellfile=~/.config/nvim/spell/en.utf-8.add
set nospell spelllang=en_us 
set hidden
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

filetype on        " Enable the plugin.
filetype indent on " Better indentation.
filetype plugin on " Load filetype specific plugins



set termguicolors
colorscheme morning

" let g:deoplete#enable_at_startup = 1
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

set completeopt=noinsert,menuone,noselect

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" insert mode movement
inoremap fd <ESC>
inoremap <C-d> <C-o><C-d>
inoremap <C-u> <C-o><C-u>
for key in ['h', 'j', 'k', 'l', '0']
    execute 'inoremap <C-'.key.'> <C-o>'.key
endfor


"" space leader key configuration
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" for faster gitgutter updates
set updatetime=100

set timeout
set timeoutlen=500

