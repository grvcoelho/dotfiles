# Set base16-shell theme
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-dracula.sh
end

# Set go path
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -gx PATH $GOBIN $PATH
