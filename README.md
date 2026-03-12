# The Automatic Workshop

Notes on builders, AI, energy, and the shifting economics of creation.

A custom Ghost 5.x theme + Digital Ocean App Platform deployment.

---

## Theme

Built from scratch. Stack:
- **Fonts:** Playfair Display (headings) + Inter (body)
- **Features:** Ghost Portal subscriptions, Members API newsletter signup, native Ghost comments, tag-based categories, responsive mobile nav
- **No build tools** — plain CSS and vanilla JS

---

## Deployment

### Architecture

| Resource | Service | Est. cost |
|---|---|---|
| Ghost container | DO App Platform (basic-xxs) | $5/mo |
| Database | DO Managed MySQL 8 | $15/mo |
| Media storage | DO Spaces (nyc3) | $5/mo |
| CDN | DO Spaces CDN | ~$2/mo |
| **Total** | | **~$27/mo** |

---

### Prerequisites

- [Digital Ocean account](https://digitalocean.com)
- [`doctl` CLI](https://docs.digitalocean.com/reference/doctl/how-to/install/) installed and authenticated
- GitHub repo for this project
- SMTP provider — [Mailgun](https://mailgun.com) recommended (free tier = 100 emails/day)

---

### Step 1 — Push to GitHub

Create a repo named `automatic-workshop.com` on GitHub, then:

```bash
git remote add origin git@github.com:YOUR_USERNAME/automatic-workshop.com.git
git push -u origin main
```

Update the `github.repo` line in `.do/app.yaml`:

```yaml
github:
  repo: YOUR_USERNAME/automatic-workshop.com
```

---

### Step 2 — Create a DO Spaces bucket

In the DO console: **Spaces → Create a Space**

- **Name:** `automatic-workshop-media`
- **Region:** `nyc3`
- Enable CDN

Then generate a Spaces access key: **API → Spaces Keys → Generate New Key**. Save the key and secret — you'll need them in Step 5.

---

### Step 3 — Set up SMTP email

Mailgun is the easiest option:

1. Create an account at [mailgun.com](https://mailgun.com)
2. Add and verify your sending domain (`automaticworkshop.com`)
3. Get SMTP credentials from **Sending → Domain settings → SMTP credentials**

SMTP settings for common providers:

| Provider | Host | Port |
|---|---|---|
| Mailgun | `smtp.mailgun.org` | 587 |
| Postmark | `smtp.postmarkapp.com` | 587 |
| SendGrid | `smtp.sendgrid.net` | 587 |

---

### Step 4 — Deploy to DO App Platform

```bash
doctl auth init
doctl apps create --spec .do/app.yaml
```

Or via the DO console: **Apps → Create App → GitHub → select repo → Use existing spec**.

The first deploy will take a few minutes while Ghost runs database migrations.

---

### Step 5 — Set secret environment variables

After the app is created, go to **App → Settings → App-Level Environment Variables** and set these secrets:

| Key | Value |
|---|---|
| `storage__s3__accessKeyId` | Your Spaces access key |
| `storage__s3__secretAccessKey` | Your Spaces secret key |
| `mail__options__host` | SMTP host (e.g. `smtp.mailgun.org`) |
| `mail__options__auth__user` | SMTP username |
| `mail__options__auth__pass` | SMTP password |

Then trigger a redeploy.

---

### Step 6 — Configure DNS

Point `automaticworkshop.com` to Digital Ocean. The DO console will show the exact DNS records to add under **App → Settings → Domains**.

If using DO as your DNS provider (nameservers), the domain will be configured automatically. If using an external registrar, add the CNAME or A records shown in the console.

---

### Step 7 — Ghost setup

Visit `https://automaticworkshop.com/ghost` to create your admin account, then:

1. **Settings → Design → Theme** — activate "Automatic Workshop"
2. **Settings → Membership → Comments** — enable native comments
3. **Settings → Email newsletter** — set sender name and reply-to address
4. **Settings → Navigation** — add your tag pages:
   - AI → `/tag/ai/`
   - Energy → `/tag/energy/`
   - Builders → `/tag/builders/`
5. **Settings → Navigation → Secondary** — add footer links (About, Archive, etc.)

---

## Local development

To work on the theme locally, you need a Ghost instance running. The easiest approach:

```bash
# Install Ghost CLI
npm install -g ghost-cli

# Create a local Ghost install
mkdir ghost-local && cd ghost-local
ghost install local

# Symlink (or copy) this theme into Ghost's themes directory
ln -s /path/to/automatic-workshop.com content/themes/automatic-workshop

ghost restart
```

Then activate the theme in your local Ghost Admin at `http://localhost:2368/ghost`.

---

## Deploying theme updates

Theme changes are deployed automatically on push to `main` (configured in `.do/app.yaml`). The Docker image is rebuilt with the latest theme files baked in.

To disable auto-deploy, set `deploy_on_push: false` in `.do/app.yaml` and redeploy manually with:

```bash
doctl apps create-deployment YOUR_APP_ID
```
