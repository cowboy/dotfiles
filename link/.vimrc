" Change mapleader
let mapleader=","
let maplocalleader="\\"

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Map F1 to Esc because I'm sick of seeing help pop up
map <F1> <Esc>
imap <F1> <Esc>

" Local dirs
if !has('win32') && !empty($DOTFILES)
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

" Per-mode cursor shape
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if has('unix')
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
elseif has('macuinx')
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

" Theme / Syntax highlighting

" " Show trailing whitespace.
autocmd vimrc ColorScheme * :hi ExtraWhitespace ctermbg=red guibg=red

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

set textwidth=80
" Show 120 columns but make it obvious where 80 characters is
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

" Toggle show tabs and trailing spaces (,v)
if has('win32')
  set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:»,precedes:«
endif
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
set ttymouse=xterm2 " Ensure mouse works inside tmux
set shortmess+=I " Hide intro menu.

" Splits
set splitbelow " New split goes below
set splitright " New split goes right

let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_disable_when_zoomed = 1
" Ctrl-arrows select split
nnoremap <silent> <C-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <C-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <C-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-Right> :TmuxNavigateRight<cr>
" This seems to be necessary in gnome-terminal
nnoremap <silent> [1;5A :TmuxNavigateUp<cr>
nnoremap <silent> [1;5B :TmuxNavigateDown<cr>
nnoremap <silent> [1;5D :TmuxNavigateLeft<cr>
nnoremap <silent> [1;5C :TmuxNavigateRight<cr>
" Ctrl-J/K/L/H select split
nnoremap <silent> <C-H> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateDown<cr>
nnoremap <silent> <C-J> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-K> :TmuxNavigateRight<cr>
" Previous split
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>

" Buffer navigation
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers
map <leader><leader> :b#<CR> " Switch between the last two files
map gb :bnext<CR> " Next buffer
map gB :bprev<CR> " Prev buffer

" Switch buffers with Alt-Left/Right
nmap <silent> <M-Left> :bprev<CR>
nmap <silent> <M-Right> :bnext<CR>
vmap <silent> <M-Left> :bprev<CR>
vmap <silent> <M-Right> :bnext<CR>
nmap <silent> [1;3D :bprev<CR>
nmap <silent> [1;3C :bnext<CR>
vmap <silent> [1;3D <Esc>:bprev<CR>
vmap <silent> [1;3C <Esc>:bnext<CR>

" Resize panes with Shift-Left/Right/Up/Down
nnoremap <silent> <S-Up> :resize +1<CR>
nnoremap <silent> <S-Down> :resize -1<CR>
nnoremap <silent> <S-Right> :vertical resize +1<CR>
nnoremap <silent> <S-Left> :vertical resize -1<CR>
nnoremap <silent> [1;2A :resize +1<CR>
nnoremap <silent> [1;2B :resize -1<CR>
nnoremap <silent> [1;2C :vertical resize +1<CR>
nnoremap <silent> [1;2D :vertical resize -1<CR>

" Ctrl-J, the opposite of Shift-J
nnoremap <C-J> i<CR><Esc>k:.s/\s\+$//e<CR>j^

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    " execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
    execute "nmap <leader>" . c . " <Plug>AirlineSelectTab" . c
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

" The :Src command will source .vimrc & .gvimrc files
command! Src :call SourceConfigs()

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
" let g:airline#extensions#tabline#fnamecollapse = 0
" let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#syntastic#enabled = 1

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
" let g:ctrlp_match_window_bottom = 0 " Show at top of window
let g:ctrlp_show_hidden = 1

" Vim-pipe
let g:vimpipe_invoke_map = '<Leader>r'
let g:vimpipe_close_map = '<Leader>p'

" DBExt
let g:dbext_default_profile_PG_skillsbot = 'type=pgsql:host=rds.bocoup.com:dbname=skillsbot-dev:user=skillsbot-dev'
let g:dbext_default_profile = 'PG_skillsbot'

" Indent Guides
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

" Mustache/handlebars
let g:mustache_abbreviations = 1

" Ack/ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ack_autoclose = 1
nnoremap <Leader>a :Ack!<Space>

" Multiple cursors
nnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
nnoremap <silent> j :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> j :MultipleCursorsFind <C-R>/<CR>

" Ale
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'node_modules/.bin/eslint'
let g:syntastic_json_checkers = ['jsonlint']

" Emmet
" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

" https://github.com/junegunn/vim-plug
" Reload .vimrc and :PlugInstall to install plugins.
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                                                       " Core config
Plug 'rafi/awesome-vim-colorschemes'                                            " Color schemes
Plug 'bling/vim-airline'                                                        " Status bar
Plug 'tpope/vim-surround'                                                       " Quotes / parens / tags
Plug 'tpope/vim-fugitive'                                                       " Git wrapper
Plug 'tpope/vim-rhubarb'                                                        " Github helper
Plug 'tpope/vim-vinegar'                                                        " File browser (?)
Plug 'tpope/vim-repeat'                                                         " Enable . repeat in plugins
Plug 'tpope/vim-commentary'                                                     " (gcc) Better commenting
Plug 'tpope/vim-unimpaired'                                                     " Pairs of mappings with [ ]
Plug 'tpope/vim-eunuch'                                                         " Unix helpers
Plug 'scrooloose/nerdtree'                                                      " (,n) File browser
Plug 'ctrlpvim/ctrlp.vim'                                                       " (C-P)(,b) Fuzzy file/buffer/mru/tag finder
if v:version < 705 && !has('patch-7.4.785')
  Plug 'vim-scripts/PreserveNoEOL'                                              " Preserve missing final newline on save
endif
Plug 'editorconfig/editorconfig-vim'                                            " EditorConfig
Plug 'nathanaelkane/vim-indent-guides'                                          " (,ig) Visible indent guides
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}                                   " React JSX highlighting/indenting
Plug 'AndrewRadev/splitjoin.vim'                                                " (gS)(gJ) Split/join multi-line statements
Plug 'mhinz/vim-signify'                                                        " VCS status in the sign column
Plug 'mattn/emmet-vim'                                                          " (C-Y,) Expand HTML abbreviations
Plug 'chase/vim-ansible-yaml'                                                   " Ansible YAML highlighting
Plug 'klen/python-mode', {'for': 'python'}                                      " Python mode
Plug 'terryma/vim-multiple-cursors'                                             " (C-N) Multiple selections/cursors
Plug 'vim-scripts/dbext.vim'
Plug 'krisajenkins/vim-pipe'                                                    " (,r) Run a buffer through a command
Plug 'krisajenkins/vim-postgresql-syntax'
Plug 'mileszs/ack.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'elzr/vim-json'
Plug 'othree/eregex.vim'
if v:version >= 800
  Plug 'w0rp/ale'
else
  Plug 'vim-syntastic/syntastic'
endif
call plug#end()

let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 1
let g:gruvbox_contrast_dark = 'medium'
set background=dark
colorscheme gruvbox
