export PYENV_ROOT="${HOME}/local/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
