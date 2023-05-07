#!/usr/bin/env bash

function __main {
  declare xdg_config_home=${XDG_CONFIG_HOME:-${HOME}/.config}
  declare profile_base_dir

  if [ -d "${xdg_config_home}/${USER}/profile.d" ]; then
    profile_base_dir="${xdg_config_home}/${USER}"
  else
    profile_base_dir=$xdg_config_home
  fi

  if [ -f "${profile_base_dir}/profile.d/functions" ]; then
    # shellcheck disable=SC1091
    source "${profile_base_dir}/profile.d/functions"
  fi

  while read -r; do
    # shellcheck disable=SC1090
    source "$REPLY"
  done < <(
    find "${profile_base_dir}/profile.d" -maxdepth 1 -follow \
        ! -type d -name '[^.]*.sh' 2>/dev/null
      )

  if [ -n "$SHELL" ]; then
    while read -r; do
      # shellcheck disable=SC1090
      source "$REPLY"
    done < <( \
      find "${profile_base_dir}/$(basename "$SHELL")-profile.d" -maxdepth 1 -follow \
          ! -type d -name '[^.]*.sh' 2>/dev/null
        )
  fi

  unset REPLY

  if [ -f "${profile_base_dir}/profile.d/cleanup" ]; then
    # shellcheck disable=SC1091
    source "${profile_base_dir}/profile.d/cleanup"
  fi

  export PROMPT_COMMAND="source ${profile_base_dir}/prompt-command.sh"
}

__main
unset -f __main
