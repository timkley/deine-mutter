#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

PHP="/usr/bin/php"
COMPOSER="$(command -v composer)"
PNPM_VERSION="10.34.1"

git pull --ff-only origin main

${COMPOSER} install --no-dev --no-interaction --prefer-dist --optimize-autoloader

corepack enable
corepack prepare pnpm@${PNPM_VERSION} --activate
if [ -d node_modules ] && [ ! -f node_modules/.modules.yaml ]; then
    rm -rf node_modules
fi
pnpm install --frozen-lockfile
${PHP} artisan route:clear
pnpm run build

${PHP} artisan migrate --force
${PHP} artisan optimize
${PHP} artisan octane:reload

sudo -n cp -f deployment/deine-mutter*.service /etc/systemd/system/
sudo -n systemctl daemon-reload

echo "Deployed successfully."
