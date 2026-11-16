[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/calcom-2?utm_medium=integration&utm_source=button&utm_campaign=cal-com)

# Cal.com on Railway

Railway template wrapper for [Cal.com](https://github.com/calcom/cal.com), the open-source scheduling platform (a self-hosted Calendly alternative).

## What it deploys

| Service | Source | Notes |
|---|---|---|
| Cal.com | this repo (`Dockerfile`) | `calcom/cal.com:v6.2.0`, pinned by digest. Public, port 3000, health check `/api/version` |
| Postgres | Railway Postgres | Data on a Railway volume |

The `Dockerfile` only adds `railway-start.sh`, which derives the settings Railway can work out on its own and then runs Cal.com's own start script (web app URL replacement, Prisma migrations, app-store seed, `next start`).

**Version note.** v6.2.0 (2026-03-01) is the latest official Cal.com release and Docker image. The upstream open-source repository has since been renamed to [Cal.diy](https://github.com/calcom/cal.diy) (MIT), which publishes no Docker images yet. When an official newer image appears, this repo's pin is bumped and the change is listed in `CHANGELOG.md`.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Postgres connection |
| `NEXT_PUBLIC_WEBAPP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL. Change it if you add a custom domain |
| `NEXTAUTH_SECRET` | generated | Session cookie secret |
| `CALENDSO_ENCRYPTION_KEY` | generated, 32 characters | Encrypts stored app credentials. Don't change it after first use |
| `PORT` | `3000` | Cal.com always listens on 3000 (the image starts Next.js through turbo, which drops `PORT`). Railway's health check and domain use this value, so leave it at 3000 |

Optional, set them on the Cal.com service when you need them:

- `NEXT_PUBLIC_DISABLE_SIGNUP` (default `true` in this wrapper): set `false` to let anyone sign up.
- Email: `EMAIL_FROM`, `EMAIL_SERVER_HOST`, `EMAIL_SERVER_PORT`, `EMAIL_SERVER_USER`, `EMAIL_SERVER_PASSWORD`. Without them Cal.com sends no booking emails.
- Google Calendar: `GOOGLE_API_CREDENTIALS`, plus the other app keys listed in Cal.com's `.env.appStore.example`.
- Web push: `NEXT_PUBLIC_VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`.

## First run

Open the public URL right after the deploy finishes. Cal.com shows its setup wizard: the first visitor creates the admin account. Cal.com marks an admin as inactive until two-factor authentication is on, so turn it on under Settings, Security to reach the admin pages.

## Updates

Railway notifies everyone who deployed the template when this repo's `main` branch changes. Read `CHANGELOG.md` before you apply an update. Back up Postgres first: Cal.com runs its database migrations on start.
