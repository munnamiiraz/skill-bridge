# SkillBridge Deployment Guide

## 🚀 Quick Deployment

### Option 1: One-Click Start
```bash
start.bat
```
This script will:
- Check Docker installation
- Set up environment variables
- Start all services
- Provide access URLs

### Option 2: Manual Deployment

#### Step 1: Environment Setup
```bash
# Copy environment template
copy .env.docker .env

# Edit .env file and update:
# - DB_PASSWORD=your_secure_password
# - BETTER_AUTH_SECRET=your_32_plus_character_secret
```

#### Step 2: Start Services
```bash
# Production deployment
docker-compose up --build -d

# Development deployment
docker-compose -f docker-compose.dev.yml up --build -d
```

#### Step 3: Verify Deployment
```bash
# Run health checks
test-docker.bat

# Or check manually
docker ps
curl http://localhost:9000/health
```

## 🔧 Configuration

### Port Configuration
The application uses the following ports:
- **Client**: 3000 (Next.js frontend)
- **Server**: 9000 (Express.js API) 
- **Database**: 5432 (PostgreSQL)
- **Nginx**: 80 (Reverse proxy)

### Environment Variables

#### Required Variables
```env
# Database
DB_PASSWORD=your_secure_password_here

# Authentication
BETTER_AUTH_SECRET=your-super-secret-key-minimum-32-characters
BETTER_AUTH_URL=http://localhost:9000

# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:9000
```

#### Optional Variables
```env
# Application URLs
APP_URL=http://localhost:3000

# Email Configuration (for production)
APP_USER=your_email@gmail.com
APP_PASS=your_app_password

# Google OAuth (optional)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

## 🐳 Docker Services

### Service Architecture
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    Nginx    │    │   Client    │    │   Server    │
│   Port 80   │────│  Port 3000  │────│  Port 9000  │
└─────────────┘    └─────────────┘    └─────────────┘
                                              │
                                      ┌─────────────┐
                                      │ PostgreSQL  │
                                      │  Port 5432  │
                                      └─────────────┘
```

### Service Details

#### PostgreSQL Database
- **Image**: postgres:15-alpine
- **Container**: skillbridge-db
- **Port**: 5432
- **Volume**: postgres_data
- **Health Check**: pg_isready

#### Express.js Server
- **Build**: ./server/Dockerfile.optimized
- **Container**: skillbridge-server
- **Port**: 9000
- **Health Check**: /health endpoint
- **Dependencies**: PostgreSQL

#### Next.js Client
- **Build**: ./client/Dockerfile
- **Container**: skillbridge-client
- **Port**: 3000
- **Dependencies**: Server

#### Nginx Proxy
- **Image**: nginx:alpine
- **Container**: skillbridge-nginx
- **Port**: 80
- **Config**: ./nginx.conf
- **Routes**: 
  - `/` → Client (3000)
  - `/api/` → Server (9000)

## 🛠️ Management Commands

### Docker Management
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild services
docker-compose up --build -d

# Clean up
docker-compose down -v --rmi all
```

### Database Management
```bash
# Run migrations
docker exec skillbridge-server npx prisma migrate deploy

# Seed database
docker exec skillbridge-server npm run seed

# Access database shell
docker exec -it skillbridge-db psql -U postgres -d skillbridge

# Backup database
docker exec skillbridge-db pg_dump -U postgres skillbridge > backup.sql

# Restore database
docker exec -i skillbridge-db psql -U postgres skillbridge < backup.sql
```

### Application Management
```bash
# Restart specific service
docker-compose restart server

# Scale services (if needed)
docker-compose up -d --scale server=2

# Update single service
docker-compose up -d --no-deps server
```

## 🔍 Monitoring & Debugging

### Health Checks
```bash
# Automated health check
test-docker.bat

# Manual checks
curl http://localhost/health
curl http://localhost:3000
curl http://localhost:9000/health
```

### Log Analysis
```bash
# All logs
docker-compose logs -f

# Specific service logs
docker logs skillbridge-server -f
docker logs skillbridge-client -f
docker logs skillbridge-db -f

# Error logs only
docker-compose logs --tail=50 server | findstr ERROR
```

### Performance Monitoring
```bash
# Container stats
docker stats

# Resource usage
docker system df

# Network inspection
docker network ls
docker network inspect assignment4_skillbridge-network
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Find process using port
netstat -ano | findstr :9000
netstat -ano | findstr :3000

# Kill process (replace PID)
taskkill /PID <PID> /F
```

#### 2. Database Connection Issues
```bash
# Check database status
docker exec skillbridge-db pg_isready -U postgres

# Reset database
docker-compose down -v
docker-compose up postgres -d
```

#### 3. Build Failures
```bash
# Clear Docker cache
docker system prune -f

# Rebuild without cache
docker-compose build --no-cache

# Remove all containers and rebuild
docker-compose down -v --rmi all
docker-compose up --build -d
```

#### 4. Environment Variable Issues
```bash
# Check container environment
docker exec skillbridge-server env

# Restart with new environment
docker-compose down
docker-compose up -d
```

### Debug Mode
```bash
# Run in development mode
docker-compose -f docker-compose.dev.yml up --build

# Access container shell
docker exec -it skillbridge-server sh
docker exec -it skillbridge-client sh

# Check container logs in real-time
docker logs skillbridge-server -f --tail=100
```

## 📊 Production Considerations

### Security
- Change default passwords
- Use strong secrets (32+ characters)
- Enable HTTPS in production
- Configure firewall rules
- Regular security updates

### Performance
- Monitor resource usage
- Set up log rotation
- Configure database backups
- Use production database
- Enable caching

### Scaling
- Use Docker Swarm or Kubernetes
- Set up load balancing
- Configure horizontal scaling
- Monitor application metrics
- Set up alerting

## 🔄 Updates & Maintenance

### Application Updates
```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose up --build -d

# Run migrations if needed
docker exec skillbridge-server npx prisma migrate deploy
```

### Database Maintenance
```bash
# Backup before updates
docker exec skillbridge-db pg_dump -U postgres skillbridge > backup_$(date +%Y%m%d).sql

# Update database schema
docker exec skillbridge-server npx prisma migrate deploy

# Optimize database
docker exec skillbridge-db psql -U postgres -d skillbridge -c "VACUUM ANALYZE;"
```

### System Maintenance
```bash
# Clean up unused resources
docker system prune -f

# Update base images
docker-compose pull
docker-compose up -d

# Monitor disk usage
docker system df
```

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Review container logs
3. Verify environment configuration
4. Test with development mode
5. Check Docker and system resources

For additional help, refer to:
- Docker documentation
- Next.js documentation  
- Express.js documentation
- PostgreSQL documentation