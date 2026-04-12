#!/usr/bin/env bash

# shellcheck disable=SC1090
_main() {
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

  declare _user_devbox_tmp_workspace_dir

  # _user_devbox_tmp_workspace_dir is needed since not enough of the environment
  # exists yet and profile-init.d scripts may change how the environment is
  # configured.
  #
  # profile-init.d scripts may use this variable to access other workspace
  # specific paths.
  _user_devbox_tmp_workspace_dir="${_USER_DEVBOX_WORKSPACES_DIR:-${_USER_DEVBOX_CONFIG_DIR:-${XDG_CONFIG_HOME:-"${HOME}/.config"}/_user/devbox}/workspaces/${_USER_DEVBOX_WORKSPACE}}"

  declare init_dir=${_user_devbox_tmp_workspace_dir}
  declare init=${1:-"${_user_devbox_tmp_workspace_dir}/workspace-init.sh"}; shift || :

  _source_script "$init" "$init_dir"

  : "${_USER_DEVBOX_CONFIG_DIR:=${XDG_CONFIG_HOME:-"${HOME}/.config"}/_user/devbox}"
  : "${_USER_DEVBOX_WORKSPACES_DIR:=${_USER_DEVBOX_CONFIG_DIR}/workspaces}"
  : "${_USER_DEVBOX_DISABLE_LANG_OVERRIDE:="false"}"

  export _USER_DEVBOX_CONFIG_DIR
  export _USER_DEVBOX_DISABLE_LANG_OVERRIDE
  export _USER_DEVBOX_SCRIPT_DIR
  export _USER_DEVBOX_WORKSPACES_DIR
  export _USER_DEVBOX_WORKSPACE_DIR="${_USER_DEVBOX_WORKSPACES_DIR}/${_USER_DEVBOX_WORKSPACE}"

  declare _user_devbox_init
  declare -a _user_devbox_inits=(
    "${1:-}"
    "${_USER_DEVBOX_SCRIPT_DIR}/default-init-profile.sh"
    )

  for _user_devbox_init in "${_user_devbox_inits[@]}"; do
    if [ -r "$_user_devbox_init" ] && [ -x "$_user_devbox_init" ]; then
      source "$_user_devbox_init"
      break
    fi
  done
}

# usage: _source_dir <directory> [[pattern] [operation]]
#
# [pattern] is a glob and the default [pattern] is '*.sh'.
#
# When `operation` is not given, the default operation is 'source' and files
# matching [pattern] must be readable and executable.
#
_source_dir() {
  declare source_dir=${1:?Internal error: No directory given.}; shift
  declare pattern=${1:-'*.sh'}; shift || :
  declare operation=${1:-}; shift || :

  if [ -d "$source_dir" ]; then
    declare file
    declare -a files=()

    mapfile -t files < <(find -L "$source_dir" -maxdepth 1 -type f -name "$pattern" | sort -V)

    if [ -n "$operation" ]; then
      for file in "${files[@]}"; do
        $operation "$file" "$@"
      done
    else
    for file in "${files[@]}"; do
      _source_script "$file"
      done
    fi
  fi
}

_source_scripts_dir() {
  declare scripts_dir=${1:?Internal error: No scripts directory given.}; shift

  _source_script "${scripts_dir}"/init
  _source_dir "$scripts_dir"
  _source_script "${scripts_dir}"/fini
}

_source_script() {
  declare file=${1:?Internal error: No script given.}; shift

  if [ -x "$file" ] && [ -r "$file" ]; then
    source "$file" "$@"
  fi
}

_main "$@"
unset -f _main
unset -f _source_dir
unset -f _source_script
unset -f _source_scripts_dir
