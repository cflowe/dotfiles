if [ -z "${LESSOPEN:-}" ] && [ -f "${HOME}/.lesspipe.sh" ]; then
  export LESSOPEN="|${HOME}/.lesspipe.sh %s"
fi

export LESS="-X $LESS"
