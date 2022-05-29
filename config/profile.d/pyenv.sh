if [ -x "${PYENV_ROOT:-${HOME}/local/pyenv}/bin/pyenv" ]; then
  export PYENV_ROOT="${PYENV_ROOT:-${HOME}/local/pyenv}"

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
