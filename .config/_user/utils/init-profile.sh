#!/usr/bin/env bash

# shellcheck disable=SC1090
function _main {
  declare profile_base_dir="${_USER_PROFILE_BASE_DIR:-"${XDG_CONFIG_HOME:-${HOME}/.config}/_user/shell"}"

  if [ "${_USER_CONFIG_DEBUG:-}" == 'true' ]; then
    set -x
  fi

  _source_script "${profile_base_dir}/profile.d/functions"
  _source_scripts_dir "${profile_base_dir}/profile.d"
  _source_script "${profile_base_dir}/profile.d/cleanup"
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

    mapfile -t files < <(LC_COLLATE=C.UTF8 LC_CTYPE=C.UTF8 find -L "$source_dir" -maxdepth 1 -type f -name "$pattern" | sort -V)

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

  _source_script "${scripts_dir}/init"
  _source_dir "$scripts_dir"
  _source_script "${scripts_dir}/fini"
}

_source_script() {
  declare file=${1:?Internal error: No script given.}; shift

  if [ -x "$file" ] && [ -r "$file" ]; then
    source "$file" "$@"
  fi
}

_main
unset -f _main
unset -f _source_dir
unset -f _source_script
unset -f _source_scripts_dir
