" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

" Don't make vim vi-compatibile
set nocompatible

" Set map leader
let mapleader = ","

" Enable syntax highlighting
syntax on

" Set the colorscheme for gui and terminal sessions
colorscheme dracula
autocmd BufEnter * colorscheme dracula

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

" Show the status line all the time
set laststatus=2
" Useful status information at bottom of screen
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

" Set global <TAB> settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Files open expanded
set foldlevelstart=50
" Use decent folding
set foldmethod=indent

" Show the status line all the time
set laststatus=2
" Useful status information at bottom of screen
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

" Always diff using vertical mode
set diffopt+=vertical

" ----------------------------------------------------------------------
" | Plugins			                                                   |
" ----------------------------------------------------------------------

" Start Plug bundles
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'zenorocha/dracula-theme', {'rtp': 'vim/'}

" Add plugins to &runtimepath
call plug#end()
