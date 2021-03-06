FROM quay.io/openshiftlabs/workshop-dashboard:2.10.3

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src


USER 1001

RUN /usr/libexec/s2i/assemble
