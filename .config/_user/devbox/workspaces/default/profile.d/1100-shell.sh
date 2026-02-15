#!/usr/bin/env bash
alias h=history
alias ha='history -a'
alias hl='history | ${LESS:-less}'
alias hn='history -n'
alias hsync='history -a; history -n'
alias hrefresh='history -a; history -n; history -c; history -r'
alias rm='/bin/rm -i'
alias cp='/bin/cp -i'
alias mv='/bin/mv -i'

export HISTFILESIZE=32768
export HISTSIZE=16384

PATH="${PATH}:${_USER_DEVBOX_WORKSPACE_DIR}/local/bin"
