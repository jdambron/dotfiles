" Plugins settings
filetype on

" General settings
set encoding=utf-8 " Force UTF-8 encoding
set noerrorbells " No beeps
set number " Show line numbers
set showcmd " Show me what I'm typing
set showmode " Show current mode
set noswapfile " Don't use swapfile
set nobackup " Don't create backup files
set nowritebackup
set autowrite " Automatically save before :next, :make etc.
set autoread " Automatically reread changed files without asking me anything
set laststatus=2 "Always show status line
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
set ttyfast
set autoindent " Autoindentation
set showmatch " Show matching brackets

" Search settings
set incsearch " Shows the match while typing
set hlsearch " Highlight found searches
set ignorecase " Search case insensitive...
set smartcase " ... but not when search pattern contains upper case characters

syntax on " Enable syntax highlighting
colorscheme desert " Set default colorscheme

set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing

" Now we set some defaults for the editor
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

if has('gui_running')
  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif
