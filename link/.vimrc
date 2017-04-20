" Change mapleader
let mapleader=","
let maplocalleader="\\"

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Local dirs
if !has('win32')
  set backupdir=$DOTFILES/caches/vim
  set directory=$DOTFILES/caches/vim
  set undodir=$DOTFILES/caches/vim
  let g:netrw_home = expand('$DOTFILES/caches/vim')
endif

" Create vimrc autocmd group and remove any existing vimrc autocmds,
" in case .vimrc is re-sourced.
augroup vimrc
  autocmd!
augroup END

" Theme / Syntax highlighting

" Make invisible chars less visible in terminal.
autocmd vimrc ColorScheme * :hi NonText ctermfg=236
autocmd vimrc ColorScheme * :hi SpecialKey ctermfg=236
" Show trailing whitespace.
autocmd vimrc ColorScheme * :hi ExtraWhitespace ctermbg=red guibg=red
" Make selection more visible.
autocmd vimrc ColorScheme * :hi Visual guibg=#00588A
autocmd vimrc ColorScheme * :hi link multiple_cursors_cursor Search
autocmd vimrc ColorScheme * :hi link multiple_cursors_visual Visual

let g:molokai_italic=0
colorscheme molokai
set background=dark

" Visual settings
set cursorline " Highlight current line
set number " Enable line numbers.
set showtabline=2 " Always show tab bar.
set relativenumber " Use relative line numbers. Current line is still in status bar.
set title " Show the filename in the window titlebar.
set nowrap " Do not wrap lines.
set noshowmode " Don't show the current mode (airline.vim takes care of us)
set laststatus=2 " Always show status line

" Show absolute numbers in insert mode, otherwise relative line numbers.
autocmd vimrc InsertEnter * :set norelativenumber
autocmd vimrc InsertLeave * :set relativenumber

" Make it obvious where 80 characters is
set textwidth=121
let &colorcolumn="81,".join(range(120,999),",")

" Scrolling
set scrolloff=3 " Start scrolling three lines before horizontal border of window.
set sidescrolloff=3 " Start scrolling three columns before vertical border of window.

" Indentation
set autoindent " Copy indent from last line when starting new line.
set shiftwidth=2 " The # of spaces for indenting.
set smarttab " At start of line, <Tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces.
set softtabstop=2 " Tab key results in 2 spaces
set tabstop=2 " Tabs indent only 2 spaces
set expandtab " Expand tabs to spaces

" Reformatting
set nojoinspaces " Only insert single space after a '.', '?' and '!' with a join command.

" Toggle show tabs and trailing spaces (,c)
if has('win32')
  set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:>,precedes:<
endif
"set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
"set fillchars=fold:-
nnoremap <silent> <leader>v :call ToggleInvisibles()<CR>

" Extra whitespace
autocmd vimrc BufWinEnter * :2match ExtraWhitespaceMatch /\s\+$/
autocmd vimrc InsertEnter * :2match ExtraWhitespaceMatch /\s\+\%#\@<!$/
autocmd vimrc InsertLeave * :2match ExtraWhitespaceMatch /\s\+$/

" Toggle Invisibles / Show extra whitespace
function! ToggleInvisibles()
  set nolist!
  if &list
    hi! link ExtraWhitespaceMatch ExtraWhitespace
  else
    hi! link ExtraWhitespaceMatch NONE
  endif
endfunction

set nolist
call ToggleInvisibles()

" Trim extra whitespace
function! StripExtraWhiteSpace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction
noremap <leader>ss :call StripExtraWhiteSpace()<CR>

" Search / replace
set gdefault " By default add g flag to search/replace. Add g to toggle.
set hlsearch " Highlight searches
set incsearch " Highlight dynamically as pattern is typed.
set ignorecase " Ignore case of searches.
set smartcase " Ignore 'ignorecase' if search pattern contains uppercase characters.

" Clear last search
map <silent> <leader>/ <Esc>:nohlsearch<CR>

" Ignore things
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*

" Vim commands
set hidden " When a buffer is brought to foreground, remember undo history and marks.
set report=0 " Show all changes.
set mouse=a " Enable mouse in all modes.
set shortmess+=I " Hide intro menu.

" Splits
set splitbelow " New split goes below
set splitright " New split goes right

" Ctrl-J/K/L/H select split
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Ctrl-arrows select split
nnoremap [1;5B <C-W>j
nnoremap [1;5A <C-W>k
nnoremap [1;5C <C-W>l
nnoremap [1;5D <C-W>h

" Buffer navigation
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers
map <leader><leader> :b#<CR> " Switch between the last two files
map gb :bnext<CR> " Next buffer
map gB :bprev<CR> " Prev buffer

" Switch buffers with Alt-Left/Right
nmap [1;3C :bprev<CR>
nmap [1;3D :bnext<CR>
vmap [1;3C <Esc>:bprev<CR>
vmap [1;3D <Esc>:bnext<CR>

" Ctrl-J, the opposite of Shift-J
nnoremap <C-J> a<CR><Esc>k$

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
  endif
  execute "nnoremap <silent> " . c . "gb :" . c . "b<CR>"
  let c += 1
endwhile

" Fix page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Use Q for formatting the current paragraph (or selection)
" vmap Q gq
" nmap Q gqap

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" When editing a file, always jump to the last known cursor position. Don't do
" it for commit messages, when the position is invalid, or when inside an event
" handler (happens when dropping a file on gvim).
autocmd vimrc BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" F12: Source .vimrc & .gvimrc files
nmap <F12> :call SourceConfigs()<CR>

if !exists("*SourceConfigs")
  function! SourceConfigs()
    let files = ".vimrc"
    source $MYVIMRC
    if has("gui_running")
      let files .= ", .gvimrc"
      source $MYGVIMRC
    endif
    echom "Sourced " . files
  endfunction
endif

" FILE TYPES

autocmd vimrc BufRead .vimrc,*.vim set keywordprg=:help
autocmd vimrc BufRead,BufNewFile *.md set filetype=markdown
autocmd vimrc BufRead,BufNewFile *.tmpl set filetype=html
autocmd vimrc FileType sql :let b:vimpipe_command="psql mydatabase"
autocmd vimrc FileType sql :let b:vimpipe_filetype="postgresql"

" PLUGINS

" Airline
let g:airline_powerline_fonts = 1 " TODO: detect this?
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#fnamecollapse = 0
"let g:airline#extensions#tabline#fnamemod = ':t'

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
map <leader>n :NERDTreeToggle<CR>
autocmd vimrc StdinReadPre * let s:std_in=1
" If no file or directory arguments are specified, open NERDtree.
" If a directory is specified as the only argument, open it in NERDTree.
autocmd vimrc VimEnter *
  \ if argc() == 0 && !exists("s:std_in") |
  \   NERDTree |
  \ elseif argc() == 1 && isdirectory(argv(0)) |
  \   bd |
  \   exec 'cd' fnameescape(argv(0)) |
  \   NERDTree |
  \ end

" Signify
let g:signify_vcs_list = ['git', 'hg', 'svn']

" CtrlP.vim
" map <leader>p <C-P>
" map <leader>r :CtrlPMRUFiles<CR>
"let g:ctrlp_match_window_bottom = 0 " Show at top of window

" Vim-pipe
let g:vimpipe_invoke_map = '<Leader>r'
let g:vimpipe_close_map = '<Leader>p'

" DBExt
let g:dbext_default_profile_PG_skillsbot = 'type=pgsql:host=rds.bocoup.com:dbname=skillsbot-dev:user=skillsbot-dev'
let g:dbext_default_profile = 'PG_skillsbot'

" Indent Guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Mustache/handlebars
let g:mustache_abbreviations = 1

" Ack/ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
if v:version < 705 && !has('patch-7.4.785')
  Plug 'vim-scripts/PreserveNoEOL'
endif
Plug 'editorconfig/editorconfig-vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mhinz/vim-signify'
Plug 'mattn/emmet-vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'chase/vim-ansible-yaml'
Plug 'wavded/vim-stylus'
Plug 'klen/python-mode', {'for': 'python'}
Plug 'terryma/vim-multiple-cursors'
Plug 'wting/rust.vim', {'for': 'rust'}
Plug 'vim-scripts/dbext.vim'
Plug 'krisajenkins/vim-pipe'
Plug 'krisajenkins/vim-postgresql-syntax'
Plug 'mileszs/ack.vim'
Plug 'tmux-plugins/vim-tmux'
call plug#end()
