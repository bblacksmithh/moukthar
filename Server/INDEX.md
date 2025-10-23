# Moukthar C2 Server Documentation Index

## 🚀 Start Here

### For First-Time Users
1. **[README_DEPLOYMENT.md](README_DEPLOYMENT.md)** - Master overview (5 min read)
2. Choose your deployment option (see table below)
3. Follow the appropriate setup guide

### Quick Reference
- **[QUICK_START.md](QUICK_START.md)** - Fastest local setup (2 minutes)
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Complete decision tree and master guide

---

## 📚 All Guides

### Overview & Reference
| Guide | Purpose | Read Time |
|-------|---------|-----------|
| [README_DEPLOYMENT.md](README_DEPLOYMENT.md) | Master overview, quick reference | 5 min |
| [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) | Complete guide with decision tree | 10 min |
| [SETUP_SUMMARY.md](SETUP_SUMMARY.md) | What was set up and how | 10 min |

### Docker & Local
| Guide | Purpose | Read Time |
|-------|---------|-----------|
| [QUICK_START.md](QUICK_START.md) | Local Docker setup | 2 min |
| [DOCKER_SETUP.md](DOCKER_SETUP.md) | Complete Docker documentation | 20 min |

### Free Hosting Options
| Guide | Purpose | Read Time |
|-------|---------|-----------|
| [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md) | Compare all free hosting options | 10 min |

### Platform-Specific Guides
| Platform | Guide | Cost | Setup Time |
|----------|-------|------|------------|
| Oracle Cloud | [ORACLE_CLOUD_SETUP.md](ORACLE_CLOUD_SETUP.md) | $0/month forever | 30 min |
| Railway | [RAILWAY_SETUP.md](RAILWAY_SETUP.md) | Free 2-3 months | 10 min |
| Home Server | [HOME_SERVER_SETUP.md](HOME_SERVER_SETUP.md) | Electricity only | 20 min |

---

## 🎯 Quick Decision

### Choose Based On:

**I want the absolute easiest setup:**
→ [RAILWAY_SETUP.md](RAILWAY_SETUP.md)

**I want completely free forever:**
→ [ORACLE_CLOUD_SETUP.md](ORACLE_CLOUD_SETUP.md)

**I want the lowest cost:**
→ [HOME_SERVER_SETUP.md](HOME_SERVER_SETUP.md)

**I just want to test locally:**
→ [QUICK_START.md](QUICK_START.md)

**I want to understand all options:**
→ [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md)

**I want a complete guide:**
→ [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

## 📋 Setup Checklist

- [ ] Read [README_DEPLOYMENT.md](README_DEPLOYMENT.md)
- [ ] Choose deployment option
- [ ] Read platform-specific guide
- [ ] Follow setup steps
- [ ] Update Android client
- [ ] Test deployment
- [ ] Monitor logs

---

## 🔧 Common Tasks

### Start Local Services
```bash
cd Server
docker-compose up -d --build
```
→ See [QUICK_START.md](QUICK_START.md)

### Check Service Status
```bash
docker-compose ps
docker-compose logs
```
→ See [DOCKER_SETUP.md](DOCKER_SETUP.md)

### Deploy to Cloud
→ See [ORACLE_CLOUD_SETUP.md](ORACLE_CLOUD_SETUP.md) or [RAILWAY_SETUP.md](RAILWAY_SETUP.md)

### Run from Home
→ See [HOME_SERVER_SETUP.md](HOME_SERVER_SETUP.md)

### Compare Options
→ See [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md)

---

## 📱 Android Client

Update server address in:
```
Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java
```

See setup guides for platform-specific addresses.

---

## 🔐 Credentials

**Default (for testing):**
- Username: android
- Password: android

⚠️ **Change for production!**

---

## 📊 Services

| Service | Port | Purpose |
|---------|------|---------|
| Apache | 80 | C2 Web UI |
| WebSocket | 8080 | Real-time comms |
| MySQL | 3306 | Database |

---

## 📁 File Structure

```
Server/
├── INDEX.md                      ← You are here
├── README_DEPLOYMENT.md          ← Start here
├── QUICK_START.md                ← Local setup
├── DOCKER_SETUP.md               ← Docker docs
├── FREE_HOSTING_OPTIONS.md       ← Compare options
├── DEPLOYMENT_GUIDE.md           ← Master guide
├── SETUP_SUMMARY.md              ← What was done
│
├── Platform Guides:
├── ORACLE_CLOUD_SETUP.md         ← Free forever
├── RAILWAY_SETUP.md              ← Easiest
├── HOME_SERVER_SETUP.md          ← Run from home
│
├── Docker Files:
├── Dockerfile
├── Dockerfile.websocket
├── docker-compose.yml
└── docker/
    ├── apache-default.conf
    └── apache-conf.conf
```

---

## ❓ FAQ

**Q: Which option should I choose?**
A: Oracle Cloud (free forever) or Railway (easiest)

**Q: Can I test locally first?**
A: Yes! [QUICK_START.md](QUICK_START.md) - 2 minutes

**Q: How much does it cost?**
A: Oracle Cloud: $0/month forever. Railway: Free 2-3 months then $5-10/month.

**Q: Do I need Linux knowledge?**
A: No, just follow the guides step by step.

---

## 🆘 Help & Troubleshooting

1. Check relevant platform guide (links above)
2. Review logs: `docker-compose logs`
3. Check service status: `docker-compose ps`
4. Verify environment variables are set
5. Test locally first: `docker-compose up -d`

---

## 📖 Reading Order

**Recommended reading order:**

1. This file (INDEX.md) ← You are here
2. [README_DEPLOYMENT.md](README_DEPLOYMENT.md) ← 5 min overview
3. Choose platform from decision tree
4. Read platform-specific guide
5. Follow step-by-step setup
6. Reference guides as needed

---

## 🎓 Learning Resources

- [Docker Documentation](https://docs.docker.com/)
- [Oracle Cloud Free Tier](https://oracle.com/cloud/free/)
- [Railway.app Documentation](https://docs.railway.app/)
- [DuckDNS (for home servers)](https://www.duckdns.org/)

---

## ✅ Status

✅ Docker infrastructure created
✅ Code updated for deployment
✅ All documentation written
✅ Multiple deployment options available
✅ Ready to deploy

---

**Next Step:** Read [README_DEPLOYMENT.md](README_DEPLOYMENT.md) (5 minutes)
