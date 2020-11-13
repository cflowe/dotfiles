case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
    #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
    #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:$(basename $PWD)\007"'
    #PROMPT_COMMAND='echo -ne "\033]0;~${PWD#$HOME}\007"'
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}:$(basename "$PWD")\007"'
    ;;
  screen)
    #PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
    #PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:$(basename $PWD)\033\\"'
    #PROMPT_COMMAND='echo -ne "\033_~${PWD#$HOME}\033\\"'
    PROMPT_COMMAND='echo -ne "\033_${HOSTNAME%%.*}:$(basename "$PWD")\033\\"'
    ;;
esac


export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '
#export PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:$(basename $PWD)\033\\"'
