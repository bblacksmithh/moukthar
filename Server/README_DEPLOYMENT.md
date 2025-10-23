# 🚀 Moukthar C2 Server - Complete Setup & Deployment

## TL;DR - Get Started in 30 Seconds

### Just Want to Test Locally?
```bash
cd Server
docker-compose up -d --build
# Access: http://localhost
# Username: android | Password: android
# Stop: docker-compose down
```

### Want to Deploy for Free?
1. **Best Forever Free:** [Oracle Cloud](ORACLE_CLOUD_SETUP.md) (30 min setup)
2. **Easiest:** [Railway](RAILWAY_SETUP.md) (10 min setup, free 2-3 months)
3. **Lowest Cost:** [Home Server](HOME_SERVER_SETUP.md) (20 min setup, costs electricity only)

👉 **[Full Deployment Guide](DEPLOYMENT_GUIDE.md)** - Complete instructions for all options

---

## What's Been Set Up

✅ **Complete Docker Environment**
- Dockerfile for PHP/Apache web server
- Dockerfile for WebSocket server
- docker-compose.yml orchestrating 3 services
- MySQL database with schema
- Apache configuration with mod_rewrite
- All dependencies installed (Composer, extensions)

✅ **Environment Configuration**
- Dynamic WebSocket URI (environment-based)
- Database credentials for Docker network
- PHP upload limits configured (128MB)
- Proper file permissions set

✅ **Code Ready for Deployment**
- Backend updated to use environment variables
- Android client with configurable server addresses
- All services containerized and orchestrated
- Health checks configured

✅ **Comprehensive Documentation**
- Docker quick start guide
- Full Docker setup guide
- Free hosting options comparison
- Step-by-step setup guides for:
  - Oracle Cloud (free forever)
  - Railway (easiest)
  - Home Server (lowest cost)

---

## Quick Reference

### Services

| Service | Port | Purpose |
|---------|------|---------|
| PHP/Apache | 80 | Web UI (C2 control panel) |
| WebSocket | 8080 | Real-time communication |
| MySQL | 3306 | Database |

### Files & Locations

| File | Purpose |
|------|---------|
| `Dockerfile` | PHP/Apache image |
| `Dockerfile.websocket` | WebSocket image |
| `docker-compose.yml` | Service orchestration |
| `c2-server/.env` | Backend config |
| `web-socket/.env` | WebSocket config |
| `database.sql` | Database schema |

### Guides

| Guide | Best For | Time |
|-------|----------|------|
| [QUICK_START.md](QUICK_START.md) | Local testing | 2 min |
| [DOCKER_SETUP.md](DOCKER_SETUP.md) | Detailed Docker info | 20 min |
| [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md) | Choosing platform | 10 min |
| [ORACLE_CLOUD_SETUP.md](ORACLE_CLOUD_SETUP.md) | Free forever hosting | 30 min |
| [RAILWAY_SETUP.md](RAILWAY_SETUP.md) | Easiest deployment | 10 min |
| [HOME_SERVER_SETUP.md](HOME_SERVER_SETUP.md) | Run from home | 20 min |
| [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) | Complete overview | 30 min |

---

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│          Docker Network (moukthar-network)      │
├─────────────────────────────────────────────────┤
│                                                  │
│   MySQL          PHP/Apache       WebSocket    │
│   Database       C2 Control       Real-time    │
│   :3306          Panel            Comms        │
│                  :80              :8080        │
│                  (Web UI)         (WS)         │
│   ↓              ↓                ↓            │
│   Storage        Views/Routes     Connections │
│   Tables         Assets           Messages    │
│   Records        Logic            Updates     │
│                                                  │
└─────────────────────────────────────────────────┘
        ↑            ↑                ↑
        │            │                │
    External connections from clients, browsers, and WebSocket clients
```

---

## Deployment Options Comparison

### 🎯 Oracle Cloud (RECOMMENDED)
**Cost:** $0/month forever
**Setup:** 30 minutes
**Best for:** Production, long-term

```bash
1. Create account at oracle.com/cloud/free
2. Create Ubuntu instance (ARM)
3. Install Docker
4. Deploy docker-compose
5. Done! Free forever.
```
👉 [Full Guide](ORACLE_CLOUD_SETUP.md)

---

### 🚀 Railway (EASIEST)
**Cost:** Free for 2-3 months, then $5-10/month
**Setup:** 10 minutes
**Best for:** Quick deployment, testing

```bash
1. Go to railway.app
2. Connect GitHub repo
3. Add MySQL plugin
4. Deploy (automatic)
5. Done! Live in minutes.
```
👉 [Full Guide](RAILWAY_SETUP.md)

---

### 💻 Home Server (CHEAPEST)
**Cost:** $0.17-$5/month (electricity only)
**Setup:** 20 minutes
**Best for:** Development, always-on hardware available

```bash
1. Get DuckDNS domain
2. Configure port forwarding
3. Run docker-compose
4. Done! Running from home.
```
👉 [Full Guide](HOME_SERVER_SETUP.md)

---

### 🖥️ Local (FASTEST)
**Cost:** $0
**Setup:** 2 minutes
**Best for:** Testing, development

```bash
docker-compose up -d --build
# Access: http://localhost
# Stop: docker-compose down
```
👉 [Quick Start](QUICK_START.md)

---

## Getting Started - Choose Your Path

### Path 1: Just Want to Test?
```bash
cd Server
docker-compose up -d --build
# Open: http://localhost
# Login: android / android
```

### Path 2: Deploy for Free (Forever)?
1. Read [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md)
2. Choose Oracle Cloud or Railway
3. Follow appropriate setup guide
4. Update Android client
5. Done!

### Path 3: Deploy from Home?
1. Read [HOME_SERVER_SETUP.md](HOME_SERVER_SETUP.md)
2. Get DuckDNS domain
3. Configure port forwarding
4. Run docker-compose
5. Update Android client
6. Done!

### Path 4: Full Understanding?
Read [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for complete overview and decision tree.

---

## Key Features

✅ **One-Command Setup** - `docker-compose up -d --build`
✅ **Database Auto-Init** - Schema loads automatically
✅ **Service Health Checks** - Services wait for dependencies
✅ **Network Isolation** - Secure internal communication
✅ **Port Mapping** - All services exposed for access
✅ **Volume Persistence** - Data survives restarts
✅ **Live Code Updates** - Source volumes for development
✅ **Environment-Based Config** - Easy to customize
✅ **Production Ready** - Can deploy to any Linux/Docker host
✅ **Scalable** - Can run multiple instances

---

## Default Credentials

```
C2 Server Web UI:
  Username: android
  Password: android

MySQL Database:
  User: android
  Password: android
  Database: cc
```

⚠️ **Change these for any real deployment!**

---

## Common Commands

```bash
# Start services
docker-compose up -d --build

# Check status
docker-compose ps

# View logs
docker-compose logs -f              # All
docker-compose logs -f php-apache   # Web server
docker-compose logs -f mysql         # Database
docker-compose logs -f websocket     # WebSocket

# Stop services
docker-compose down

# Restart specific service
docker-compose restart php-apache

# Access MySQL
docker-compose exec mysql mysql -u android -p cc

# Update code
git pull
docker-compose down
docker-compose up -d --build
```

---

## Troubleshooting Quick Links

| Issue | Solution |
|-------|----------|
| Can't access web UI | Check `docker-compose ps` and logs |
| Database connection error | Wait 1-2 min for MySQL to start |
| WebSocket won't connect | Verify port 8080 is open |
| Port already in use | Edit `docker-compose.yml` port mappings |
| Want to change credentials | Edit `.env` files before first start |
| Need to backup database | `docker-compose exec mysql mysqldump -u android -p cc > backup.sql` |

---

## Security Notes

### For Development/Testing:
Current setup is fine for local and protected network use.

### For Production:
- [ ] Change default credentials
- [ ] Enable HTTPS/WSS (use reverse proxy)
- [ ] Configure firewall rules
- [ ] Set up database backups
- [ ] Enable monitoring and alerting
- [ ] Review access logs
- [ ] Keep Docker images updated
- [ ] Use secrets management for sensitive data

---

## Next Steps

1. **Choose your deployment option** (local/Oracle/Railway/home)
2. **Follow the appropriate guide** (links above)
3. **Test locally first** if deploying remotely
4. **Update Android client** with server address
5. **Monitor logs** after deployment
6. **Set up backups** if production

---

## Documentation Structure

```
Server/
├── README_DEPLOYMENT.md          ← You are here
├── QUICK_START.md                ← 2-minute local setup
├── DOCKER_SETUP.md               ← Full Docker guide
├── FREE_HOSTING_OPTIONS.md       ← Compare all options
├── DEPLOYMENT_GUIDE.md           ← Master guide with decision tree
│
├── Oracle Cloud Setup:
│   └── ORACLE_CLOUD_SETUP.md     ← Free forever (recommended)
├── Railway Setup:
│   └── RAILWAY_SETUP.md          ← Easiest (free 2-3 months)
├── Home Server Setup:
│   └── HOME_SERVER_SETUP.md      ← Cheapest (electricity costs)
│
├── Docker Files:
│   ├── Dockerfile
│   ├── Dockerfile.websocket
│   ├── docker-compose.yml
│   └── docker/
│       ├── apache-default.conf
│       └── apache-conf.conf
│
├── Server Code:
│   ├── c2-server/
│   ├── web-socket/
│   ├── database.sql
│   └── .env.example
```

---

## Support Resources

- **[Docker Documentation](https://docs.docker.com/)** - Docker basics and advanced topics
- **[Oracle Cloud Free Tier](https://oracle.com/cloud/free)** - Sign up and documentation
- **[Railway.app Docs](https://docs.railway.app/)** - Railway platform guide
- **[DuckDNS](https://www.duckdns.org/)** - Free dynamic DNS for home servers

---

## FAQ

**Q: Which option should I choose?**
A: Oracle Cloud (free forever, good performance) or Railway (easiest, free 2-3 months).

**Q: Can I test locally first?**
A: Absolutely! Run `docker-compose up` and test at localhost before deploying.

**Q: Will it really be free forever?**
A: Oracle Cloud - yes, truly free tier. Railway - free for 2-3 months, then paid.

**Q: Can I migrate between platforms?**
A: Yes! Backup database and restore on new platform.

**Q: Do I need Linux knowledge?**
A: Not really - just follow the guides step by step.

**Q: Is this secure?**
A: For testing yes, for production follow security checklist in guides.

**Q: Can I run multiple instances?**
A: Yes - modify docker-compose.yml to change ports and run multiple.

---

## Quick Decision Tree

```
┌─ Want to deploy NOW with minimal setup?
│  └─ YES: Use Railway (RAILWAY_SETUP.md)
│
├─ Want truly free FOREVER?
│  └─ YES: Use Oracle Cloud (ORACLE_CLOUD_SETUP.md)
│
├─ Have old computer you can leave on?
│  └─ YES: Use Home Server (HOME_SERVER_SETUP.md)
│
└─ Just want to test locally?
   └─ YES: Use Quick Start (QUICK_START.md)
```

---

## You're All Set!

Everything is configured and ready to deploy. Choose a platform above and follow the guide. You'll have a running C2 server in 10-30 minutes, completely free!

**Start Here:** [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

**Happy Hacking! 🎯**
