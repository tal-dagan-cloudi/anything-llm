# Development Environment Setup

This guide explains how to run Mind.Law in development mode.

## Quick Start

### Using the dev.sh Script (Recommended)

The `dev.sh` script provides an easy way to manage all development services.

```bash
# Start all services
./dev.sh start

# Stop all services
./dev.sh stop

# Restart all services
./dev.sh restart

# Check service status
./dev.sh status

# View logs in real-time
./dev.sh logs
```

### Services

The script starts three services:

- **Frontend** (http://localhost:3000) - React application
- **Server** (http://localhost:3001) - Express API server
- **Collector** (http://localhost:8888) - Document processing service

### Logs

All logs are stored in the `logs/` directory:
- `logs/frontend.log` - Frontend service logs
- `logs/server.log` - Server service logs
- `logs/collector.log` - Collector service logs

### Manual Setup (Alternative)

If you prefer to run services manually:

```bash
# Terminal 1 - Frontend
cd frontend
yarn dev

# Terminal 2 - Server
cd server
yarn dev

# Terminal 3 - Collector
cd collector
yarn dev
```

Or use the combined command:

```bash
yarn dev:all
```

## Environment Variables

Make sure you have the required environment files:

- `frontend/.env.local` or `frontend/.env`
- `server/.env.development` or `server/.env`
- `collector/.env`

## Troubleshooting

### Ports Already In Use

If you get port conflicts:

```bash
# Check what's using the ports
lsof -i:3000
lsof -i:3001
lsof -i:8888

# Kill processes on specific ports
kill -9 $(lsof -ti:3000)
kill -9 $(lsof -ti:3001)
kill -9 $(lsof -ti:8888)

# Or let the script clean up
./dev.sh stop
```

### Services Won't Start

1. Make sure all dependencies are installed:
   ```bash
   cd frontend && yarn install
   cd ../server && yarn install
   cd ../collector && yarn install
   ```

2. Check the logs for errors:
   ```bash
   ./dev.sh logs
   ```

3. Try a full restart:
   ```bash
   ./dev.sh stop
   ./dev.sh start
   ```

### Stale Processes

If services appear stuck:

```bash
# Force stop and clean up
./dev.sh stop

# Manually kill all node processes (use with caution)
pkill -9 node
```

## Development Workflow

1. **Start Development**
   ```bash
   ./dev.sh start
   ```

2. **Make Code Changes**
   - Frontend: Changes hot-reload automatically
   - Server: Nodemon restarts automatically
   - Collector: Nodemon restarts automatically

3. **Check Service Status**
   ```bash
   ./dev.sh status
   ```

4. **View Logs**
   ```bash
   ./dev.sh logs
   ```

5. **Stop Development**
   ```bash
   ./dev.sh stop
   ```

## Additional Scripts

### Database Operations
```bash
# Run migrations
cd server
yarn db:migrate

# Seed database
yarn db:seed

# Open Prisma Studio
yarn db:studio
```

### Testing
```bash
# Run tests
cd server
yarn test

cd ../frontend
yarn test
```

### Building
```bash
# Build frontend
cd frontend
yarn build

# Build server
cd server
yarn build
```

## Tips

- Use `./dev.sh status` to quickly check if all services are running
- Logs are continuously written to `logs/` directory for debugging
- The script automatically cleans up stale processes when starting
- All services run in the background, freeing up your terminal
