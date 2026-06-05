#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

PHP="/usr/bin/php"
COMPOSER="$(command -v composer)"
PNPM_VERSION="11.5.0"
PNPM_PACKAGE="pnpm@${PNPM_VERSION}"

run_pnpm() {
    corepack "${PNPM_PACKAGE}" "$@"
}

set_env() {
    local key="$1"
    local value="$2"
    local escaped
    escaped="$(printf '%s' "$value" | sed -e 's/[&|]/\\&/g')"

    if grep -Eq "^[# ]*${key}=" .env; then
        sed -i -E "s|^[# ]*${key}=.*|${key}=${escaped}|" .env
    else
        printf '%s=%s\n' "$key" "$value" >> .env
    fi
}

git pull --ff-only origin main

${COMPOSER} install --no-dev --no-interaction --prefer-dist --optimize-autoloader

set_env LOG_CHANNEL stack
set_env LOG_STACK sentry_logs,daily
set_env SENTRY_ENABLE_LOGS true
set_env SENTRY_LOG_LEVEL error
set_env SENTRY_ENVIRONMENT production

corepack enable
if [ -d node_modules ] && [ ! -f node_modules/.modules.yaml ]; then
    rm -rf node_modules
fi
run_pnpm install --frozen-lockfile
${PHP} artisan route:clear
run_pnpm run build

${PHP} artisan migrate --force
${PHP} artisan optimize
${PHP} artisan octane:reload

sudo -n cp -f deployment/deine-mutter*.service /etc/systemd/system/
sudo -n systemctl daemon-reload

echo "Deployed successfully."
