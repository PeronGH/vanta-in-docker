FROM --platform=linux/amd64 debian:bookworm-slim

ARG VANTA_VERSION=2.20.0
ARG VANTA_SHA256=42e67e2b8757239619f2a2aa8093dc32b91b88aa45c2d1538636097fc4b63da6

ADD --checksum=sha256:${VANTA_SHA256} \
    https://agent-downloads.vanta.com/targets/versions/${VANTA_VERSION}/vanta-amd64.deb /tmp/vanta.deb

# Extract only: postinst needs systemd/sysvinit/upstart and fails in a container.
# Binaries live in /opt/vanta and are copied into the /var/vanta state volume on start,
# so upgrading the image upgrades the agent.
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && dpkg-deb -x /tmp/vanta.deb / \
 && rm /tmp/vanta.deb \
 && mv /var/vanta /opt/vanta \
 && mv /etc/vanta.conf /opt/vanta/vanta.conf.default \
 && mkdir /var/vanta \
 && ln -s /var/vanta/vanta.conf /etc/vanta.conf \
 && ln -s /var/vanta/vanta-cli /usr/local/bin/vanta-cli

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME /var/vanta
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
