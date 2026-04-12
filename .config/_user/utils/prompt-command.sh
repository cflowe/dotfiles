#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091
main() {
  declare xdg_config_home=${XDG_CONFIG_HOME:-${HOME}/.config}
  declare prompt_base_dir="${xdg_config_home}/_user/shell/prompt.d"
  declare file

  file="${prompt_base_dir}/init"
  if [ -r "$file" ] && [ -x "$file" ]; then
    source "$file"
  fi

  for file in "${prompt_base_dir}/"*.sh; do
    if [ -r "$file" ] && [ -x "$file" ]; then
      source "$file"
    fi
  done

  file="${prompt_base_dir}/fini"
  if [ -r "file" ] && [ -x "file" ]; then
    source "$file"
  fi
}

main "$@"
