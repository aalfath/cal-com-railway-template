# Changelog

## 2026-11-16: Deploy on Railway button

- README: add the Deploy on Railway button for the published template `calcom-2`. No change to the app or its settings.

## 2026-11-16: Cal.com v6.2.0

- First release of the template: `calcom/cal.com:v6.2.0@sha256:ace3bb1219fb7306585ab9f4d94d41af7ee064c343db0498173436bbe857bd49` with Railway Postgres.
- `railway-start.sh` derives `DATABASE_DIRECT_URL`, `DATABASE_HOST`, `NEXTAUTH_URL` and the public URL, turns telemetry off and public sign-up off by default, then runs Cal.com's own start script.
