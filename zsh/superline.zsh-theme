# ------------------------------------------------------------------------------
# PROMPTS
# Some variables and config used by prompts
# ------------------------------------------------------------------------------

# PROMPT
if [ ! -n "${SUPERLINE_PROMPT_CHAR+1}" ]; then
  SUPERLINE_PROMPT_CHAR="\$"
fi
if [ ! -n "${SUPERLINE_PROMPT_ROOT+1}" ]; then
  SUPERLINE_PROMPT_ROOT=true
fi

# TIME
if [ ! -n "${SUPERLINE_TIME_SHOW+1}" ]; then
  SUPERLINE_TIME_SHOW=true
fi
if [ ! -n "${SUPERLINE_TIME_BG+1}" ]; then
  SUPERLINE_TIME_BG=black
fi
if [ ! -n "${SUPERLINE_TIME_FG+1}" ]; then
  SUPERLINE_TIME_FG=white
fi

# DIR
if [ ! -n "${SUPERLINE_DIR_SHOW+1}" ]; then
  SUPERLINE_DIR_SHOW=true
fi
if [ ! -n "${SUPERLINE_DIR_BG+1}" ]; then
  SUPERLINE_DIR_BG=green
fi
if [ ! -n "${SUPERLINE_DIR_FG+1}" ]; then
  SUPERLINE_DIR_FG=black
fi
if [ ! -n "${SUPERLINE_DIR_CONTEXT_SHOW+1}" ]; then
  SUPERLINE_DIR_CONTEXT_SHOW=false
fi
if [ ! -n "${SUPERLINE_DIR_EXTENDED+1}" ]; then
  SUPERLINE_DIR_EXTENDED=false
fi

# GIT
if [ ! -n "${SUPERLINE_GIT_SHOW+1}" ]; then
  SUPERLINE_GIT_SHOW=true
fi
if [ ! -n "${SUPERLINE_GIT_BG+1}" ]; then
  SUPERLINE_GIT_BG=cyan
fi
if [ ! -n "${SUPERLINE_GIT_FG+1}" ]; then
  SUPERLINE_GIT_FG=black
fi
if [ ! -n "${SUPERLINE_GIT_EXTENDED+1}" ]; then
  SUPERLINE_GIT_EXTENDED=true
fi

# GIT PROMPT
if [ ! -n "${SUPERLINE_GIT_PREFIX+1}" ]; then
  ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
  ZSH_THEME_GIT_PROMPT_PREFIX=""
else
  ZSH_THEME_GIT_PROMPT_PREFIX=$SUPERLINE_GIT_PREFIX
fi
if [ ! -n "${SUPERLINE_GIT_SUFFIX+1}" ]; then
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
else
  ZSH_THEME_GIT_PROMPT_SUFFIX=$SUPERLINE_GIT_SUFFIX
fi
if [ ! -n "${SUPERLINE_GIT_DIRTY+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DIRTY=" 💥 "
else
  ZSH_THEME_GIT_PROMPT_DIRTY=$SUPERLINE_GIT_DIRTY
fi
if [ ! -n "${SUPERLINE_GIT_CLEAN+1}" ]; then
  ZSH_THEME_GIT_PROMPT_CLEAN=" 💎"
else
  ZSH_THEME_GIT_PROMPT_CLEAN=$SUPERLINE_GIT_CLEAN
fi

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Git
prompt_git() {
  if [[ $SUPERLINE_GIT_SHOW == false ]] then
    return
  fi

  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_segment $SUPERLINE_GIT_BG $SUPERLINE_GIT_FG

    if [[ $SUPERLINE_GIT_EXTENDED == true ]] then
      echo -n $(git_prompt_info)$(git_prompt_status)
    else
      echo -n $(git_prompt_info)
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  if [[ $SUPERLINE_DIR_SHOW == false ]] then
    return
  fi

  local dir='📖  '
  local _context="$(context)"
  [[ $SUPERLINE_DIR_CONTEXT_SHOW == true && -n "$_context" ]] && dir="${dir}${_context}:"
  [[ $SUPERLINE_DIR_EXTENDED == true ]] && dir="${dir}%4(c::)%3c" || dir="${dir}%1~"
  prompt_segment $SUPERLINE_DIR_BG $SUPERLINE_DIR_FG $dir
}

prompt_time() {
  if [[ $SUPERLINE_TIME_SHOW == false ]] then
    return
  fi

  prompt_segment $SUPERLINE_TIME_BG $SUPERLINE_TIME_FG '🕙  %D{%H:%M:%S} '
}

# Prompt Character
prompt_char() {
  local bt_prompt_char

  if [[ ${#SUPERLINE_PROMPT_CHAR} -eq 1 ]] then
    bt_prompt_char=" 👉 "
  fi

  if [[ $SUPERLINE_PROMPT_ROOT == true ]] then
    bt_prompt_char="%(!.%F{red}#.%F{green}${bt_prompt_char}%f)"
  fi

  echo -n $bt_prompt_char
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  prompt_time
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt)%{${fg_bold[default]}%}$(prompt_char) %{$reset_color%}'
