# syntax=docker/dockerfile:1.17

ARG base_image_repo=alpine
ARG base_image_tag=3.23.2

FROM ${base_image_repo}:${base_image_tag}

SHELL [ "/usr/bin/env", "sh", "-exc" ]
# hadolint shell=/usr/bin/sh

# hadolint ignore=DL3018
RUN <<EOF
apk add --no-cache \
  bash \
  && :

install -dv -m 0755 \
  /opt/container/bin \
  /opt/container/libexec/_user \
  && :
EOF

COPY --chmod=0555 entrypoint.sh /opt/container/bin/
COPY --chmod=0444 bash-shell-startup.sh /opt/container/libexec/_user/

ENTRYPOINT [ "/opt/container/bin/entrypoint.sh" ]
