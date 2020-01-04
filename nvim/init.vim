" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

" Fix issues with vim and the Fish Shell
if $SHELL =~ 'fish'
  set shell=/bin/sh
endif

" Don't make vim vi-compatibile
set nocompatible

" Maybe makes drawing faster
set lazyredraw

" Use unix line endings
set fileformat=unix

" Enable syntax highlighting
syntax on

" Allow `backspace` in insert mode
set backspace=indent
set backspace+=eol
set backspace+=start

" Set local directories for backup and swap files
set backupdir=~/.config/nvim/null
set directory=~/.config/nvim/null
set undodir=~/.config/nvim/null

" Display incomplete commands
set showcmd

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

" Infinite undo/redo
if has('persistent_undo')
  let target_path = expand('~/.config/nvim/null/')

  if !isdirectory(target_path)
    call system('mkdir -p ' . target_path)
  endif

  let &undodir = target_path
  set undofile
endif

" ----------------------------------------------------------------------
" | Plugins                                                            |
" ----------------------------------------------------------------------

" Start Plug bundles
call plug#begin('~/.vim/plugged')
  " Search accross and navigate to files and buffers within the project
  Plug '/usr/local/opt/fzf' " Must have fzf installed
  Plug 'junegunn/fzf.vim'

  " Perform ag searches and place them in Quickfix menus
  Plug 'rking/ag.vim'

  " Align things
  Plug 'junegunn/vim-easy-align'

  " Create a file-tree
  Plug 'scrooloose/nerdtree'

  " Help commenting across multiple filetypes
  Plug 'tomtom/tcomment_vim'

  " Perform vim commands surround elements
  Plug 'tpope/vim-surround'

  " Create a seemlessly navigation between vim and tmux panes
  Plug 'christoomey/vim-tmux-navigator'

  " Autoclose things like parentheses, quotes, etc
  Plug 'cohama/lexima.vim'

  " Display a more complete and beautiful status bar
  Plug 'vim-airline/vim-airline'

  " Provide themes for vim-airline plugin
  Plug 'vim-airline/vim-airline-themes'

  " Toggles between relative and absolute line numbers
  Plug 'jeffkreeftmeijer/vim-numbertoggle'

  " Provide base16 colorschemes
  Plug 'chriskempson/base16-vim'

  " Asynchronous linting and make framework for Neovim/Vim
  Plug 'neomake/neomake'

  " A fancy start screen
  Plug 'mhinz/vim-startify'

  " Language support: many languages
  Plug 'sheerun/vim-polyglot'

  " Language support: Go
  Plug 'fatih/vim-go'
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

    set guifont=Roboto_for_Powerline:h13
    set linespace=2

    "Access colors present in 256 colorspace
    let base16colorspace=256
    colorscheme base16-dracula
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
let mapleader = "\<Space>"

" Go to start of line with H and to the end with L
noremap H ^
noremap L $

" Yank and paste to system's clipboard
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>P "+P

" Navigate through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Use qq to record, q to stop, Q to play a macro
nnoremap Q @q
vnoremap Q :normal @q

" Use tab and shift tab to indent and de-indent code
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv
inoremap <S-Tab> <C-d>

" Use `u` to undo, use `U` to redo, mind = blown
nnoremap U <C-r>

" Create windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>m <C-w>s<C-w>j
nnoremap <leader>d <C-w>q

" Edit .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Reload .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" Map <C-C> to <esc>
noremap <C-C> <esc>

" Sometimes I press q:, Q: or :Q instead of :q, I never want to open related functionality
map <silent> q: :q<Cr>
map <silent> Q: :q<Cr>
map <silent> :Q :q<Cr>

" Save using <C-s> in every mode
" When in operator-pending or insert, takes you to normal mode
nnoremap <C-s> :write<Cr>
vnoremap <C-s> <C-c>:write<Cr>
inoremap <C-s> <Esc>:write<Cr>
onoremap <C-s> <Esc>:write<Cr>

" ----------------------------------------------------------------------
" | Nvim specific
" ----------------------------------------------------------------------

if has('nvim')
  " Make ctrl-h great again
  nmap <BS> <C-W>h
  nmap <bs> :<c-u>TmuxNavigateLeft<cr>
endif

" ----------------------------------------------------------------------
" | Plugin - vim-go
" ----------------------------------------------------------------------

let g:go_fmt_command = "goimports"

" ----------------------------------------------------------------------
" | Plugin - NerdTree                                                  |
" ----------------------------------------------------------------------

noremap <leader>t :NERDTreeToggle<CR>

" Don't fuck up vim's default file browser
let g:NERDTreeHijackNetrw = 0

" ----------------------------------------------------------------------
" | Plugin - Airline                                                   |
" ----------------------------------------------------------------------

let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_summerfruit'
autocmd BufEnter * :AirlineRefresh

" ----------------------------------------------------------------------
" | Plugin - EasyAlign                                                   |
" ----------------------------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ----------------------------------------------------------------------
" | Plugin - FZF                                                       |
" ----------------------------------------------------------------------

noremap <C-p> :Files<CR>
noremap <leader>f :Files<CR>

" ----------------------------------------------------------------------
" | Plugin - Number Toggle                                             |
" ----------------------------------------------------------------------

let g:NumberToggleTrigger="<leader>ll"

" ----------------------------------------------------------------------
" | Plugin - vim-go                                                    |
" ----------------------------------------------------------------------

let g:go_fmt_command = "goimports"

" ----------------------------------------------------------------------
" | Plugin - Ag                                                        |
" ----------------------------------------------------------------------

noremap <C-F> :Ag!<space>
