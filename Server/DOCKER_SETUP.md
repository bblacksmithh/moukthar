# Moukthar C2 Server - Docker Setup Guide

This guide will help you deploy the Moukthar C2 Server using Docker and Docker Compose.

## Prerequisites

- Docker installed ([Install Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed ([Install Docker Compose](https://docs.docker.com/compose/install/))
- At least 2GB of free disk space

## Directory Structure

```
Server/
├── c2-server/          # PHP C2 Server (Apache)
├── web-socket/         # WebSocket Server (PHP)
├── database.sql        # Database initialization script
├── Dockerfile          # PHP/Apache image definition
├── Dockerfile.websocket # WebSocket PHP CLI image definition
├── docker-compose.yml  # Compose configuration
└── docker/
    ├── apache-default.conf  # Apache VirtualHost config
    └── apache-conf.conf     # Apache directory config
```

## Quick Start

### 1. Build and Start Containers

```bash
cd Server
docker-compose up -d --build
```

This will:
- Create and start MySQL database container
- Create and start PHP/Apache container
- Create and start WebSocket server container
- Initialize the database with `database.sql`
- Install all PHP dependencies via Composer

### 2. Wait for Services to Be Ready

```bash
# Check container status
docker-compose ps

# Wait for MySQL to be healthy (may take 30-60 seconds)
docker-compose logs -f mysql
```

### 3. Access the C2 Server

Open your browser and navigate to:
```
http://localhost
```

Default credentials:
- **Username:** android
- **Password:** android

### 4. Monitor Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f php-apache   # Apache/PHP server
docker-compose logs -f mysql         # Database
docker-compose logs -f websocket     # WebSocket server
```

## Configuration

### Database Configuration

The MySQL credentials are set in `docker-compose.yml`:
- **User:** android
- **Password:** android
- **Database:** cc

These are automatically configured in the `.env` files:
- `c2-server/.env`
- `web-socket/.env`

### WebSocket Server Configuration

The WebSocket server runs on port `8080` and is accessible at:
```
ws://localhost:8080
```

This is configured in:
- `docker-compose.yml` (WEBSOCKET_URI environment variable)
- `c2-server/.env`
- `web-socket/.env`

### PHP Upload Limits

The Docker image is configured with:
- `upload_max_filesize = 128M`
- `post_max_size = 129M`

To modify these, edit the `Dockerfile` and rebuild.

## Common Tasks

### Stop All Containers

```bash
docker-compose down
```

### Stop and Remove All Data (Warning: Deletes Database)

```bash
docker-compose down -v
```

### Restart Services

```bash
docker-compose restart
```

### Rebuild Containers

```bash
docker-compose down
docker-compose up -d --build
```

### Access MySQL Database Directly

```bash
docker-compose exec mysql mysql -u android -p cc
# Password: android
```

### View Database Logs

```bash
docker-compose logs mysql
```

### Execute Commands in Running Container

```bash
# Execute PHP command
docker-compose exec php-apache php -v

# Execute Bash command
docker-compose exec php-apache bash

# Execute Composer command
docker-compose exec php-apache composer --version
```

## Networking

All services are connected via the `moukthar-network` bridge network:

- **php-apache (web):** Port 80 (exposed)
- **mysql (database):** Port 3306 (exposed for external access, not required internally)
- **websocket (ws):** Port 8080 (exposed)

Services communicate internally using container names:
- Database host: `mysql`
- WebSocket host: `websocket` (from other containers)

## Troubleshooting

### MySQL Container Fails to Start

```bash
# Check logs
docker-compose logs mysql

# MySQL needs time to initialize, wait 30-60 seconds and retry
docker-compose restart mysql
```

### WebSocket Connection Issues

1. Check if the WebSocket container is running:
```bash
docker-compose ps websocket
```

2. Check WebSocket logs:
```bash
docker-compose logs websocket
```

3. Verify port 8080 is accessible:
```bash
# From host machine
curl http://localhost:8080
```

4. Update `WEBSOCKET_URI` in `docker-compose.yml` if using a different hostname/IP

### Database Connection Errors

1. Verify MySQL container is healthy:
```bash
docker-compose ps mysql
```

2. Check .env files are correctly configured:
```bash
cat c2-server/.env
cat web-socket/.env
```

3. Verify database was initialized:
```bash
docker-compose exec mysql mysql -u android -p cc -e "SHOW TABLES;"
# Password: android
```

### Port Already in Use

If ports 80, 3306, or 8080 are already in use, modify the port mappings in `docker-compose.yml`:

```yaml
services:
  php-apache:
    ports:
      - "8000:80"    # Change 8000 to an available port
  mysql:
    ports:
      - "3307:3306"  # Change 3307 to an available port
  websocket:
    ports:
      - "8081:8080"  # Change 8081 to an available port
```

Then update client configurations to use the new ports.

## Security Notes

⚠️ **Important:** These are default credentials. For production use:

1. Change default credentials in `docker-compose.yml`
2. Update `.env` files with new credentials
3. Use environment variables or secrets management
4. Enable HTTPS/WSS for production
5. Restrict port exposure as needed

## Deployment to Remote Server

To deploy to a remote server:

1. Copy the Server directory to your remote machine
2. Modify `docker-compose.yml` to use the server's IP/hostname for `WEBSOCKET_URI`
3. Update client code (Utils.java) to point to the server's IP/hostname
4. Run `docker-compose up -d --build`

Example for remote server at `192.168.1.100`:

```yaml
environment:
  WEBSOCKET_URI: 'ws://192.168.1.100:8080'
```

## Performance Considerations

- Default MySQL image uses `utf8mb4_0900_ai_ci` collation
- PHP CLI runs with default settings for WebSocket
- Apache runs with default mods (rewrite enabled)

For high-traffic environments, consider:
- Increasing MySQL memory allocation
- Configuring Apache worker processes
- Using connection pooling
- Implementing caching strategies

## Getting Help

Check logs first for error messages:
```bash
docker-compose logs
```

Common issues and their solutions are listed in the Troubleshooting section above.
