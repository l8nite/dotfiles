" , is easier than \
let mapleader=","

" save keystrokes
nnoremap ; : 

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Vundle plugin manager
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
Plugin 'tpope/vim-fugitive'

Bundle 'Lokaltog/vim-easymotion'

Plugin 'L9'

Bundle 'vim-ruby/vim-ruby'

Bundle 'tpope/vim-rails'
set completefunc=syntaxcomplete#Complete

Bundle 'vim-scripts/The-NERD-Commenter'

let g:indent_guides_guide_size = 1
Bundle 'nathanaelkane/vim-indent-guides'
map <silent><F7> <leader>ig

Bundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

Bundle 'kana/vim-textobj-user'

Bundle 'jwhitley/vim-matchit'

Bundle 'nelstrom/vim-textobj-rubyblock'

Bundle 'slim-template/vim-slim'

Bundle 'kchmck/vim-coffee-script'

Bundle 'jamessan/vim-gnupg'


" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

filetype plugin indent on
syntax on

set encoding=utf8
set backspace=indent,eol,start " allow backspacing over everything

"in order to switch between buffers with unsaved change
set nobackup
set noswapfile
set hidden

" 1 tab to 2 space for ruby
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
"set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

set nonumber      " show line numbers

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
set nowrap

" use Q to format paragraph or visual selection
vmap Q gq
nmap Q gqap

" stop forgetting to sudo
cmap w!! w !sudo tee % >/dev/null

if &t_Co >= 256 || has("gui_running")
  colorscheme mustang
endif

" trailing whitespace killer
autocmd FileType c,cpp,java,php,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

" auto-sign gpg files
autocmd User GnuPG let b:GPGOptions += ["sign"]

runtime macros/matchit.vim
