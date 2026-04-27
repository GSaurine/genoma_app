#!/bin/sh
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
MAX_RETRIES="${DB_RETRIES:-30}"
SLEEP_INTERVAL="${DB_SLEEP:-2}"

echo "Waiting for database at ${DB_HOST}:${DB_PORT}..."
retries=0
while true; do
  # First try a Node.js check using mysql2 (respects ssl:false and app config)
  if command -v node >/dev/null 2>&1; then
    if node -e "const mysql=require('mysql2/promise');(async()=>{try{const conf={host:process.env.DB_HOST||'mysql',port:process.env.DB_PORT?parseInt(process.env.DB_PORT):3306,user:process.env.DB_USER||'root',password:process.env.DB_PASSWORD||'',database:process.env.DB_NAME||'',ssl:false};const c=await mysql.createConnection(conf);await c.query('SELECT 1');await c.end();console.log('NODE_MYSQL_OK');process.exit(0);}catch(e){console.error(e.message);process.exit(1);}})();" >/dev/null 2>&1; then
      break
    fi
  fi

  # Try non-interactive connection with mysql client using MYSQL_PWD to avoid prompts
  if command -v mysql >/dev/null 2>&1; then
    if MYSQL_PWD="${DB_PASSWORD:-}" mysql --ssl-mode=DISABLED -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER:-root}" -e "SELECT 1" "${DB_NAME:-}" >/dev/null 2>&1; then
      break
    fi
  fi

  # Try mariadb client if available
  if command -v mariadb >/dev/null 2>&1; then
    if MYSQL_PWD="${DB_PASSWORD:-}" mariadb --ssl-mode=DISABLED -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER:-root}" -e "SELECT 1" "${DB_NAME:-}" >/dev/null 2>&1; then
      break
    fi
  fi

  # Fallback to mysqladmin ping
  if command -v mysqladmin >/dev/null 2>&1; then
    if mysqladmin --ssl-mode=DISABLED ping -h "${DB_HOST}" --silent >/dev/null 2>&1; then
      break
    fi
  fi

  retries=$((retries + 1))
  if [ "${retries}" -ge "${MAX_RETRIES}" ]; then
    echo "Database did not become available after ${MAX_RETRIES} attempts."
    exit 1
  fi
  echo "Waiting for DB... (${retries}/${MAX_RETRIES})"
  sleep "${SLEEP_INTERVAL}"
done

echo "Database is available. Running migrations..."
npm run migrate

echo "Starting server..."
npm start
