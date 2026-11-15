#!/usr/bin/env bash
# Generate a private .env from the tracked .env.example template.
set -Eeuo pipefail
umask 077

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
ENV_FILE="${ROOT}/.env"
EXAMPLE="${ROOT}/.env.example"

[[ -f "${EXAMPLE}" ]] || { echo "Missing ${EXAMPLE}" >&2; exit 1; }
[[ ! -e "${ENV_FILE}" ]] || { echo "${ENV_FILE} already exists; refusing to overwrite." >&2; exit 1; }
command -v openssl >/dev/null || { echo "openssl is required" >&2; exit 1; }

tmp="$(mktemp "${ROOT}/.env.XXXXXXXX")"
cleanup() { rm -f -- "${tmp}"; }
trap cleanup EXIT
cp -- "${EXAMPLE}" "${tmp}"
chmod 0600 "${tmp}"

for key in ELASTIC_PASSWORD KIBANA_PASSWORD PFELK_ES_PASSWORD; do
  if ! grep -q "^${key}=$" "${tmp}"; then
    echo "Expected an empty ${key}= placeholder in .env.example" >&2
    exit 1
  fi
  # Hexadecimal secrets are safe to interpolate into a sed replacement.
  secret="$(openssl rand -hex 32)"
  sed -i "s/^${key}=\$/${key}=${secret}/" "${tmp}"
done

# An atomic hard-link fails if another process created .env in the meantime;
# both files reside on the same filesystem.  Never overwrite credentials.
ln -- "${tmp}" "${ENV_FILE}" || { echo "Cannot create ${ENV_FILE} (already exists?)" >&2; exit 1; }
chmod 0600 "${ENV_FILE}"
echo "Created ${ENV_FILE} with random secrets (mode 0600)."
echo "Review bind addresses, timezone, and memory before docker compose up -d."
