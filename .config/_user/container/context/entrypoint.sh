#!/usr/bin/env bash

if [ "${_USER_CONFIG_DEBUG:-}" == 'true' ]; then
  echo "\$- ='$-'"
  export PS4='+\D{%FT%H:%M:%S%z}: '
  set -x
fi

# Sometimes the "bash" implementation will not set '$-' to indicate an
# interactive terminal even when the container is started with
# --tty --interactive.
if tty 1>/dev/null 2>&1; then
  # Non-interactive.
  export BASH_ENV=/opt/container/libexec/_user/bash-shell-startup.sh

  if [ $# -eq 0 ]; then
    exec /usr/bin/env bash
  else
    declare cmd=$1; shift
    exec /usr/bin/env bash -c "$cmd"' "$@"' "$cmd" "$@"
  fi

  exit "$?"
fi

# Interactive.
if [ $# -eq 0 ]; then
  exec /usr/bin/env bash \
    --rcfile /opt/container/libexec/_user/bash-shell-startup.sh
else
  declare cmd=$1; shift
  exec /usr/bin/env bash \
    --rcfile /opt/container/libexec/_user/bash-shell-startup.sh \
    -c "$cmd"' "$@"' "$cmd" "$@"
fi
