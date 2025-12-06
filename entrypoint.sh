#!/bin/bash
set -eux

if [[ ! -f ~/.ssh/id_ed25519 ]]; then
	ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
fi

UPTERM_ARGS=(--accept)

if [[ -n "${UPTERM_AUTHORIZED_KEYS:-}" ]]; then
	UPTERM_ARGS+=(--authorized-keys="${UPTERM_AUTHORIZED_KEYS}")
fi

if [[ -n "${UPTERM_GITHUB_USER:-}" ]]; then
	UPTERM_ARGS+=(--github-user="${UPTERM_GITHUB_USER}")
fi

trap 'exit 0' SIGTERM SIGINT

while true; do
	script -qfc "upterm host $(printf '%q ' "${UPTERM_ARGS[@]}")$(printf '%q ' "$@")" /dev/null || true
	sleep 2
done
