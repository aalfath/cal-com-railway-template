#!/bin/sh
# Small Railway wrapper around Cal.com's own start script (/calcom/scripts/start.sh).
# It derives the settings Railway can work out on its own, then hands over to upstream:
# replace the built web app URL, wait for Postgres, run Prisma migrations, seed the app store, `next start`.
set -e

if [ -z "$DATABASE_URL" ]; then
  echo "DATABASE_URL is not set. Point it at your Postgres, for example \${{Postgres.DATABASE_URL}}." >&2
  exit 1
fi
export DATABASE_DIRECT_URL="${DATABASE_DIRECT_URL:-$DATABASE_URL}"

# host:port for upstream's wait-for-it step
if [ -z "$DATABASE_HOST" ]; then
  hostport=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-zA-Z]+://([^@/]*@)?([^/?]+).*#\2#')
  case "$hostport" in *:*) ;; *) hostport="$hostport:5432" ;; esac
  export DATABASE_HOST="$hostport"
fi

# Public URL: an explicit NEXT_PUBLIC_WEBAPP_URL wins, else the Railway domain.
if [ "$NEXT_PUBLIC_WEBAPP_URL" = "$BUILT_NEXT_PUBLIC_WEBAPP_URL" ] && [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  export NEXT_PUBLIC_WEBAPP_URL="https://$RAILWAY_PUBLIC_DOMAIN"
fi
NEXT_PUBLIC_WEBAPP_URL="${NEXT_PUBLIC_WEBAPP_URL%/}"
export NEXT_PUBLIC_WEBAPP_URL
export NEXTAUTH_URL="${NEXTAUTH_URL:-$NEXT_PUBLIC_WEBAPP_URL}"

if [ -z "$NEXTAUTH_SECRET" ] || [ -z "$CALENDSO_ENCRYPTION_KEY" ]; then
  echo "NEXTAUTH_SECRET and CALENDSO_ENCRYPTION_KEY must be set (the template generates both)." >&2
  exit 1
fi

# The image starts Next.js through turbo, which drops PORT from the environment, so Cal.com
# always listens on 3000. Railway's domain targets port 3000.
export PORT=3000
export TURBO_TELEMETRY_DISABLED=1
# Public sign-up is off by default: the first visitor creates the admin in the setup wizard,
# and the admin adds further users. Set NEXT_PUBLIC_DISABLE_SIGNUP=false to open sign-up.
export NEXT_PUBLIC_DISABLE_SIGNUP="${NEXT_PUBLIC_DISABLE_SIGNUP:-true}"
export CALCOM_TELEMETRY_DISABLED="${CALCOM_TELEMETRY_DISABLED:-1}"

cd /calcom
exec /calcom/scripts/start.sh
