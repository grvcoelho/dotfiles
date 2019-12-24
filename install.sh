#!/bin/sh

DOTFILES_REPO=grvcoelho/dotfiles
DOTFILES=~/.dotfiles

main() {
  # ask_for_sudo
  # install_xcode_command_line_tools
  # clone_dotfiles_repo
  # install_homebrew
  # install_homebrew_packages
  # setup_fish_shell
  # setup_macos_defaults
  # setup_vim
  # setup_tmux
  setup_git
}

function ask_for_sudo() {
  info "Asking for sudo"

  if sudo --validate; then
    while true; do sudo --non-interactive true; \
      sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo password acquired"
  else
    error "Could not acquire sudo password"
  fi
}

function install_xcode_command_line_tools() {
  info "Installing Xcode command line tools"

  if softwareupdate --history | grep --silent "Command Line Tools"; then
    success "Xcode command line tools already exists"
  else
    xcode-select --install
    read -n 1 -s -r -p "Press any key once installation is complete"

    if softwareupdate --history | grep --silent "Command Line Tools"; then
      success "Xcode command line tools installation succeeded"
    else
      error "Xcode command line tools installation failed"
      exit 1
    fi
  fi
}

function clone_dotfiles_repo() {
  info "Cloning dotfiles repository into ${DOTFILES}"
  if test -e $DOTFILES; then
    substep "${DOTFILES} already exists, skipping"
  else
    if git clone "https://github.com/$DOTFILES_REPO.git" $DOTFILES && \
      git -C $DOTFILES remote set-url origin "git@github.com:$DOTFILES_REPO.git"; then
      success "Dotfiles repository cloned into ${DOTFILES}"
    else
      error "Dotfiles repository cloning failed"
      exit 1
    fi
  fi
}

function install_homebrew() {
  info "Installing Homebrew"
  if hash brew 2>/dev/null; then
    success "Homebrew already exists"
  else
    url=https://raw.githubusercontent.com/Homebrew/install/master/install
    if yes | /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
      success "Homebrew installation succeeded"
    else
      error "Homebrew installation failed"
      exit 1
    fi
  fi
}

function install_homebrew_packages() {
  info "Installing Brewfile packages"

  TAP=${DOTFILES}/brew/brewfile_tap
  BREW=${DOTFILES}/brew/brewfile_brew
  CASK=${DOTFILES}/brew/brewfile_cask

  if hash parallel 2>/dev/null; then
    substep "parallel already exists"
  else
    if brew install parallel &> /dev/null; then
      printf 'will cite' | parallel --citation &> /dev/null
      substep "parallel installation succeeded"
    else
      error "parallel installation failed"
      exit 1
    fi
  fi

  if (echo $TAP; echo $BREW; echo $CASK) | parallel --verbose --linebuffer -j 4 brew bundle check --file={} &> /dev/null; then
    success "Brewfile packages are already installed"
  else
    if brew bundle --file="$TAP"; then
      substep "Brewfile tap installation succeeded"

      export HOMEBREW_CASK_OPTS="--no-quarantine"

      if (echo $BREW; echo $CASK) | parallel --verbose --linebuffer -j 3 brew bundle --file={}; then
        success "Brewfile packages installation succeeded"
      else
        error "Brewfile packages installation failed"
        exit 1
      fi
    else
      error "Brewfile tap installation failed"
      exit 1
    fi
  fi
}

function setup_fish_shell() {
  info "Fish shell setup"

  if grep --quiet fish <<< "$SHELL"; then
    success "Fish shell already exists"
  else
    substep "Adding Fish executable to /etc/shells"
    user=$(whoami)

    if grep --fixed-strings --line-regexp --quiet \
      "/usr/local/bin/fish" /etc/shells; then
      substep "Fish executable already exists in /etc/shells"
    else
      if echo /usr/local/bin/fish | sudo tee -a /etc/shells > /dev/null; then
        substep "Fish executable successfully added to /etc/shells"
      else
        error "Failed to add Fish executable to /etc/shells"
        exit 1
      fi
    fi

    substep "Switching shell to Fish for \"${user}\""
    if sudo chsh -s /usr/local/bin/fish "$user"; then
      success "Fish shell successfully set for \"${user}\""
    else
      error "Please try setting Fish shell again"
    fi

    substep "Symlinking fish config files"
    symlink "fish" "${DOTFILES}/fish" ~/.config/fish
  fi
}

function setup_macos_defaults() {
  info "Updating macOS defaults"

  current_dir=$(pwd)
  cd ${DOTFILES}/macos

  if sh defaults.sh; then
    cd $current_dir
    success "macOS defaults updated successfully"
  else
    cd $current_dir
    error "macOS defaults update failed"
    exit 1
  fi
}

function setup_vim() {
  info "Installing and setting up neovim"
  plug_location=~/.local/share/nvim/site/autoload/plug.vim

  if test ! -e "$plug_location"; then
    substep "Installing Plug.vim"

    curl -fLo "$plug_location" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    success "Plug.vim installed successfully"
  else
    substep "Plug.vim already installed, skipping"
  fi

  substep "Symlinking nvim config files"
  symlink "nvim" "${DOTFILES}/nvim" ~/.config/nvim

  substep "Installing vim plugins"
  nvim +PlugInstall +qa
}

function setup_tmux() {
  substep "Symlinking tmux config files"
  symlink "tmux" "${DOTFILES}/tmux/tmux.conf" ~/.tmux.conf
  symlink "tmux local" "${DOTFILES}/tmux/local.tmux.conf" ~/.tmux.conf.local
}

function setup_git() {
  substep "Symlinking git config files"
  symlink "git" "${DOTFILES}/git/gitconfig" ~/.gitconfig
}

function symlink() {
  application=$1
  point_to=$2
  destination=$3
  destination_dir=$(dirname "$destination")

  if test ! -e "$destination_dir"; then
    substep "Creating ${destination_dir}"
    mkdir -p "$destination_dir"
  fi

  if rm -rf "$destination" && ln -s "$point_to" "$destination"; then
    substep "Symlinking for \"${application}\" done"
  else
    error "Symlinking for \"${application}\" failed"
    exit 1
  fi
}

function coloredEcho() {
  local exp="$1";
  local color="$2";
  local arrow="$3";
  if ! [[ $color =~ '^[0-9]$' ]] ; then
    case $(echo $color | tr '[:upper:]' '[:lower:]') in
      black) color=0 ;;
      red) color=1 ;;
      green) color=2 ;;
      yellow) color=3 ;;
      blue) color=4 ;;
      magenta) color=5 ;;
      cyan) color=6 ;;
      white|*) color=7 ;; # white or invalid color
    esac
  fi
  tput bold;
  tput setaf "$color";
  echo "$arrow $exp";
  tput sgr0;
}

function info() {
  coloredEcho "$1" blue "===>"
}

function substep() {
  coloredEcho "$1" magenta "---"
}

function success() {
  coloredEcho "$1" green "===>"
}

function error() {
  coloredEcho "$1" red "===>"
}

main "$@"