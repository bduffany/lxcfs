FROM debian:12

# Podman
RUN apt update && apt install -y podman ca-certificates

# lxcfs
# RUN apt-get update && apt install -y lxcfs

# lxcfs deps
# RUN apt update && apt install -y libfuse-dev libfuse3-dev


# Docker
# RUN DOCKER_VERSION="5:27.4.1-1~debian.12~bookworm" && \
#     CONTAINERD_DEB_VERSION="1.7.24-1" && \
#     DOCKER_BUILDX_VERSION="0.19.3-1~debian.12~bookworm" && \
#     DOCKER_COMPOSE_VERSION="2.32.1-1~debian.12~bookworm" && \
#     apt-get update && \
#     apt-get install -y \
#     curl ca-certificates apt-transport-https && \
#     install -m 0755 -d /etc/apt/keyrings && \
#     curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
#     chmod a+r /etc/apt/keyrings/docker.asc && \
#     echo \
#       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
#       $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#     tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#     apt-get update && apt-get install -y \
#     docker-ce=${DOCKER_VERSION} \
#     docker-ce-cli=${DOCKER_VERSION} \
#     containerd.io=${CONTAINERD_DEB_VERSION} \
#     docker-buildx-plugin=${DOCKER_BUILDX_VERSION} \
#     docker-compose-plugin=${DOCKER_COMPOSE_VERSION} && \
#     apt-mark auto \
#     curl ca-certificates apt-transport-https && \
#     apt-get autoremove -y && \
#     rm -rf /var/lib/apt/lists/* && apt-get clean