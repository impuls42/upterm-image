#!/bin/bash
set -eu

if [[ ! -f ~/.ssh/id_ed25519 ]]; then
	ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
	# ssh-keyscan uptermd.upterm.dev >/etc/ssh/ssh_known_hosts
fi

upterm host \
	--accept \
	--authorized-keys="${UPTERM_AUTHORIZED_KEYS}" \
	--github-user="${UPTERM_GITHUB_USER}" \
	$@
