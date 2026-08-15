#!/usr/bin/env bash

if [ -z "${TF_PLUGIN_CACHE_DIR:-}" ] && [ -z "${TF_CLI_CONFIG_FILE:-}" ]; then
  export TF_PLUGIN_CACHE_DIR="${HOME}/.config/_user/shell/terraform.d/plugin-cache"
  export TF_CLI_CONFIG_FILE="${HOME}/.config/_user/shell/terraform.tfrc"
fi

: "${TERRAFORM_BINARY:=terraform}"
export TERRAFORM_BINARY

alias tf='$TERRAFORM_BINARY'
alias tfa='$TERRAFORM_BINARY apply'
alias tfi='$TERRAFORM_BINARY init'
alias tfp='$TERRAFORM_BINARY plan'
