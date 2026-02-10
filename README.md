# SkillBridge - Tutor Booking Platform

A full-stack tutor booking platform built with Next.js, Express.js, PostgreSQL, and Docker.

## 🚀 Quick Start with Docker

### Prerequisites
- Docker Desktop installed and running
- Git (for cloning the repository)

### 1. Clone and Setup
```bash
git clone <repository-url>
cd "Assignment 4"
```

### 2. Environment Configuration
Copy the example environment file and update the values:
```bash
copy .env.docker .env
```

**Important**: Update these values in `.env`:
- `DB_PASSWORD`: Change to a secure password
- `BETTER_AUTH_SECRET`: Generate a 32+ character secret key

### 3. Run with Docker
```bash
# Start all services
docker-compose up --build -d

# Or use the management script
docker-manager.bat
```

### 4. Access the Application
- **Main Application**: http://localhost (via Nginx)
- **Client Direct**: http://localhost:3000
- **Server API**: http://localhost:9000
- **Database**: localhost:5432

## 🛠️ Development

### Local Development (without Docker)
```bash
# Install dependencies
cd client && npm install
cd ../server && npm install

# Start database (Docker)
docker-compose up postgres -d

# Start server
cd server && npm run dev

# Start client (new terminal)
cd client && npm run dev
```

### Docker Development Mode
```bash
# Use development compose file
docker-compose -f docker-compose.dev.yml up --build
```

## 📁 Project Structure
```
Assignment 4/
├── client/                 # Next.js frontend
│   ├── app/               # App router pages
│   ├── components/        # Reusable components
│   ├── lib/              # Utilities and configurations
│   └── Dockerfile        # Client Docker configuration
├── server/                # Express.js backend
│   ├── src/              # Source code
│   ├── prisma/           # Database schema and migrations
│   └── Dockerfile.optimized # Server Docker configuration
├── docker-compose.yml     # Production Docker setup
├── nginx.conf            # Nginx reverse proxy config
└── README.md            # This file
```

## 🔧 Available Scripts

### Docker Management
- `docker-manager.bat` - Interactive Docker management
- `test-docker.bat` - Health check all services

### Client Scripts
```bash
npm run dev      # Development server
npm run build    # Production build
npm run start    # Start production server
```

### Server Scripts
```bash
npm run dev      # Development with hot reload
npm run build    # Build for production
npm run start:prod # Start production server
npm run seed     # Seed database
```

## 🐳 Docker Services

### Services Overview
- **postgres**: PostgreSQL database (port 5432)
- **server**: Express.js API (port 9000)
- **client**: Next.js frontend (port 3000)
- **nginx**: Reverse proxy (port 80)

### Health Checks
All services include health checks for monitoring:
```bash
# Check service status
docker ps

# View logs
docker logs skillbridge-server
docker logs skillbridge-client

# Run health check script
test-docker.bat
```

## 🔒 Security Features
- Helmet.js for security headers
- CORS configuration
- Rate limiting
- Input validation with Zod
- SQL injection protection with Prisma
- Authentication with Better Auth

## 🗄️ Database
- **Engine**: PostgreSQL 15
- **ORM**: Prisma
- **Migrations**: Automatic on container start
- **Seeding**: Available via npm scripts

### Database Commands
```bash
# Run migrations
docker exec skillbridge-server npx prisma migrate deploy

# Seed database
docker exec skillbridge-server npm run seed

# Access database
docker exec -it skillbridge-db psql -U postgres -d skillbridge
```

## 🚨 Troubleshooting

### Common Issues

1. **Port Conflicts**
   - Ensure ports 80, 3000, 5432, and 9000 are available
   - Stop other services using these ports

2. **Database Connection**
   - Wait for database to be ready (health check)
   - Check DATABASE_URL in server environment

3. **Build Failures**
   - Clear Docker cache: `docker system prune -f`
   - Rebuild without cache: `docker-compose build --no-cache`

### Logs and Debugging
```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker logs skillbridge-server -f
docker logs skillbridge-client -f

# Execute commands in containers
docker exec -it skillbridge-server sh
docker exec -it skillbridge-client sh
```

## 🌐 Environment Variables

### Required Variables
- `DB_PASSWORD`: PostgreSQL password
- `BETTER_AUTH_SECRET`: Authentication secret (32+ chars)
- `BETTER_AUTH_URL`: Auth service URL
- `NEXT_PUBLIC_API_URL`: API endpoint for client

### Optional Variables
- `NODE_ENV`: Environment (development/production)
- `PORT`: Server port (default: 9000)
- `APP_URL`: Application URL

## 📝 API Documentation
The server provides a RESTful API with the following endpoints:
- `/api/auth/*` - Authentication routes
- `/api/admin/*` - Admin management
- `/api/student/*` - Student operations
- `/api/tutor/*` - Tutor operations
- `/api/public/*` - Public data

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Docker
5. Submit a pull request

## 📄 License
This project is licensed under the ISC License.