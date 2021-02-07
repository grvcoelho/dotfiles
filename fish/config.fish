# --------------–-------–--------–--------–-------–--–-----
# Configuration
# --------------–-------–--------–--------–-------–--–-----

# Setup nvm
set -x NVM_DIR ~/.nvm
nvm use default --silent &

# --------------–-------–--------–--------–-------–--–-----
# Abbreviations
# --------------–-------–--------–--------–-------–--–-----

# User functions
abbr j jump
abbr kp kill-process
abbr gi gitignore

# Git
abbr ga 'git add'
abbr gs 'git status'
abbr gc 'git commit'
abbr gco 'git checkout'
abbr gp 'git push'
abbr gpl 'git pull'
abbr gf 'git fetch'
abbr gl 'git log'
abbr gll 'git log --graph --decorate --pretty=oneline --abbrev-commit'

# Fish
abbr unset 'set --erase'

# Tmux
abbr ta 'tmux attach -t'
abbr tl 'tmux list-sessions'
abbr ts 'tmux new-session -s'
abbr tkss 'tmux kill-session -t'

# Vim
abbr vim 'nvim'
