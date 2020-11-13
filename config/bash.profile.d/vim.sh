if [ -x /usr/bin/vim ]; then
  alias vi='/usr/bin/vim'
fi

: ${EDITOR=/usr/bin/vim}

export EDITOR
