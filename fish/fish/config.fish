# Set base16-shell theme
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-paraiso.sh
end

# Set z plugin path
set -gx Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

# Set go path
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -gx PATH $GOBIN $PATH
