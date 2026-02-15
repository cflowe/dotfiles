#!/usr/bin/env bash

_fn() {
  declare pyenv_root="${PYENV_ROOT:-"${XDG_CONFIG_HOME:-"${HOME}/.config/_user/pyenv"}"}"

  if [ -x "${pyenv_root}/bin/pyenv" ]; then
    export PYENV_ROOT="$pyenv_root"

    case "$PATH" in
    *${PYENV_ROOT}/bin*) ;;
    *) export PATH="${PYENV_ROOT}/bin:${PATH}";;
    esac

    if ! command -v pyenv &> /dev/null; then
      echo "pyenv is not in PATH '$PATH'" >&2
    else
      eval "$(pyenv init --path)"
      eval "$(pyenv init -)"

      if [ -d "${PYENV_ROOT}/plugins/pyenv-virtualenv/" ]; then
        eval "$(pyenv virtualenv-init -)"
      fi
    fi
  fi
}

_fn
unset -f _fn
