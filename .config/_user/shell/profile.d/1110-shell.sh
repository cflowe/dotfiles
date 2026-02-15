#!/usr/bin/env bash

_fn() {
  export EDITOR=vim
  export _USER_CONFIG_VIM_INFO="${XDG_STATE_HOME:-${HOME}/.local/state}/viminfo"

  install -dv -m 0750 "$_USER_CONFIG_VIM_INFO"

  export GIT_EDITOR=$EDITOR
  export GIT_PAGER='/usr/bin/less'

  #GIT_ASKPASS
  #GIT_CONFIG
  #GIT_CONFIG_NOSYSTEM
  #GIT_CONFIG_PARAMETERS
  #GIT_EDITOR
  #GIT_EXEC_PATH
  #GIT_PAGER
  #GIT_PAGER_IN_USE
  #GIT_PREFIX
  #GIT_PROXY_COMMAND
  #GIT_SSH
  #GIT_TEMPLATE_DIR
  #GIT_USER_AGENT
  #GIT_WORK_TREE

  GPG_TTY=$(tty)
  export GPG_TTY

  if [ -z "${LESSOPEN:-}" ] && [ -x "${HOME}/.lesspipe.sh" ]; then
    export LESSOPEN="|${HOME}/.lesspipe.sh %s"
  fi

  export LESS="-X $LESS"
  export PAGER='/usr/bin/less'

  if [ -z "${LESS:-}" ]; then
    #LESS='-inRM --shift 5'
    LESS='-inFRMX'
  else
    LESS="-in $LESS"
  fi
}

_fn
unset -f _fn
