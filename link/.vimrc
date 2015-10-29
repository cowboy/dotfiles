"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
" vim configuration file
" Selectied portions taken from http://amix.dk/vim/vimrc.html
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pathogen, vim module management
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start pathogen
execute pathogen#infect()
" Airline configuration
set laststatus=2
let g:airline_powerline_fonts = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File searching
nnoremap <space>p :Unite -start-insert file_rec/async<cr>
" Yankring
let g:unite_source_history_yank_enable = 1
nnoremap <space>y :Unite history/yank<cr>
" Grep
nnoremap <space>/ :Unite grep:.<cr>
" Buffer switching
nnoremap <space>b :Unite -quick-match buffer<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove trailing whitespace
nnoremap <space>s :%s/\s\+$//g<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ruler         "Always show current position

set ignorecase    "Ignore case when searching
set smartcase

set hlsearch      "Highlight search things

set incsearch     "Make search act like search in modern browsers
set nolazyredraw  "Don't redraw while executing macros

set magic         "Set magic on, for regular expressions

set showmatch     "Show matching bracets when text indicator is over them
set mat=2         "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax highlighting

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set lbr
set tw=500

set ai   "Auto indent
set si   "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype custom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType html       setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType json       setlocal shiftwidth=2 tabstop=2
autocmd FileType xml        setlocal shiftwidth=2 tabstop=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Extra file extension associations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.ftl setlocal ft=html
au BufNewFile,BufRead *.hbs setlocal ft=html
au BufNewFile,BufRead *.m   setlocal ft=mason
au BufNewFile,BufRead *.mi  setlocal ft=mason
au BufNewFile,BufRead *.md  setlocal ft=markdown
