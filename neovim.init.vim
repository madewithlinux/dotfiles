" neovim init.vim

set nocompatible " be iMproved, required
"set relativenumber
set number
set autochdir

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set breakindent linebreak
set spellfile=~/.config/nvim/spell/en.utf-8.add
set nospell spelllang=en_us 

syntax on

set completeopt=longest,menuone
set completeopt+=noselect
set completeopt+=noinsert
set wildmode=longest:full,list,full
set wildmenu
set wildchar=<Tab>

set termguicolors
colorscheme morning

" fancy tab-completion menu in vim cmdline
" set wildmenu
" set wildmode=full

" check for modelines (whthin the top 5 lines of a file?)
" not security-good for editing files from sketchy sources
set modeline
set modelines=5
set cursorline

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

let g:deoplete#enable_at_startup = 1

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sunaku/vim-shortcut'
Plug 'scrooloose/nerdtree'
Plug 'SirVer/ultisnips' 
Plug 'honza/vim-snippets'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'liuchengxu/vim-which-key'
call plug#end()




"imap <c-Space> <plug>(fzf-complete-word)

" yes it is needful to maually source the vim plugin
source /home/j0sh/.vim/plugged/vim-shortcut/plugin/shortcut.vim
"source ~/.config/nvim/plugin/shortcuts.vim

" inert mode movement
inoremap fd <ESC>
"inoremap <C-h> <C-o>h
"inoremap <C-j> <C-o>j
"inoremap <C-k> <C-o>k
"inoremap <C-l> <C-o>l
inoremap <C-d> <C-o><C-d>
inoremap <C-u> <C-o><C-u>

for key in ['h', 'j', 'k', 'l', '0']
    execute 'inoremap <C-'.key.'> <C-o>'.key
endfor

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
" nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>


set timeout
set timeoutlen=500
let g:which_key_map = {}
let g:which_key_map[' '] = ['Command', 'run command']

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
    \ 'name' : 'toggle' ,
    \ 'f': ['NERDTreeToggle'             , 'toggle NERDTree']     ,
    \ 'n': ['set number!'                , 'toggle line numbers'] ,
    \ 's': ['Colors'                     , 'select color theme']  ,
    \ 'w': ['set list!'                  , 'toggle whitespace']   ,
    \ 'p': ['set paste!'                 , 'toggle paste']   ,
    \ }

let g:which_key_map['s'] = {
    \ 'name' : 'source',
    \ 'o': [':wa|source ~/.config/nvim/init.vim\<CR>' , 'source config'],
    \ }

let g:which_key_map['f'] = {
    \ 'name' : 'file',
    \ 'e': [':so ~/.config/nvim/init.vim\<CR>' , 'source config']       ,
    \ 's': ['w'                                , 'save']                ,
    \ 't': ['NERDTreeToggle'                   , 'toggle NERDTree']     ,
    \ }


call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>


