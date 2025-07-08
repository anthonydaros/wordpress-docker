# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is an OpenLiteSpeed WordPress Docker container environment that provides a complete LAMP stack with WordPress, OpenLiteSpeed web server, MariaDB, Redis, and phpMyAdmin. The project is based on the LiteSpeed Tech official Docker environment and includes automated scripts for domain management, SSL certificates, and WordPress installations.

## Architecture
- **OpenLiteSpeed**: High-performance web server with LiteSpeed Cache
- **MariaDB 11.8**: Database server
- **Redis**: Object caching for WordPress
- **phpMyAdmin**: Database management interface
- **WordPress**: CMS with LiteSpeed Cache plugin pre-installed

## Environment Configuration
All configuration is managed through the `.env` file:
- `OLS_VERSION`: OpenLiteSpeed version (default: 1.8.3)
- `PHP_VERSION`: PHP version (default: lsphp83)
- `MYSQL_*`: Database credentials
- `DOMAIN`: Default domain (default: localhost)
- `TimeZone`: Server timezone

## Common Commands

### Container Management
```bash
# Start all services
docker compose up

# Start in daemon mode
docker compose up -d

# Stop services
docker compose stop

# Stop and remove containers
docker compose down

# Build with customizations
docker compose up --build
```

### Initial Setup
```bash
# Set web admin password (highly recommended)
bash bin/webadmin.sh my_password

# Create demo WordPress site
bash bin/demosite.sh
```

### Domain Management
```bash
# Add new domain and virtual host
bash bin/domain.sh -A example.com

# Delete domain and virtual host
bash bin/domain.sh -D example.com
```

### Database Management
```bash
# Auto-generate database credentials
bash bin/database.sh -D example.com

# Specify custom database details
bash bin/database.sh -D example.com -U username -P password -DB dbname
```

### WordPress Installation
```bash
# Install WordPress for a domain (run database.sh first)
bash bin/appinstall.sh -A wordpress -D example.com
```

### SSL Certificate Management
```bash
# First-time ACME installation
bash bin/acme.sh -I -E your-email@example.com

# Apply Let's Encrypt certificate
bash bin/acme.sh -D example.com

# Renew specific domain
bash bin/acme.sh -r -D example.com

# Renew all domains
bash bin/acme.sh -R

# Force renewal
bash bin/acme.sh -f -D example.com
```

### Web Server Management
```bash
# Restart LiteSpeed
bash bin/webadmin.sh -R

# Upgrade to latest version
bash bin/webadmin.sh -U

# Enable OWASP ModSecurity
bash bin/webadmin.sh -M enable

# Disable OWASP ModSecurity
bash bin/webadmin.sh -M disable
```

## Access Points
- **WordPress Site**: http://localhost (or configured domain)
- **Web Admin Panel**: https://localhost:7080 (default: admin/123456)
- **phpMyAdmin**: http://localhost:8086 or https://localhost:8446
- **OpenLiteSpeed Ports**: 86 (HTTP), 446 (HTTPS)

## Directory Structure
- `sites/`: Document roots for virtual hosts
- `lsws/conf/`: OpenLiteSpeed configuration files
- `lsws/admin-conf/`: Admin panel configuration
- `logs/`: Web server and access logs
- `data/db/`: MySQL database files
- `acme/`: Let's Encrypt certificates
- `bin/`: Management scripts

## Key Files
- `docker-compose.yml`: Service definitions and container orchestration
- `.env`: Environment variables and configuration
- `bin/`: Directory containing all management scripts

## Redis Configuration
For WordPress object caching, configure LiteSpeed Cache plugin:
- Go to WordPress > LSCache Plugin > Cache > Object
- Select Redis method
- Set Host field to `redis`

## Customization
To add custom packages:
1. Create `custom/Dockerfile` with extensions
2. Add `build: ./custom` to docker-compose.yml under litespeed service
3. Run `docker compose up --build`

## Development Workflow
1. Configure `.env` file with desired settings
2. Start containers with `docker compose up -d`
3. Set admin password with `bin/webadmin.sh`
4. Create domains with `bin/domain.sh`
5. Set up databases with `bin/database.sh`
6. Install WordPress with `bin/appinstall.sh`
7. Configure SSL with `bin/acme.sh`