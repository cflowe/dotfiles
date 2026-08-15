#!/usr/bin/env bash

_main() {
  : "${_USER_CONFIG_DIR:="${XDG_CONFIG_HOME:-${HOME}/.config}/_user"}"
  export _USER_CONFIG_DIR

  _USER_DEVBOX_SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
  if [ -z "$_USER_DEVBOX_SCRIPT_DIR" ]; then
    echo 'Unable to determine the value of environment varaiable _USER_DEVBOX_SCRIPT_DIR.' >&2
    return 1
  fi
  export _USER_DEVBOX_SCRIPT_DIR

  _USER_DEVBOX_BASEDIR=$(dirname "$_USER_DEVBOX_SCRIPT_DIR")
  if [ -z "$_USER_DEVBOX_BASEDIR" ]; then
    echo 'Unable to determine the value of environment varaiable _USER_DEVBOX_BASEDIR.' >&2
    return 1
  fi
  export _USER_DEVBOX_BASEDIR

  export _USER_DEVBOX_WORKSPACE="${_USER_DEVBOX_WORKSPACE:-default}"
  export _USER_DEVBOX_DISABLE_LANG_OVERRIDE="${_USER_DEVBOX_DISABLE_LANG_OVERRIDE:-false}"

  if [ "$_USER_DEVBOX_DISABLE_LANG_OVERRIDE" != 'true' ]; then
    export LANG=C.UTF8
    export LC_COLLATE=$LANG
    export LC_CTYPE=$LANG
    export LANGUAGE=$LANG
  fi

  source "${_USER_CONFIG_DIR}/utils/functions"

  declare _user_devbox_tmp_workspace_dir

  # _user_devbox_tmp_workspace_dir is needed since not enough of the environment
  # exists yet and profile-init.d scripts may change how the environment is
  # configured.
  #
  # profile-init.d scripts may use this variable to access other workspace
  # specific paths.
  _user_devbox_tmp_workspace_dir="${_USER_DEVBOX_WORKSPACES_DIR:-${_USER_DEVBOX_CONFIG_DIR:-${_USER_CONFIG_DIR}/devbox}/workspaces/${_USER_DEVBOX_WORKSPACE}}"

  declare init_dir=${_user_devbox_tmp_workspace_dir}
  declare init=${1:-"${_user_devbox_tmp_workspace_dir}/workspace-init.sh"}; shift || :

  _source_script "$init" "$init_dir"

  export _USER_DEVBOX_CONFIG_DIR="${_USER_DEVBOX_CONFIG_DIR:-${XDG_CONFIG_HOME:-"${HOME}/.config"}/_user/devbox}"

  export _USER_DEVBOX_WORKSPACES_DIR="${_USER_DEVBOX_WORKSPACES_DIR:-${_USER_DEVBOX_CONFIG_DIR}/workspaces}"

  export _USER_DEVBOX_WORKSPACE_DIR="${_USER_DEVBOX_WORKSPACES_DIR}/${_USER_DEVBOX_WORKSPACE}"

  export _USER_SHELL_DIR="$_USER_DEVBOX_WORKSPACE_DIR"

  export _USER_PS1_INFIX=${_USER_PS1_INFIX:-"(devbox) "}

  declare _user_devbox_init
  declare -a _user_devbox_inits=(
    "${1:-}"
    "${_USER_CONFIG_DIR}/utils/init-profile.sh"
    )

  for _user_devbox_init in "${_user_devbox_inits[@]}"; do
    if [ -r "$_user_devbox_init" ] && [ -x "$_user_devbox_init" ]; then
      source "$_user_devbox_init"
      break
    fi
  done
}

_main "$@"
unset -f _main
_cleanup_fns
