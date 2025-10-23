# Quick Start - Docker Deployment

## One-Command Setup

```bash
cd Server
docker-compose up -d --build
```

## Access the Server

1. **Web Interface:** http://localhost
2. **WebSocket:** ws://localhost:8080
3. **Database:** localhost:3306

## Default Credentials

- **Username:** android
- **Password:** android

## Check Status

```bash
docker-compose ps
```

## View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f php-apache
docker-compose logs -f mysql
docker-compose logs -f websocket
```

## Stop Services

```bash
docker-compose down
```

## Full Guide

See [DOCKER_SETUP.md](DOCKER_SETUP.md) for detailed configuration, troubleshooting, and production deployment.

## What Was Configured

✅ MySQL Database (port 3306)
✅ PHP/Apache Web Server (port 80)
✅ WebSocket Server (port 8080)
✅ Database initialization
✅ Environment variables
✅ PHP upload limits (128MB)
✅ Apache rewrite rules
✅ Composer dependencies

## Configuration Files

- **Docker:** `Dockerfile`, `Dockerfile.websocket`, `docker-compose.yml`
- **Database:** `database.sql`
- **Environment:** `c2-server/.env`, `web-socket/.env`
- **Apache:** `docker/apache-default.conf`, `docker/apache-conf.conf`
- **Client:** `Client/app/src/main/java/com/ot/grhq/client/functionality/Utils.java`

## Next Steps

1. Verify all containers are running: `docker-compose ps`
2. Check database initialized: `docker-compose logs mysql`
3. Access http://localhost and login with android/android
4. Monitor WebSocket connections: `docker-compose logs websocket`

Need help? Check [DOCKER_SETUP.md](DOCKER_SETUP.md)
