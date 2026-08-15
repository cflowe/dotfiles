#!/usr/bin/env bash

# shellcheck disable=SC1090
_main() {
  export _USER_CONFIG_DIR="${_USER_CONFIG_DIR:-"${XDG_CONFIG_HOME:-${HOME}/.config}/_user"}"

  source "${_USER_CONFIG_DIR}/utils/functions"

  export _USER_SHELL_DIR="${_USER_SHELL_DIR:-"${_USER_CONFIG_DIR}/shell"}"

  declare file

  case "$0" in
  */bash) file=${BASH_SOURCE[0]};;
  *) file=$0;;
  esac

  case "$file" in
  */prompt-command.sh) _main_prompt_command "$@";;
  *) _main_init_profile "$@";;
  esac
}

_main_init_profile() {
  if [ "${_USER_CONFIG_DEBUG:-}" == 'true' ]; then
    set -x
  fi

  unset PROMPT_COMMAND
  export PS1='\[\033[01;32m\]${_USER_PS1_INFIX:-}\u@\h\[\033[01;34m\]:\W>\[\033[00m\] '

  _source_script "${_USER_SHELL_DIR}/profile.d/functions"
  _source_scripts_dir "${_USER_SHELL_DIR}/profile.d"
  _source_scripts_dir "${_USER_SHELL_DIR}/contrib/profile.d"
  _source_script "${_USER_SHELL_DIR}/profile.d/cleanup"
}

_main_prompt_command() {
  _source_scripts_dir "${_USER_SHELL_DIR}/prompt.d"
  _source_scripts_dir "${_USER_SHELL_DIR}/contrib/prompt.d"
}

_main "$@"

unset -f _main
unset -f _main_init_profile
unset -f _main_prompt_command

_cleanup_fns
