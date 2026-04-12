#!/usr/bin/env bash
alias cp='\cp -i'
alias mv='\mv -i'
alias rm='\rm -i'

alias grep='\grep --color=auto'
alias egrep='\grep --color=auto -E'
alias pgrep='\grep --color=auto -P'

alias l='\ls -lF --color=auto'
alias la='\ls -alF --color=auto'
alias ll='\ls -AlF --color=auto'
alias lx='\ls -AxF --color=auto'

alias vi=vim

alias h=history
alias ha='history -a'
alias hl='history | ${LESS:-less}'
alias hn='history -n'
alias hsync='history -a; history -n'
alias hrefresh='history -a; history -n; history -c; history -r'

export HISTFILESIZE=32768
export HISTSIZE=16384

shopt -s direxpand
shopt -s histappend

set -o vi

umask 0007

# shellcheck disable=SC2154
PATH="${PATH}:${profile_base_dir}/_user/shell/bin"

# shellcheck disable=SC2154
alias isum='perl -e "map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {\$i += int} split(/\s/)} <STDIN>; print(\"\$i\n\");"'
alias asum='perl -e "\$i = 0; map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {\$i += \$_} split(/\s/)} <STDIN>; print(\"\$i\n\");"'

# shellcheck disable=SC2154
alias avg='perl -e "map {s/(^\s+|\s+\$)//g; s/(\s)+/\1/g; map {if (\$_ > 0) {\$i += \$_; \$c++}} split(/\s/)} <STDIN>; print((\$i / \$c) . \"\n\");"'
alias max='perl -e "\$i=0; map { map { \$i = \$_ if(\$_ > \$i) } split(/\s/)} <STDIN>; print \$i"'
alias min='perl -e "\$i=0xffffffff; map { map { \$i = \$_ if(\$_ < \$i) } split(/\s/)} <STDIN>; print \$i"'

alias gmtdiff='zdump US/Eastern GMT'
