" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

" Don't make vim vi-compatibile
set nocompatible

" Enable syntax highlighting
syntax on

" Allow `backspace` in insert mode
set backspace=indent
set backspace+=eol
set backspace+=start

" Set local directories for backup and swap files
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

" Display incomplete commands
set showcmd

" Display the mode you're in
set showmode

"Avoid all the hit-enter prompts
set shortmess=aAItW

" Handle multiple buffers better
set hidden

" Enhanced command line completion
set wildmenu

" Complete files like a shell
set wildmode=list:longest

" Increase command line history
set history=50

" Enable search highlighting
set hlsearch
set incsearch

" Search case-insensitive
set ignorecase

" Search case-sensitive if expression contains a capital letter
set smartcase

" Show line numbers
set number

" Show cursor position
set ruler

" Turn off line wrapping
set nowrap

" Show 3 lines of context around the cursor.
set scrolloff=3

" Set the terminal's title
set title

" Use visual bell instead of audible bell
set visualbell

" Enable mouse in all modes
set mouse=a

" Show the status line all the time
set laststatus=2

" Set global <TAB> settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Use decent folding
set foldmethod=indent

" Files open expanded
set foldlevelstart=50

" Show the status line all the time
set laststatus=2

" Useful status information at bottom of screen
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

" Always diff using vertical mode
set diffopt+=vertical

" ----------------------------------------------------------------------
" | Plugins                                                            |
" ----------------------------------------------------------------------

" Start Plug bundles
call plug#begin('~/.vim/plugged')

" Productivity Plugins
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Programming Languages Plugins
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'

" Colors and Appearance Plugins
Plug 'dracula/vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Add plugins to &runtimepath
call plug#end()

" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! StripTrailingWhitespaces()
  " Save last search and cursor position
  let searchHistory = @/
  let cursorLine = line('.')
  let cursorColumn = col('.')

  " Strip trailing whitespaces
  %s/\s\+$//e

  " Restore previous search history and cursor position
  let @/ = searchHistory
  call cursor(cursorLine, cursorColumn)
endfunction

" ----------------------------------------------------------------------
" | Automatic Commands                                                 |
" ----------------------------------------------------------------------

if has('autocmd')
  " Automatically reload the configurations from the
  " `~/.vimrc` and `~/.gvimrc` files whenever they are changed
  augroup auto_reload_vim_configs
    autocmd!
    autocmd BufWritePost vimrc source $MYVIMRC

    if has('gui_running')
      autocmd BufWritePost gvimrc source $MYGVIMRC
    endif
  augroup END

  " Automatically set the color scheme
  augroup set_font
    autocmd!

    set guifont=Droid_Sans_Mono_for_Powerline:h13
    set linespace=2
    colorscheme dracula
    autocmd BufEnter * colorscheme dracula
  augroup END

  " Use javascript syntax for json files

  augroup json
    autocmd!
    au BufRead,BufNewFile *.json set ft=json syntax=javascript
  augroup END

  " Automatically strip the trailing whitespaces when files are saved
  augroup strip_trailing_whitespaces
    " Exclude markdown as it needs to be aware of whitespaces
    let excludedFileTypes = [ 'mkd.markdown' ]

    " Only strip the trailing whitespaces if the file type is
    " not in the excluded file types list
    autocmd!
    autocmd BufWritePre * if index(excludedFileTypes, &ft) < 0 | :call StripTrailingWhitespaces()
  augroup END
endif

" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------

" Set map leader
let mapleader = ","

" Navigate through tabs
nnoremap <leader>t :tabnew<cr>
nnoremap <leader>c :tabclose<cr>
nnoremap <leader>n :tabnext<cr>
nnoremap <leader>p :tabprevious<cr>

" Go to start of line with H and to the end with L
noremap H ^
noremap L $

" Navigate through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Create windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>m <C-w>s<C-w>j
nnoremap <leader>d <C-w>q

" Toggle folds
nnoremap <Space> za

" Open all folds
nnoremap zO zR

" Close all folds
nnoremap zC zM

" Close current fold
nnoremap zc zc

" Close all folds except the current one
nnoremap zf mzzMzvzz

" Edit .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Reload .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" Map <C-C> to <esc>
noremap <C-C> <esc>

" Enter full-screen
nnoremap <leader>fs :set lines=999 columns=999<cr>

" ----------------------------------------------------------------------
" | Plugin - Fugitive                                                  |
" ----------------------------------------------------------------------

nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>ga :Gadd<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gci :Gcommit<cr>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gm :Gmove
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>grm :Gremove<cr>
nnoremap <leader>gp :Git push

" ----------------------------------------------------------------------
" | Plugin - Vim JSX                                                   |
" ----------------------------------------------------------------------

" Let jsx syntax for non-jsx files (i.e: .js files)
let g:jsx_ext_required = 0

" ----------------------------------------------------------------------
" | Plugin - NerdTree                                                  |
" ----------------------------------------------------------------------

noremap <leader>ft :NERDTreeToggle<CR>

" Don't fuck up vim's default file browser

let g:NERDTreeHijackNetrw = 0

" ----------------------------------------------------------------------
" | Plugin - Airline                                                   |
" ----------------------------------------------------------------------

let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
autocmd BufEnter * :AirlineRefresh

" ----------------------------------------------------------------------
" | Plugin - CtrlP                                                     |
" ----------------------------------------------------------------------

" Work not only in ancestor directories of the working directory
let g:ctrlp_working_path_mode = 'a'

" Ignore custom folders
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store'

" Ignore git ignored folders
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" ----------------------------------------------------------------------
" | Plugin - Yanstack                                                  |
" ----------------------------------------------------------------------

nmap <C-M> <Plug>yankstack_substitute_older_paste
nmap <C-N> <Plug>yankstack_substitute_newer_paste

" Don't use default mappings
let g:yankstack_map_keys = 0

" ----------------------------------------------------------------------
" | Plugin - Number Toggle                                             |
" ----------------------------------------------------------------------

let g:NumberToggleTrigger="<leader>ll"

" ----------------------------------------------------------------------
" | Plugin - Toggle List                                               |
" ----------------------------------------------------------------------

let g:toggle_list_copen_command="Copen"

" ----------------------------------------------------------------------
" | Plugin - Ag                                                        |
" ----------------------------------------------------------------------

noremap <C-F> :Ag!<space>
