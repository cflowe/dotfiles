#!/usr/bin/env bash

function __main {
  declare xdg_config_home=${XDG_CONFIG_HOME:-${HOME}/.config}

  if [ -f "${xdg_config_home}/profile.d/functions" ]; then
    # shellcheck disable=SC1090
    source "${xdg_config_home}/profile.d/functions"
  fi

  while read -r; do
    # shellcheck disable=SC1090
    source "$REPLY"
  done < <(
    find "${xdg_config_home}/profile.d" -maxdepth 1 -follow \
        ! -type d -name '[^.]*.sh' 2>/dev/null
      )

  if [ -n "$SHELL" ]; then
    while read -r; do
      # shellcheck disable=SC1090
      source "$REPLY"
    done < <( \
      find "${xdg_config_home}/$(basename "$SHELL")-profile.d" -maxdepth 1 -follow \
          ! -type d -name '[^.]*.sh' 2>/dev/null
        )
  fi

  unset REPLY

  if [ -f "${xdg_config_home}/profile.d/cleanup" ]; then
    # shellcheck disable=SC1090
    source "${xdg_config_home}/profile.d/cleanup"
  fi

  export PROMPT_COMMAND="source ${xdg_config_home}/prompt-command.sh"
}

__main
unset -f __main
