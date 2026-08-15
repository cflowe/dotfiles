#!/usr/bin/env bash

set -eu -o pipefail

main() {
  declare project_dir=${1:?No project dir given.}; shift

  echodo install -dv -m 0750 "$project_dir"/{src/project,workstate/bin}

  if [ -e "${project_dir}/.envrc" ]; then
    echo "${project_dir}/.envrc already exists."  >&2
  else
    install -v -m 0440 /dev/stdin "${project_dir}/.envrc" <<\EOF
#!/usr/bin/env bash

export _U_D=$PWD
export _U_W="${_CF_D}/workstate"
export _U_W_S="${_CF_W}/status.md"

PATH_add "${_U_W}/bin"
EOF
  fi

  if [ -e "${project_dir}/workstate/status.md" ]; then
    echo "${project_dir}/workstate/status.md already exists."  >&2
  else
    install -v -m 0440 /dev/stdin "${project_dir}/workstate/status.md" <<EOF
## **inprogress**
### $(date -Idate)

## **todo**
### $(date -Idate)

## **done**
### $(date +%Y)-XX-XX

## **withdrawn**
### $(date +%Y)-XX-XX
EOF
  fi

  echodo git -C "${project_dir}/src/project" init
}

echodo() {
  echo "$@" >&2

  "$@"
}

main "$@"
