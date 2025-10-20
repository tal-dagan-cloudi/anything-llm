#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# PID file location
PID_FILE=".dev-pids"

# Function to start all services
start_services() {
    echo -e "${BLUE}Starting Mind.Law development services...${NC}"

    # Check if services are already running
    if [ -f "$PID_FILE" ]; then
        echo -e "${YELLOW}Services may already be running. Use './dev.sh stop' first.${NC}"
        read -p "Do you want to stop and restart? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            stop_services
        else
            exit 1
        fi
    fi

    # Clean up any stale processes
    cleanup_stale_processes

    # Start Frontend (port 3000)
    echo -e "${GREEN}Starting Frontend on port 3000...${NC}"
    cd frontend
    yarn dev > ../logs/frontend.log 2>&1 &
    FRONTEND_PID=$!
    cd ..

    # Start Server (port 3001)
    echo -e "${GREEN}Starting Server on port 3001...${NC}"
    cd server
    yarn dev > ../logs/server.log 2>&1 &
    SERVER_PID=$!
    cd ..

    # Start Collector (port 8888)
    echo -e "${GREEN}Starting Collector on port 8888...${NC}"
    cd collector
    yarn dev > ../logs/collector.log 2>&1 &
    COLLECTOR_PID=$!
    cd ..

    # Save PIDs to file
    echo "$FRONTEND_PID" > "$PID_FILE"
    echo "$SERVER_PID" >> "$PID_FILE"
    echo "$COLLECTOR_PID" >> "$PID_FILE"

    echo -e "${GREEN}✓ All services started successfully!${NC}"
    echo ""
    echo -e "${BLUE}Service URLs:${NC}"
    echo -e "  Frontend:  ${GREEN}http://localhost:3000${NC}"
    echo -e "  Server:    ${GREEN}http://localhost:3001${NC}"
    echo -e "  Collector: ${GREEN}http://localhost:8888${NC}"
    echo ""
    echo -e "${YELLOW}Logs are being written to:${NC}"
    echo -e "  Frontend:  logs/frontend.log"
    echo -e "  Server:    logs/server.log"
    echo -e "  Collector: logs/collector.log"
    echo ""
    echo -e "${BLUE}Commands:${NC}"
    echo -e "  ./dev.sh stop    - Stop all services"
    echo -e "  ./dev.sh restart - Restart all services"
    echo -e "  ./dev.sh status  - Check service status"
    echo -e "  ./dev.sh logs    - Tail all logs"
}

# Function to stop all services
stop_services() {
    echo -e "${BLUE}Stopping Mind.Law development services...${NC}"

    if [ ! -f "$PID_FILE" ]; then
        echo -e "${YELLOW}No running services found.${NC}"
        cleanup_stale_processes
        return
    fi

    # Read PIDs from file
    PIDS=$(cat "$PID_FILE")

    for PID in $PIDS; do
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${GREEN}Stopping process $PID...${NC}"
            kill $PID 2>/dev/null

            # Wait for process to terminate
            for i in {1..10}; do
                if ! ps -p $PID > /dev/null 2>&1; then
                    break
                fi
                sleep 0.5
            done

            # Force kill if still running
            if ps -p $PID > /dev/null 2>&1; then
                echo -e "${YELLOW}Force killing process $PID...${NC}"
                kill -9 $PID 2>/dev/null
            fi
        fi
    done

    # Clean up PID file
    rm -f "$PID_FILE"

    # Additional cleanup
    cleanup_stale_processes

    echo -e "${GREEN}✓ All services stopped successfully!${NC}"
}

# Function to cleanup stale processes
cleanup_stale_processes() {
    # Kill any node processes on our ports
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    lsof -ti:8888 | xargs kill -9 2>/dev/null || true
}

# Function to check service status
check_status() {
    echo -e "${BLUE}Checking service status...${NC}"
    echo ""

    # Check if PID file exists
    if [ ! -f "$PID_FILE" ]; then
        echo -e "${RED}✗ Services not running (no PID file)${NC}"
        echo ""
        check_ports
        return
    fi

    # Read PIDs and check each process
    PIDS=$(cat "$PID_FILE")
    RUNNING=0
    STOPPED=0

    for PID in $PIDS; do
        if ps -p $PID > /dev/null 2>&1; then
            RUNNING=$((RUNNING + 1))
            echo -e "${GREEN}✓ Process $PID is running${NC}"
        else
            STOPPED=$((STOPPED + 1))
            echo -e "${RED}✗ Process $PID is not running${NC}"
        fi
    done

    echo ""
    echo -e "${BLUE}Summary: ${GREEN}$RUNNING running${NC}, ${RED}$STOPPED stopped${NC}"
    echo ""

    check_ports
}

# Function to check ports
check_ports() {
    echo -e "${BLUE}Port status:${NC}"

    if lsof -i:3000 > /dev/null 2>&1; then
        echo -e "  Port 3000 (Frontend):  ${GREEN}✓ In use${NC}"
    else
        echo -e "  Port 3000 (Frontend):  ${RED}✗ Available${NC}"
    fi

    if lsof -i:3001 > /dev/null 2>&1; then
        echo -e "  Port 3001 (Server):    ${GREEN}✓ In use${NC}"
    else
        echo -e "  Port 3001 (Server):    ${RED}✗ Available${NC}"
    fi

    if lsof -i:8888 > /dev/null 2>&1; then
        echo -e "  Port 8888 (Collector): ${GREEN}✓ In use${NC}"
    else
        echo -e "  Port 8888 (Collector): ${RED}✗ Available${NC}"
    fi
}

# Function to tail logs
tail_logs() {
    echo -e "${BLUE}Tailing logs (Ctrl+C to stop)...${NC}"
    echo ""

    if [ ! -d "logs" ]; then
        echo -e "${YELLOW}No logs directory found. Services may not be running.${NC}"
        exit 1
    fi

    # Use multitail if available, otherwise fall back to tail
    if command -v multitail &> /dev/null; then
        multitail -s 3 \
            -l "tail -f logs/frontend.log" \
            -l "tail -f logs/server.log" \
            -l "tail -f logs/collector.log"
    else
        tail -f logs/frontend.log logs/server.log logs/collector.log
    fi
}

# Function to restart services
restart_services() {
    echo -e "${BLUE}Restarting services...${NC}"
    stop_services
    sleep 2
    start_services
}

# Create logs directory if it doesn't exist
mkdir -p logs

# Main command handling
case "${1:-start}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        check_status
        ;;
    logs)
        tail_logs
        ;;
    *)
        echo -e "${BLUE}Mind.Law Development Services Manager${NC}"
        echo ""
        echo "Usage: ./dev.sh [command]"
        echo ""
        echo "Commands:"
        echo "  start    - Start all development services (default)"
        echo "  stop     - Stop all services"
        echo "  restart  - Restart all services"
        echo "  status   - Check service status"
        echo "  logs     - Tail all service logs"
        echo ""
        exit 1
        ;;
esac
