#!/usr/bin/env bash
alias cp='\cp -i'
alias mv='\mv -i'
alias rm='\rm -i'

alias grep='\grep --color=auto'
alias egrep='\grep --color=auto -E'
alias pgrep='\grep --color=auto -P'

alias l='\ls -F --color=auto'
alias la='\ls -alF --color=auto'
alias ll='\ls -AlF --color=auto'
alias lx='\ls -AxF --color=auto'

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:'

alias vi=vim

alias j=jj

alias h=history
alias ha='history -a'
alias hl='history | less'
alias hn='history -n'
alias hsync='history -a; history -n'
alias hrefresh='history -a; history -n; history -c; history -r'

: "${EDITOR:=/usr/bin/vim}"
export EDITOR

export HISTFILESIZE=32768
export HISTSIZE=16384

shopt -s direxpand
shopt -s histappend

set -o vi

umask 0007

# shellcheck disable=SC2154
#PATH="${PATH}:/sbin:/usr/sbin:${shell_profile_base_dir}/_user/shell/bin:${shell_profile_base_dir}/_user/devbox/bin:${shell_profile_base_dir}/_user/container/bin"
PATH="${PATH}:/sbin:/usr/sbin:${shell_profile_base_dir}/bin:${profile_base_dir}/devbox/bin:${profile_base_dir}/container/bin"

# shellcheck disable=SC2154
alias isum='perl -e "map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {\$i += int} split(/\s/)} <STDIN>; print(\"\$i\n\");"'
alias asum='perl -e "\$i = 0; map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {\$i += \$_} split(/\s/)} <STDIN>; print(\"\$i\n\");"'

# shellcheck disable=SC2154
alias avg='perl -e "map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {if (\$_ > 0) {\$i += \$_; \$c++}} split(/\s/)} <STDIN>; print((\$i / \$c) . \"\n\");"'
alias max='perl -e "\$i=0; map { map { \$i = \$_ if(\$_ > \$i) } split(/\s/)} <STDIN>; print \$i"'
alias min='perl -e "\$i=0xffffffff; map { map { \$i = \$_ if(\$_ < \$i) } split(/\s/)} <STDIN>; print \$i"'

alias gmtdiff='zdump US/Eastern GMT'

function pushd() {
  # shellcheck disable=SC2164
  builtin pushd "$@" >/dev/null
}

function popd() {
  # shellcheck disable=SC2164
  builtin popd "$@" >/dev/null
}

GPG_TTY=$(tty)
export GPG_TTY

# Needed to deal with apparmour and the nix store.
alias less='PATH=/usr/bin:$PATH less'

if [ -z "${LESSOPEN:-}" ] && [ -x "${HOME}/.lesspipe.sh" ]; then
  export LESSOPEN="|${HOME}/.lesspipe.sh %s"
fi

export PAGER='/usr/bin/less'

export LESS='-inFRMX'

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
