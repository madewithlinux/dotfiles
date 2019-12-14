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
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

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

" set wildchar=<Tab> wildmenu wildmode=longest,list

" don't put bufferline on the command line bar thing
let g:bufferline_echo = 0

let g:UltiSnipsExpandTrigger = "\<C-Tab>"
" let g:deoplete#enable_at_startup = 1
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

"" plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'SirVer/ultisnips' 
Plug 'honza/vim-snippets'
Plug 'terryma/vim-multiple-cursors'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'liuchengxu/vim-which-key'
Plug 'wsdjeg/FlyGrep.vim'
" Plug 'zchee/deoplete-jedi'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'bling/vim-bufferline'

Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-tagprefix'
Plug 'https://github.com/ncm2/ncm2-gtags'
Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
" Plug 'fgrsnau/ncm-otherbuf'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-match-highlight'

call plug#end()




"" completion things
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
" set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc
" Note that omnifunc does not run in background and may probably block the
" editor. If you don't want to be blocked by omnifunc too often, you could
" add 180ms delay before the omni wrapper:
"  'on_complete': ['ncm2#on_complete#delay', 180,
"               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
au User Ncm2Plugin call ncm2#register_source({
        \ 'name' : 'css',
        \ 'priority': 9,
        \ 'subscope_enable': 1,
        \ 'scope': ['css','scss'],
        \ 'mark': 'css',
        \ 'word_pattern': '[\w\-]+',
        \ 'complete_pattern': ':\s*',
        \ 'on_complete': ['ncm2#on_complete#delay', 500,
            \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
        \ })


" Press enter key to trigger snippet expansion
" The parameters are the same as `:help feedkeys()`
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" c-j c-k for moving in snippet
" let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

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
" use different leader for easymotion
map , <Plug>(easymotion-prefix)

" for faster gitgutter updates
set updatetime=100

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
    \ 's': ['Colors'                     , 'select color theme']  ,
    \ 'w': [':set list\<CR>'                  , 'show whitespace']   ,
    \ 'nw': [':set nolist\<CR>'                  , 'hide whitespace']   ,
    \ 'p':  [':set paste\<CR>',   'set paste']   ,
    \ 'np': [':set nopaste\<CR>', 'unset paste']   ,
    \ 'l': [':set number\<CR>'                , 'show line numbers'] ,
    \ 'nl': [':set nonumber\<CR>'                , 'hide line numbers'] ,
    \ }

let g:which_key_map['s'] = {
    \ 'name' : '+search',
    \ 'o': [':w|source ~/.config/nvim/init.vim\<CR>' , 'source config'],
    \ '/': ['FlyGrep' , 'fly grep search'],
    \ 'b': ['BLines' , 'search buffer'],
    \ 'a': ['BLines' , 'search all buffers'],
    \ 'p': ['Files' , 'find file'],
    \ 'g': ['GFiles' , 'find git-tracked file'],
    \ 'k': ['Maps', 'search normal mode keymap'],
    \ 'h': ['History', 'search file history'],
    \ 'c': [':History:\<CR>', 'search command history'],
    \ }
    "\ 'c': ['nohl' , 'clear highlight'],

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
    \ 'p': ['bp' , 'prev buffer'],
    \ 'n': ['bn' , 'next buffer'],
    \ 'd': ['bd' , 'delete (kill) buffer'],
    \ }

call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>


