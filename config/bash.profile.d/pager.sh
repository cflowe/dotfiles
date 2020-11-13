export PAGER='/usr/bin/less'

if [ -z "${LESS:-}" ]; then
  LESS='-in -R -M --shift 5'
else
  LESS="-in $LESS"
fi
