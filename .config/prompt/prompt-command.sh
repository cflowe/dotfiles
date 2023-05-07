#!/usr/bin/env bash

function __main {
  declare i
  declare xdg_config_home=${XDG_CONFIG_HOME:-${HOME}/.config}
  declare prompt_base_dir

  if [ -d "${xdg_config_home}/${USER}/prompt.d" ]; then
    prompt_base_dir="${xdg_config_home}/${USER}"
  else
    prompt_base_dir=$xdg_config_home
  fi

  # builtin-prompt-config init
  if [ -f "${prompt_base_dir}/prompt.d/init" ]; then
    # shellcheck disable=SC1091
    source "${prompt_base_dir}/prompt.d/init"
  fi

  for i in "${prompt_base_dir}/prompt.d/"*.sh; do
    if [ -r "$i" ]; then
      # shellcheck disable=SC1090
      source "$i"
    fi
  done

  if [ -f "${prompt_base_dir}/prompt.d/fini" ]; then
    # shellcheck disable=SC1091
    source "${xdg_config_home}/prompt.d/fini"
  fi
}

__main
unset -f __main
