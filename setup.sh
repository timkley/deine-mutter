#!/bin/bash
set -euo pipefail

APP_NAME="deine-mutter"
APP_TITLE="Deine Mutter"
APP_DIR="/var/www/${APP_NAME}"
DOMAIN="deine-mutter.timkley.dev"
PHP="/usr/bin/php"
COMPOSER="$(command -v composer)"
PNPM_VERSION="11.5.0"
PNPM_PACKAGE="pnpm@${PNPM_VERSION}"
OCTANE_PORT="8004"
export CI=true

cd "$(dirname "$0")"

run_as_admin() {
    runuser -u admin -- bash -lc "cd '${APP_DIR}' && $*"
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

install_php_dependencies() {
    run_as_admin "'${COMPOSER}' install --no-dev --no-interaction --prefer-dist --optimize-autoloader"
}

install_frontend() {
    run_as_admin "corepack enable"
    run_as_admin "if [ -d node_modules ] && [ ! -f node_modules/.modules.yaml ]; then rm -rf node_modules; fi"
    run_as_admin "corepack '${PNPM_PACKAGE}' install --frozen-lockfile"
    run_as_admin "'${PHP}' artisan route:clear"
    run_as_admin "corepack '${PNPM_PACKAGE}' run build"
}

sudo cp -f deployment/traefik.toml "/home/admin/docker/traefik/dynamic/${APP_NAME}.toml"
sudo cp -f deployment/${APP_NAME}*.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable "${APP_NAME}"
sudo ufw allow from 172.16.0.0/12 to any port "${OCTANE_PORT}" proto tcp comment "${APP_NAME} octane"

install_php_dependencies

if [ ! -f .env ]; then
    runuser -u admin -- cp .env.example .env
    run_as_admin "'${PHP}' artisan key:generate --force"

    set_env APP_NAME "\"${APP_TITLE}\""
    set_env APP_ENV production
    set_env APP_DEBUG false
    set_env APP_TIMEZONE Europe/Berlin
    set_env APP_URL "https://${DOMAIN}"
    set_env APP_LOCALE de
    set_env APP_FAKER_LOCALE de_DE
    set_env LOG_CHANNEL stack
    set_env LOG_STACK sentry_logs,daily
    set_env SENTRY_ENABLE_LOGS true
    set_env SENTRY_LOG_LEVEL error
    set_env SENTRY_ENVIRONMENT production
    set_env DB_CONNECTION pgsql
    set_env DB_HOST 127.0.0.1
    set_env DB_PORT 5432
    set_env DB_DATABASE "${APP_NAME}"
    set_env DB_USERNAME postgres
    set_env CACHE_STORE redis
    set_env SESSION_DRIVER redis
    set_env REDIS_HOST 127.0.0.1
    set_env QUEUE_CONNECTION database
    set_env OCTANE_SERVER frankenphp
    chown admin:admin .env

    docker exec postgres createdb -U postgres "${APP_NAME}" 2>/dev/null || true
    install_frontend

    cat <<MESSAGE
Initial ${APP_TITLE} setup is prepared.
Before starting services, set DB_PASSWORD, SENTRY_LARAVEL_DSN, and any other app-specific secrets in ${APP_DIR}/.env.
Then run:

cd ${APP_DIR}
sudo runuser -u admin -- ${PHP} artisan migrate --force
sudo runuser -u admin -- ${PHP} artisan optimize
sudo systemctl start ${APP_NAME}
MESSAGE
    exit 0
fi

docker exec postgres createdb -U postgres "${APP_NAME}" 2>/dev/null || true
install_frontend
run_as_admin "'${PHP}' artisan migrate --force"
run_as_admin "'${PHP}' artisan optimize"
sudo systemctl restart "${APP_NAME}"

echo "Setup completed successfully."
