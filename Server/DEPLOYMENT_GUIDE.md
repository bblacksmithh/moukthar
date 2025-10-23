# Complete Moukthar C2 Server Deployment Guide

## Quick Navigation

Choose your deployment option:

### Local Development
- **[Docker Quick Start](QUICK_START.md)** - Run locally with one command

### Free Forever (Pick One)
- **[Oracle Cloud Always Free](ORACLE_CLOUD_SETUP.md)** ⭐ **RECOMMENDED**
  - Cost: $0/month forever
  - Uptime: 99.9% enterprise SLA
  - Setup: Moderate difficulty
  - Performance: Good

- **[Home Server](HOME_SERVER_SETUP.md)**
  - Cost: $0.17-$5/month (electricity only)
  - Uptime: Depends on your hardware
  - Setup: Easy
  - Performance: Depends on hardware

### Free Trial (Then Paid)
- **[Railway.app](RAILWAY_SETUP.md)**
  - Cost: Free for 2-3 months, then $5-10/month
  - Uptime: 99.5%
  - Setup: Very easy
  - Performance: Good

### Full Comparison
- **[Free Hosting Options](FREE_HOSTING_OPTIONS.md)** - Detailed analysis of all options

---

## Decision Tree

```
┌─ Do you want to run from home computer?
│  ├─ YES → Use Home Server Setup
│  └─ NO → Continue below
│
├─ Do you want completely free forever?
│  ├─ YES → Use Oracle Cloud (free forever)
│  └─ NO → Continue below
│
└─ Do you mind paying after 2-3 free months?
   ├─ YES → Use Railway
   └─ NO → Use Oracle Cloud or Home Server
```

---

## Recommended Path (Oracle Cloud - Free Forever)

### Step 1: Create Account
- Go to [oracle.com/cloud/free](https://oracle.com/cloud/free)
- Sign up (free account)
- Get free tier credits

### Step 2: Follow Setup Guide
- Read [ORACLE_CLOUD_SETUP.md](ORACLE_CLOUD_SETUP.md)
- Takes about 30 minutes
- No credit card charges if you stay in free tier

### Step 3: Access Server
- Open browser: `http://your-instance-ip`
- Login: `android` / `android`

### Step 4: Update Client
- Edit `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`
- Replace `localhost` with your instance IP
- Rebuild APK

---

## Alternative: Railway (Easiest Setup)

### Step 1: Create Account
- Go to [railway.app](https://railway.app)
- Sign in with GitHub

### Step 2: Follow Setup Guide
- Read [RAILWAY_SETUP.md](RAILWAY_SETUP.md)
- Takes about 10 minutes
- Super easy

### Step 3: Access Server
- Open browser: `http://your-railway-domain.railway.app`
- Login: `android` / `android`

### Step 4: Update Client
- Edit `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`
- Replace `localhost` with your Railway domain
- Rebuild APK

---

## Alternative: Home Server (Lowest Cost)

### Step 1: Get Hardware
- Use existing computer, or
- Get Raspberry Pi ($35-100)

### Step 2: Follow Setup Guide
- Read [HOME_SERVER_SETUP.md](HOME_SERVER_SETUP.md)
- Takes about 20 minutes
- Easy setup

### Step 3: Access Server
- Open browser: `http://your-domain.duckdns.org`
- Login: `android` / `android`

### Step 4: Update Client
- Edit `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`
- Replace `localhost` with your DuckDNS domain
- Rebuild APK

---

## Local Development (Fastest for Testing)

### Quick Start
```bash
cd Server
docker-compose up -d --build
```

### Access
- Browser: `http://localhost`
- WebSocket: `ws://localhost:8080`
- Login: `android` / `android`

### Stop
```bash
docker-compose down
```

---

## What's Different Between Options

| Aspect | Oracle Cloud | Railway | Home Server | Local |
|--------|--------------|---------|------------|-------|
| **Cost** | $0 forever | Free 2-3mo, then $5-10/mo | $0 + electricity | $0 |
| **Setup Time** | 30 min | 10 min | 20 min | 2 min |
| **Uptime** | 99.9% | 99.5% | Depends | N/A |
| **Reliability** | Enterprise | Good | Home network | N/A |
| **Support** | Limited | Community | Self | N/A |
| **Best For** | Production | Quick deployment | Development/local | Testing |

---

## Before You Deploy

### 1. Have You Tested Locally?

```bash
cd Server
docker-compose up -d --build
# Test at http://localhost
docker-compose down
```

✅ Everything works locally? Then deploy.

### 2. Have You Updated Credentials?

Default credentials for testing:
```
Username: android
Password: android
```

**For any real deployment, change these:**

1. Edit `docker-compose.yml`
2. Change `MYSQL_PASSWORD` and `MYSQL_USER`
3. Update `c2-server/.env` and `web-socket/.env`
4. Rebuild and deploy

### 3. Have You Updated Android Client?

The client needs to know where your server is.

Edit: `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`

```java
// Before (localhost)
private static final String C2_SERVER = "http://localhost";
public static final String WEB_SOCKET_SERVER = "ws://localhost:8080";

// After (your server)
private static final String C2_SERVER = "http://your-server-address";
public static final String WEB_SOCKET_SERVER = "ws://your-server-address:8080";
```

---

## Deployment Checklist

### Pre-Deployment
- [ ] Tested locally with `docker-compose up`
- [ ] All services running: `docker-compose ps`
- [ ] Can access http://localhost
- [ ] Can login with android/android
- [ ] Code committed to Git

### Choose Platform
- [ ] Oracle Cloud (recommended free)
- [ ] Railway (easy, free 2-3mo)
- [ ] Home Server (lowest cost)
- [ ] Other option

### Follow Platform Guide
- [ ] Read deployment guide for chosen platform
- [ ] Created account
- [ ] Configured environment variables
- [ ] Database initialized
- [ ] Services running

### Post-Deployment
- [ ] Server accessible at your domain
- [ ] Can login with android/android
- [ ] Check logs: `docker-compose logs`
- [ ] WebSocket connects successfully
- [ ] Updated Android client with server address
- [ ] Tested from mobile device

---

## Common Issues & Solutions

### Can't Access Server

1. Check services running
```bash
docker-compose ps
```

2. Check logs for errors
```bash
docker-compose logs
```

3. Verify domain/IP is correct
- Oracle Cloud: Check instance IP in console
- Railway: Check domain in settings
- Home Server: Check DuckDNS is updated

4. Check firewall
- Port 80 should be open
- Port 8080 should be open

### Database Connection Errors

1. Wait for MySQL to initialize (1-2 minutes)
2. Check database credentials in `.env` files
3. Restart MySQL: `docker-compose restart mysql`
4. Check logs: `docker-compose logs mysql`

### WebSocket Connection Fails

1. Verify `WEBSOCKET_URI` in docker-compose.yml
2. Check WebSocket container: `docker-compose ps websocket`
3. Test directly: `curl http://your-domain:8080`
4. Check firewall allows port 8080

### High Memory/CPU Usage

1. Check what's running: `docker stats`
2. Limit resources in docker-compose.yml:
```yaml
deploy:
  resources:
    limits:
      memory: 512M
```
3. Restart services: `docker-compose restart`

---

## Monitoring Your Deployment

### Check Status
```bash
# All services
docker-compose ps

# Full details
docker-compose ps -a
```

### View Logs
```bash
# All logs
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# Specific service
docker-compose logs -f php-apache
docker-compose logs -f mysql
docker-compose logs -f websocket
```

### Check System Resources
```bash
docker stats
```

### Test Connectivity
```bash
# From same network
curl http://your-domain

# WebSocket
curl http://your-domain:8080
```

---

## Maintenance Tasks

### Weekly
- Check logs for errors
- Monitor disk usage
- Test connectivity

### Monthly
- Update code: `git pull`
- Backup database: `docker-compose exec mysql mysqldump -u android -p cc > backup.sql`
- Review logs
- Monitor resource usage

### Quarterly
- Update Docker: `docker version`
- Update system packages
- Review security settings
- Test disaster recovery

### Yearly
- Full security audit
- Database optimization
- Performance review
- Plan upgrades

---

## Scaling Up

As your C2 server grows, consider:

1. **More Compute (Oracle Cloud)**
   - Upgrade from Always Free to paid tier
   - Better performance, more resources

2. **Load Balancing**
   - Multiple instances behind load balancer
   - Horizontal scaling

3. **Database Optimization**
   - Add indexes
   - Archive old data
   - Increase database resources

4. **Caching**
   - Redis for session/data caching
   - Reduce database load

5. **Monitoring**
   - Set up alerts
   - Monitor metrics 24/7
   - Log aggregation

---

## Troubleshooting Resources

- **[Free Hosting Options](FREE_HOSTING_OPTIONS.md)** - Detailed comparison and common issues
- **[Docker Setup](DOCKER_SETUP.md)** - Comprehensive Docker guide and troubleshooting
- **[Oracle Cloud Setup](ORACLE_CLOUD_SETUP.md)** - Oracle-specific issues
- **[Railway Setup](RAILWAY_SETUP.md)** - Railway-specific issues
- **[Home Server Setup](HOME_SERVER_SETUP.md)** - Home server-specific issues

---

## Getting Help

1. Check the appropriate setup guide for your platform
2. Review logs: `docker-compose logs`
3. Check docker-compose.yml for typos
4. Verify environment variables are set
5. Test locally first: `docker-compose up`

---

## Next Steps After Deployment

1. ✅ Server deployed and running
2. ✅ Can access at your domain
3. ✅ Can login with credentials
4. 🔄 **Update Android client** with server address
5. 🔄 **Rebuild APK** with new server address
6. 🔄 **Test from mobile device**
7. 🔄 **Monitor logs** for errors
8. 🔄 **Set up backups** if production
9. 🔄 **Configure security** for production
10. 🔄 **Set up monitoring** and alerts

---

## Production Readiness Checklist

For production deployment, ensure:

- [ ] Changed default credentials
- [ ] Enabled HTTPS/WSS encryption
- [ ] Set up database backups
- [ ] Configured monitoring and alerts
- [ ] Set up log aggregation
- [ ] Configured firewall rules
- [ ] Enabled rate limiting
- [ ] Set up DDoS protection
- [ ] Documented all configurations
- [ ] Tested disaster recovery
- [ ] Set up redundancy/high availability
- [ ] Reviewed security settings

---

## FAQ

**Q: Which option is best?**
A: Oracle Cloud - free forever with good performance.

**Q: Can I migrate between platforms later?**
A: Yes! Database is portable. Just backup and restore.

**Q: What if Oracle Cloud is too complex?**
A: Use Railway - easier setup, free for 2-3 months.

**Q: Can I run from my laptop?**
A: Yes! Use Home Server setup, but laptop must stay on.

**Q: Do I need a credit card?**
A: Most free options require credit card for verification (charges are optional).

**Q: What's the best for learning?**
A: Local deployment with Docker - no costs, fastest feedback.

**Q: Can I deploy to multiple places?**
A: Yes! Deploy to Oracle Cloud AND Railway for redundancy.

**Q: What happens after free tier ends?**
A: Migrate to another platform or pay. Oracle Cloud is free forever.

---

## Support & Resources

- Docker Docs: https://docs.docker.com/
- Oracle Cloud: https://docs.oracle.com/cloud/
- Railway Docs: https://docs.railway.app/
- DuckDNS: https://www.duckdns.org/
- Docker Compose: https://docs.docker.com/compose/

---

**Choose your path above and follow the guide. You'll have a running C2 server in 10-30 minutes!**
