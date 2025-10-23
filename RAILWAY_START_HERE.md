# Railway Deployment - Start Here! 🚀

## You've Chosen Railway!

Great choice! Railway is the **fastest and easiest** way to deploy your C2 server. You'll have a live server in **10-15 minutes**.

---

## Quick Summary

| Item | Details |
|------|---------|
| **Estimated Time** | 10-15 minutes |
| **Cost** | Free for 2-3 months |
| **Setup Difficulty** | Very Easy |
| **What You Get** | Live C2 server with domain |

---

## What's Ready for You

✅ All Docker files prepared
✅ Database schema ready
✅ Environment files configured
✅ Code updated for deployment
✅ Android client configuration file created

---

## The 8-Step Process

### Step 1: Create Railway Account (2 min)
→ Go to **[railway.app](https://railway.app)** and sign up with GitHub

### Step 2: Create Project (3 min)
→ Click **New Project** → **Deploy from GitHub** → select **moukthar**

### Step 3: Add MySQL Database (1 min)
→ Click **+ Add** → **Database** → **MySQL**

### Step 4: Initialize Database (1 min)
→ Open MySQL console → Copy `Server/database.sql` → Execute

### Step 5: Configure Environment (2 min)
→ Add environment variables in Railway dashboard

### Step 6: Deploy (Automatic!)
→ Railway builds and deploys automatically

### Step 7: Test Server (1 min)
→ Open your Railway domain in browser → Login

### Step 8: Update Android Client (2 min)
→ Edit `Utils.java` with your Railway domain → Rebuild APK

---

## Detailed Instructions

👉 **Full Step-by-Step Guide:** [Server/RAILWAY_QUICK_START.md](Server/RAILWAY_QUICK_START.md)

👉 **Complete Reference:** [Server/RAILWAY_SETUP.md](Server/RAILWAY_SETUP.md)

---

## Your Checklist

```
□ Step 1: Create Railway account
□ Step 2: Create project
□ Step 3: Add MySQL
□ Step 4: Initialize database
□ Step 5: Configure environment variables
□ Step 6: Deploy (automatic)
□ Step 7: Test in browser
□ Step 8: Update Android client
```

---

## Important Information

### Default Credentials
```
Username: android
Password: android
```

### Your Railway Domain
After deployment, Railway assigns you a domain like:
- `moukthar-production.railway.app`

Use this for:
- **Web UI:** `http://moukthar-production.railway.app`
- **WebSocket:** `ws://moukthar-production.railway.app:8080`
- **Android Client:** Update `Utils.java` with this domain

### Services Running
| Service | Port | Purpose |
|---------|------|---------|
| Apache | 80 | C2 Web UI |
| WebSocket | 8080 | Real-time comms |
| MySQL | 3306 | Database |

---

## Getting Started Now

### Option 1: Follow Quick Guide
1. Open [Server/RAILWAY_QUICK_START.md](Server/RAILWAY_QUICK_START.md)
2. Follow each step
3. Done in 10-15 minutes!

### Option 2: Follow Detailed Guide
1. Open [Server/RAILWAY_SETUP.md](Server/RAILWAY_SETUP.md)
2. More detailed explanations
3. Troubleshooting section included

---

## When You're Done

After deployment:
1. ✅ Server is live at your Railway domain
2. ✅ Database initialized and ready
3. ✅ WebSocket running
4. 🔄 Update Android client with Railway domain
5. 🔄 Rebuild APK with new server address
6. 🔄 Test from mobile device

---

## Cost Tracking

**Free Tier:** $5 credit/month
**Typical Usage:** 2-3 months free
**After Credit Runs Out:**
- Option 1: Add credit card ($5-10/month)
- Option 2: Migrate to Oracle Cloud (free forever)
- Option 3: Migrate to Home Server (free)

See your usage in **Billing** section of Railway dashboard.

---

## Troubleshooting Quick Tips

**Can't access website?**
- Check if service shows **Active** status
- Verify your domain is correct (Settings → Domains)
- Wait 1-2 minutes and refresh browser

**Database not working?**
- Execute `database.sql` in MySQL console
- Check MySQL service shows **Active**

**WebSocket not connecting?**
- Verify `WEBSOCKET_URI` env variable is set
- Check logs for errors
- Ensure it includes your Railway domain

**Build failed?**
- Click failed build in Deployments
- Read error message
- Fix code and push to GitHub

---

## Help & Documentation

**Quick Start (Recommended)**
→ [Server/RAILWAY_QUICK_START.md](Server/RAILWAY_QUICK_START.md)

**Full Guide with Details**
→ [Server/RAILWAY_SETUP.md](Server/RAILWAY_SETUP.md)

**Compare All Options**
→ [Server/FREE_HOSTING_OPTIONS.md](Server/FREE_HOSTING_OPTIONS.md)

**Master Deployment Guide**
→ [Server/DEPLOYMENT_GUIDE.md](Server/DEPLOYMENT_GUIDE.md)

**Documentation Index**
→ [Server/INDEX.md](Server/INDEX.md)

---

## Next Steps

1. **→ Open [Server/RAILWAY_QUICK_START.md](Server/RAILWAY_QUICK_START.md)**
2. Follow the steps
3. Get your server live in 10-15 minutes!

---

## What I've Prepared For You

✅ **Docker Setup**
- Dockerfile for Apache web server
- Dockerfile for WebSocket server
- docker-compose.yml for orchestration
- Apache configuration files

✅ **Code Updates**
- Backend modified for environment variables
- Android client configuration ready
- Environment files set up for Docker

✅ **Database**
- Schema prepared in database.sql
- Auto-initialization configured
- Ready to deploy

✅ **Documentation**
- Quick start guide (10 min)
- Detailed guide (30 min)
- Complete reference (comprehensive)
- Troubleshooting section

---

## Ready?

👉 **Start Here:** [Server/RAILWAY_QUICK_START.md](Server/RAILWAY_QUICK_START.md)

**Time to Live Server:** 10-15 minutes ⏱️

**Let's go! 🚀**
