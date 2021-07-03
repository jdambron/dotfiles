if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'gruvbox-community/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'justinmk/vim-dirvish'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'

call plug#end()

" General settings
set number " Show line numbers
set relativenumber " Show relative numbers
set noswapfile " Don't use swapfile
set nobackup " Don't create backup files
set nowritebackup " Don't write backup
set autowrite " Automatically save before :next, :make etc.
set showmatch " Show matching brackets
set scrolloff=8 " Keep lines above and below cursor
set updatetime=750 " Improve UX with more reactive updates
set nowrap " Display long lines as one line
set signcolumn=yes "Display an additional column (useful for linting)

" A better menu in command mode
set wildmode=longest:full,full

" Use the OS clipboard
set clipboard^=unnamed,unnamedplus

" Tab config
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab

" Search settings
set ignorecase " Search case insensitive...
set smartcase " ... but not when search pattern contains upper case characters
nnoremap <esc><esc> :noh<return><esc>

colorscheme gruvbox " Set default colorscheme

"netrw
let g:netrw_banner=0
let g:netrw_winsize=20
let g:netrw_liststyle=3
let g:netrw_localrmdir='rm -r'
let g:netrw_browse_split = 2
"toggle netrw on the left side of the editor
nnoremap <leader>n :Lexplore<CR>

"gruvbox config
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

if has('gui_running')
	" Make shift-insert work like in Xterm
	map <S-Insert> <MiddleMouse>
	map! <S-Insert> <MiddleMouse>
	set background=light
else
	set background=dark
endif

" Use templates
autocmd BufNewFile *src/site/blog/*.md 0r ~/.config/nvim/skeletons/blog-post.md
