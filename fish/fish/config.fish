# Set base16-shell theme
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-paraiso.sh
end

# Set z plugin path
set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh
