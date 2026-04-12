#!/usr/bin/env bash

#shellcheck disable=SC1090
_default_init_profile() {
  : "${_USER_DEVBOX_BASEDIR:?}"
  : "${_USER_DEVBOX_CONFIG_DIR:?}"
  : "${_USER_DEVBOX_DISABLE_LANG_OVERRIDE:?}"
  : "${_USER_DEVBOX_SCRIPT_DIR:?}"
  : "${_USER_DEVBOX_WORKSPACES_DIR:?}"
  : "${_USER_DEVBOX_WORKSPACE:?}"
  : "${_USER_DEVBOX_WORKSPACE_DIR:?}"

  if [ "$_USER_DEVBOX_DISABLE_LANG_OVERRIDE" != 'true' ]; then
    export LANG=C.UTF8
    export LC_COLLATE=$LANG
    export LC_CTYPE=$LANG
    export LANGUAGE=$LANG
  fi

  declare init_dir file

  init_dir="${_USER_DEVBOX_WORKSPACE_DIR}/profile.d"
  file="${init_dir}/init"
  if [ -r "$file" ] && [ -x "$file" ]; then
    source "$file"
  fi

  _source_dir "$init_dir"

  file="${init_dir}/fini"
  if [ -r "$file" ] && [ -x "$file" ]; then
    source "$file"
  fi
}

_default_init_profile
unset -f _default_init_profile
