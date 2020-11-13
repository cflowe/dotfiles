if [ -f "${HOME}/.config/${USER}/bash.profile.d/functions" ]; then
  # shellcheck disable=SC1090
  source "${HOME}/.config/${USER}/bash.profile.d/functions"
fi

for i in "${HOME}/.config/${USER}/bash.profile.d/"*.sh; do
  if [ -r "$i" ]; then
    # shellcheck disable=SC1090
    source "$i"
  fi
done

unset i

if [ -f "${HOME}/.config/${USER}/bash.profile.d/cleanup" ]; then
  # shellcheck disable=SC1090
  source "${HOME}/.config/${USER}/bash.profile.d/cleanup"
fi
