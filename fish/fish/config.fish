# Set base16-shell theme
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-dracula.sh
end

# Set go path
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -gx PATH $GOBIN $PATH

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/grvcoelho/.nvm/versions/node/v7.8.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /Users/grvcoelho/.nvm/versions/node/v7.8.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/grvcoelho/.nvm/versions/node/v7.8.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /Users/grvcoelho/.nvm/versions/node/v7.8.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
