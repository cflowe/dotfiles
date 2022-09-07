#!/usr/bin/env bash

function __main {
  declare i
  declare xdg_config_home=${XDG_CONFIG_HOME:-${HOME}/.config}

  # builtin-prompt-config init
  if [ -f "${xdg_config_home}/prompt.d/init" ]; then
    # shellcheck disable=SC1090
    source "${xdg_config_home}/prompt.d/init"
  fi

  for i in "${xdg_config_home}/prompt.d/"*.sh; do
    if [ -r "$i" ]; then
      # shellcheck disable=SC1090
      source "$i"
    fi
  done

  if [ -f "${xdg_config_home}/prompt.d/fini" ]; then
    # shellcheck disable=SC1090
    source "${xdg_config_home}/prompt.d/fini"
  fi
}

__main
unset -f __main
