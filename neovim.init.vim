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



Shortcut save
    \ noremap <silent> <Space>fs :w<CR>
Shortcut last buffer
    \ noremap <silent> <Space>bb :Buffers<CR>
Shortcut last buffer
    \ noremap <silent> <Space><Tab> :b#<CR>
Shortcut search files
    \ noremap <silent> <Space>pf :Files<CR>
Shortcut source config
    \ noremap <silent> <Space>so :so ~/.config/nvim/init.vim<CR>
Shortcut source config
    \ noremap <silent> <Space>feR :so ~/.config/nvim/init.vim<CR>
Shortcut toggle whitespace
    \ noremap <silent> <Space>tw :set list!<CR>
Shortcut toggle line numbers
    \ noremap <silent> <Space>tn :set number!<CR>
Shortcut show shortcut menu and run chosen shortcut
      \ noremap <silent> <Space><Space> :Shortcuts<Return>
Shortcut fallback to shortcut menu on partial entry
      \ noremap <silent> <Space> :Shortcuts<Return>
Shortcut command
      \ noremap <silent> <Space>c :Command<Return>

" windows
Shortcut delete window
      \ noremap <silent> <Space>wd :close<CR>
Shortcut maximize window
      \ noremap <silent> <Space>wm :hide<CR>
Shortcut switch window h
      \ noremap <silent> <Space>wh <C-w>h
Shortcut switch window j
      \ noremap <silent> <Space>wj <C-w>j
Shortcut switch window k
      \ noremap <silent> <Space>wk <C-w>k
Shortcut switch window l
      \ noremap <silent> <Space>wl <C-w>l

Shortcut toggle NERDTree
    \ noremap <silent> <Space>ft :NERDTreeToggle<CR>
Shortcut toggle NERDTree
    \ noremap <silent> <Space>tf :NERDTreeToggle<CR>

Shortcut select color theme
    \ noremap <silent> <Space>ts :Colors<CR>


""""""""""""""""""""""""""""

Shortcut indent with tabs in buffer
      \ nnoremap <silent> <Space>f<Tab> :call Format_tabs_indentation()<CR>

Shortcut indent with spaces in buffer
      \ nnoremap <silent> <Space>f<Space> :call Format_spaces_indentation()<CR>

Shortcut format as separator, appending equal signs to end of line
      \ nnoremap <silent> <Space>f= :call Format_separator_equal_sign()<CR>

Shortcut format as separator, appending minus signs to end of line
      \ nnoremap <silent> <Space>f- :call Format_separator_minus_sign()<CR>

Shortcut format as separator, repeating last character to end of line
      \ nnoremap <silent> <Space>f_ :call Format_separator_repeat_eol()<CR>

Shortcut convert double to single quotes at cursor
      \ nnoremap <silent> <Space>f' :call Format_quotes_singularize()<CR>

Shortcut convert single to double quotes at cursor
      \ nnoremap <silent> <Space>f" :call Format_quotes_pluralize()<CR>

Shortcut save file as...
    \ nnoremap <silent> <space>yf :call feedkeys(":saveas %\t", "t")<return>


