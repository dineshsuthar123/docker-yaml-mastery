# P4: WordPress + MySQL + phpMyAdmin

## 🎯 **Project Overview**
Complete WordPress CMS setup with MySQL database, phpMyAdmin interface, and automated backup system.

## 🚀 **Quick Start**

### 1. Environment Setup
```bash
# Copy environment template
cp .env.template .env

# Edit with your secure passwords
nano .env
```

### 2. Start Services
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 3. Access Applications
- **WordPress**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081

## 🔒 **Security Notes**

⚠️ **IMPORTANT**: Never commit `.env` files to version control!

- Use strong passwords (16+ characters)
- Different passwords for each environment
- Regular password rotation in production

## 📊 **Services**

| Service | Port | Purpose |
|---------|------|---------|
| WordPress | 8080 | Main CMS application |
| MySQL | 3306 | Database (internal) |
| phpMyAdmin | 8081 | Database management |
| Backup | - | Automated daily backups |

## 🛠️ **Features**

- ✅ Health checks for database reliability
- ✅ Persistent data storage
- ✅ Automated daily backups (7-day retention)
- ✅ Database management interface
- ✅ Production-ready configuration

## 🔧 **Common Commands**

```bash
# View service status
docker-compose ps

# Access WordPress container
docker-compose exec wordpress bash

# Access MySQL container
docker-compose exec mysql mysql -u root -p

# Manual backup
docker-compose exec backup sh -c "tar -czf /backups/manual-backup.tar.gz -C /backup ."

# Stop services
docker-compose down

# Complete cleanup
docker-compose down -v
```

## 📁 **Project Structure**

```
p4/
├── docker-compose.yml    # Main orchestration
├── .env.template        # Environment template
├── .env                 # Your local environment (git-ignored)
├── .gitignore          # Security protection
├── uploads.ini         # PHP upload configuration
├── backups/            # Backup storage (git-ignored)
└── mysql-init/         # Database initialization scripts
```

## 🎓 **Learning Objectives**

After completing this project, you'll understand:

- ✅ Multi-service orchestration
- ✅ Database health checks
- ✅ Volume management and persistence
- ✅ Environment variable security
- ✅ Automated backup strategies
- ✅ Production-ready restart policies

## 🚨 **Troubleshooting**

### Database Connection Issues
```bash
# Check MySQL health
docker-compose exec mysql mysqladmin ping -h localhost

# Verify environment variables
docker-compose config
```

### Backup Issues
```bash
# Check backup logs
docker-compose logs backup

# Manual backup test
docker-compose exec backup ls -la /backups
```

## 🔄 **Next Steps**

Ready for more advanced concepts? Try:
- **P5**: ELK Stack for logging
- **P6**: Django + Celery + Redis
- **P7**: RabbitMQ + Microservices
