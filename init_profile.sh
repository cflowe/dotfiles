if [ -f "${HOME}/.config/profile.d/functions" ]; then
  # shellcheck disable=SC1090
  source "${HOME}/.config/profile.d/functions"
fi

for i in "${HOME}/.config/profile.d/"*.sh; do
  if [ -r "$i" ]; then
    # shellcheck disable=SC1090
    source "$i"
  fi
done

unset i

if [ -f "${HOME}/.config/profile.d/cleanup" ]; then
  # shellcheck disable=SC1090
  source "${HOME}/.config/profile.d/cleanup"
fi
