#!/usr/bin/env bash
set -euo pipefail

die() { echo "install-docker: $*" >&2; exit 1; }
usage() {
  cat <<'EOF'
Usage: install-docker.sh [--user <login-user>]

Installs Docker CE on Ubuntu and optionally adds the given user to the docker group.
EOF
}

TARGET_USER="${DOCKER_USER:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)
      TARGET_USER="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[[ "$(id -u)" -eq 0 ]] || die "run as root"

if [[ -z "${TARGET_USER}" ]]; then
  TARGET_USER="${SUDO_USER:-}"
fi

if [[ -z "${TARGET_USER}" ]]; then
  TARGET_USER="${LOGNAME:-}"
fi

if [[ -z "${TARGET_USER}" || "${TARGET_USER}" == "root" ]]; then
  TARGET_USER=""
fi

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
fi

[[ "${ID:-}" == "ubuntu" ]] || die "this script currently supports Ubuntu only"

echo "Updating package lists and installing prerequisites..."
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gnupg

echo "Creating /etc/apt/keyrings..."
install -m 0755 -d /etc/apt/keyrings

echo "Downloading Docker GPG key..."
curl -fsSL --retry 3 --connect-timeout 5 --max-time 60 \
  https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  ${VERSION_CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

echo "Updating package lists again..."
DEBIAN_FRONTEND=noninteractive apt-get update

echo "Installing Docker packages..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "Enabling and starting Docker..."
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now docker
else
  service docker start
fi

if [[ -n "${TARGET_USER}" ]]; then
  id -u "${TARGET_USER}" >/dev/null 2>&1 || die "user not found: ${TARGET_USER}"
  echo "Adding ${TARGET_USER} to the docker group..."
  usermod -aG docker "${TARGET_USER}"
else
  echo "Skipping docker group update because no non-root login user could be detected."
fi

cat <<EOF
Docker installation completed.

If you were added to the docker group, log out and log back in, or run:
  newgrp docker

Then verify with:
  docker ps
EOF
