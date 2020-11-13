#!/usr/bin/env bash

set -eu -o pipefail

xxd -r -p < <(git rev-parse --verify --short=8 HEAD) | od --endian=big -vAn -N4 -tu4
