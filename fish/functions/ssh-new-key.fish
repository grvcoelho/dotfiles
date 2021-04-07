function ssh-new-key
  set email "guilhermervcoelho@gmail.com"

  if not test -z $argv[1]
    set email $argv[1]
  end

  if not test -e ~/.ssh/id_ed25519
    ssh-keygen -t ed25519 -C $email
  end

  if test -e ~/.ssh/id_ed25519
    touch ~/.ssh/config
    echo "Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
    " >> ~/.ssh/config
  end

  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK

  # Add ssh key to ssh-agent
  ssh-add -K ~/.ssh/id_ed25519

  # Copy the public key
  pbcopy < ~/.ssh/id_ed25519.pub

  echo "✅ SSH Keys created and public key copied to clipboard"
end
