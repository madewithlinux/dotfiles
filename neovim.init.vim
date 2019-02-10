" neovim init.vim

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

filetype on        " Enable the plugin.
filetype indent on " Better indentation.
filetype plugin on " Load filetype specific plugins



set termguicolors
colorscheme morning

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" set completeopt=longest,menuone
" set completeopt+=noselect
" set completeopt+=noinsert
" set wildmode=longest:full,list,full
" set wildmode=full
" set wildmenu
set wildchar=<Tab> wildmenu wildmode=longest,list

let g:UltiSnipsExpandTrigger = "\<C-Tab>"
let g:deoplete#enable_at_startup = 1
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'SirVer/ultisnips' 
Plug 'honza/vim-snippets'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'liuchengxu/vim-which-key'
Plug 'wsdjeg/FlyGrep.vim'
Plug 'zchee/deoplete-jedi'
Plug 'easymotion/vim-easymotion'
call plug#end()

" insert mode movement
inoremap fd <ESC>
inoremap <C-d> <C-o><C-d>
inoremap <C-u> <C-o><C-u>
for key in ['h', 'j', 'k', 'l', '0']
    execute 'inoremap <C-'.key.'> <C-o>'.key
endfor

" inoremap <C-j>
"     \ pumvisible() ? "\<C-n>" : "\<C-o>\<C-j>"
" inoremap <C-k> pumvisible() ? "\<C-p>" : "\<C-o>\<C-k>"

let g:mapleader = "\<Space>"
let g:maplocalleader = ','
" use different leader for easymotion
map , <Plug>(easymotion-prefix)

set timeout
set timeoutlen=500
let g:which_key_map = {}
let g:which_key_map[' '] = ['Command', 'run command']
let g:which_key_map['<Tab>'] = [':b#\<CR>', 'last buffer']

let g:which_key_map['w'] = {
    \ 'name' : '+windows' ,
    \ 'w' : ['<C-W>w'     , 'other-window']          ,
    \ 'd' : ['<C-W>c'     , 'delete-window']         ,
    \ '-' : ['<C-W>s'     , 'split-window-below']    ,
    \ '|' : ['<C-W>v'     , 'split-window-right']    ,
    \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
    \ 'h' : ['<C-W>h'     , 'window-left']           ,
    \ 'j' : ['<C-W>j'     , 'window-below']          ,
    \ 'l' : ['<C-W>l'     , 'window-right']          ,
    \ 'k' : ['<C-W>k'     , 'window-up']             ,
    \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
    \ 'J' : ['resize +5'  , 'expand-window-below']   ,
    \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
    \ 'K' : ['resize -5'  , 'expand-window-up']      ,
    \ '=' : ['<C-W>='     , 'balance-window']        ,
    \ 's' : ['<C-W>s'     , 'split-window-below']    ,
    \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
    \ '?' : ['Windows'    , 'fzf-window']            ,
    \ 'm':  ['hide'   , 'maximize window']       ,
    \ }

let g:which_key_map['t'] = {
    \ 'name' : '+toggle' ,
    \ 'f': ['NERDTreeToggle'             , 'toggle NERDTree']     ,
    \ 'n': ['set number!'                , 'toggle line numbers'] ,
    \ 's': ['Colors'                     , 'select color theme']  ,
    \ 'w': ['set list!'                  , 'toggle whitespace']   ,
    \ 'p': ['set paste!'                 , 'toggle paste']   ,
    \ }

let g:which_key_map['s'] = {
    \ 'name' : '+search',
    \ 'o': [':w|source ~/.config/nvim/init.vim\<CR>' , 'source config'],
    \ '/': ['FlyGrep' , 'fly grep search'],
    \ 'b': ['BLines' , 'search buffer'],
    \ 'a': ['BLines' , 'search all buffers'],
    \ 'c': ['nohl' , 'clear highlight'],
    \ 'p': ['Files' , 'find file'],
    \ 'g': ['GFiles' , 'find git-tracked file'],
    \ 'k': ['Maps', 'search normal mode keymap'],
    \ }

let g:which_key_map['f'] = {
    \ 'name' : '+file',
    \ 'e': [':so ~/.config/nvim/init.vim\<CR>' , 'source config']       ,
    \ 's': ['w'                                , 'save']                ,
    \ 'c': [':w! ~/scratch\<CR>' , 'write selection to ~/scratch'],
    \ 'd': ['NERDTreeFind', 'find file in NERDTree'],
    \ 't': ['NERDTreeToggle'                   , 'toggle NERDTree']     ,
    \ }

let g:which_key_map['p'] = {
    \ 'name' : '+project',
    \ 'f': ['Files' , 'find file'],
    \ 'g': ['GFiles' , 'find git-tracked file'],
    \ }

let g:which_key_map['b'] = {
    \ 'name' : '+buffer',
    \ 'b': ['Buffers' , 'find buffer'],
    \ 'd': ['bd' , 'delete (kill) buffer'],
    \ }

call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>


