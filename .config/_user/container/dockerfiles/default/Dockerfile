# syntax=docker/dockerfile:1.17

ARG base_image_repo
ARG base_image_tag

FROM ${base_image_repo}:${base_image_tag}

SHELL [ "/usr/bin/env", "bash", "-exc" ]
# hadolint shell=/usr/bin/bash

RUN <<EOR
install -dv -m 0755 \
  /opt/container/bin \
  /opt/container/libexec/_user \
  && :
EOR

COPY --chmod=0555 entrypoint.sh /opt/container/bin/
COPY --chmod=0444 bash-shell-startup.sh /opt/container/libexec/_user/

ENTRYPOINT [ "/opt/container/bin/entrypoint.sh" ]
