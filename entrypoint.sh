#!/bin/bash
set -eu

if [[ ! -f ~/.ssh/id_ed25519 ]]; then
	ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
	# ssh-keyscan uptermd.upterm.dev >/etc/ssh/ssh_known_hosts
fi

UPTERM_ARGS=(--accept)

if [[ -n "${UPTERM_AUTHORIZED_KEYS:-}" ]]; then
	UPTERM_ARGS+=(--authorized-keys="${UPTERM_AUTHORIZED_KEYS}")
fi

if [[ -n "${UPTERM_GITHUB_USER:-}" ]]; then
	UPTERM_ARGS+=(--github-user="${UPTERM_GITHUB_USER}")
fi

upterm host "${UPTERM_ARGS[@]}" "$@"
