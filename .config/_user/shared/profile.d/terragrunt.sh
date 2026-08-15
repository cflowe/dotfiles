#!/usr/bin/env bash

: "${TERRAGRUNT_BINARY:=terragrunt}"
export TERRAGRUNT_BINARY

alias tg='$TERRAGRUNT_BINARY'
alias tga='${TERRAGRUNT_BINARY} apply'
alias tgp='${TERRAGRUNT_BINARY} plan'
alias tgpu='${TERRAGRUNT_BINARY} plan --terragrunt-source-update'
alias tgs='${TERRAGRUNT_BINARY} show'
