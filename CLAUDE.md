# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Mind.Law is a full-stack application that enables private ChatGPT experiences using commercial or open-source LLMs and vector databases. The application divides documents into isolated `workspaces` which function like threads with containerized document contexts.

## Architecture

This is a **monorepo** with three main applications that run as separate processes:

### 1. **Server** (`server/`)
- **NodeJS Express server** (default port: 3001 in production, 3001 in dev)
- **Main entry**: `server/index.js`
- Handles all LLM interactions, vector database management, and API endpoints
- **Database**: Prisma ORM with SQLite (default) or PostgreSQL
- **Database location**: `server/storage/anythingllm.db` (SQLite)

### 2. **Frontend** (`frontend/`)
- **ViteJS + React** application
- **Dev server**: Port 5173 (vite default)
- Built output goes to `frontend/dist`, then copied to `server/public` for production
- **i18n support**: 20+ languages in `frontend/src/locales/`

### 3. **Collector** (`collector/`)
- **NodeJS Express server** (default port: 8888)
- **Main entry**: `collector/index.js`
- Processes and parses documents from the UI (PDF, DOCX, TXT, etc.)
- Uses **Puppeteer** for web scraping, **Tesseract** for OCR
- Output stored in `server/storage/documents/` as JSON files

## Development Commands

### Initial Setup
```bash
# From repository root
yarn setup                    # Install all dependencies and create .env files
yarn setup:envs              # Copy .env.example files only
yarn prisma:setup            # Generate Prisma client, migrate, and seed database
```

**Important**: After `yarn setup`, fill out the `.env` files before proceeding:
- `server/.env.development` - Server configuration (required)
- `frontend/.env` - Frontend API base URL
- `collector/.env` - Collector configuration

### Development Workflow
```bash
# Start all services (recommended - uses concurrently)
yarn dev:all

# OR start each service in separate terminals:
yarn dev:server              # Start server with nodemon (auto-restart)
yarn dev:frontend            # Start Vite dev server with HMR
yarn dev:collector           # Start collector with nodemon
```

### Database Management
```bash
yarn prisma:generate         # Generate Prisma Client from schema
yarn prisma:migrate          # Create and apply new migration
yarn prisma:seed             # Seed database with initial data
yarn prisma:reset            # Reset database (truncate + migrate)
```

**Schema location**: `server/prisma/schema.prisma`

### Testing & Linting
```bash
yarn test                    # Run Jest tests (root level)
yarn lint                    # Lint all three projects (server, frontend, collector)

# Individual project linting:
cd server && yarn lint       # ESLint + Prettier on server
cd frontend && yarn lint     # ESLint + Prettier on frontend
cd collector && yarn lint    # ESLint + Prettier on collector
```

### Production Build
```bash
yarn prod:frontend           # Build frontend to frontend/dist
yarn prod:server             # Start server in production mode

# Manual production deployment:
cd frontend && yarn build                    # Build frontend
cp -R frontend/dist server/public            # Copy build to server
cd server && NODE_ENV=production node index.js &
cd collector && NODE_ENV=production node index.js &
```

### Translation Management
```bash
yarn verify:translations     # Verify translation files are complete
yarn normalize:translations  # Normalize English translation keys
```

## Key Architecture Patterns

### Server Architecture

**Endpoint Organization** (`server/endpoints/`):
- Each endpoint file exports a function that attaches routes to the Express router
- Pattern: `module.exports.nameEndpoints = function (app) { ... }`
- Main endpoints: `system`, `workspaces`, `chat`, `admin`, `embed`, `api`, `agentWebsocket`

**Models** (`server/models/`):
- Prisma-based models wrapping database operations
- Each model file exports methods for CRUD operations
- Pattern: `static async get(clause = {})`, `static async create(data)`, etc.

**Utils** (`server/utils/`):
- `AiProviders/` - LLM provider integrations (OpenAI, Anthropic, Ollama, etc.)
- `EmbeddingEngines/` - Embedding model providers
- `vectorDbProviders/` - Vector database integrations (LanceDB, Pinecone, Chroma, etc.)
- `agents/` - AI agent system for web browsing and tool use
- `agentFlows/` - No-code agent workflow builder
- `MCP/` - Model Context Protocol integration
- `chats/` - Chat handling and streaming logic

**WebSocket Support**:
- Agent invocations use WebSocket for real-time communication
- Endpoint: `/api/agent-invocation/:uuid` (uses `@mintplex-labs/express-ws`)

### Database Schema (Prisma)

**Core Tables**:
- `workspaces` - Chat workspace containers
- `workspace_documents` - Documents linked to workspaces
- `workspace_chats` - Chat message history
- `workspace_threads` - Conversation threads within workspaces
- `users` - User accounts with role-based permissions
- `embed_configs` - Embeddable chat widget configurations

**Key Relationships**:
- Workspaces contain documents, threads, and chats
- Users can have workspace-specific access via `workspace_users`
- All user data uses cascading deletes (`onDelete: Cascade`)

**Database Switching**:
- Default: SQLite (`file:../storage/anythingllm.db`)
- Optional: PostgreSQL (uncomment datasource in `schema.prisma`, set `DATABASE_URL`)

### Frontend Architecture

**Routing**: React Router v6 with path-based routing
- Main entry: `frontend/src/App.jsx`
- Pages: `frontend/src/pages/` (WorkspaceChat, Admin, GeneralSettings, etc.)

**State Management**:
- Context API for global state (no Redux)
- Local component state with hooks

**UI Components**:
- Component library in `frontend/src/components/`
- Uses Tailwind CSS for styling
- Icons from `@phosphor-icons/react`

**API Communication**:
- Fetch-based API client in `frontend/src/utils/`
- Base URL configured via `VITE_API_BASE` env variable
- Streaming responses using `@microsoft/fetch-event-source`

### Document Processing Flow

1. **Upload**: Files uploaded via frontend → sent to collector
2. **Processing**: Collector parses files → extracts text → chunks content
3. **Storage**: Processed documents saved as JSON in `server/storage/documents/`
4. **Vectorization**: Server reads JSON → embeds chunks → stores in vector DB
5. **Retrieval**: Chat queries → vector search → context injection → LLM response

**JSON Format** (in `server/storage/documents/`):
- Required key: `pageContent` (the actual text content)
- All other keys become metadata
- Reserved key: `published` (timestamp)

## Important Environment Variables

### Server (`server/.env.development`)
- `STORAGE_DIR` - Absolute path to `server/storage` (required)
- `SERVER_PORT` - Server port (default: 3001)
- `JWT_SECRET` - Session token secret
- `DISABLE_TELEMETRY` - Set to "true" to disable telemetry
- `VECTOR_DB` - Vector database provider (lancedb, pinecone, chroma, etc.)
- `LLM_PROVIDER` - LLM provider (openai, anthropic, ollama, etc.)
- Database connection strings for chosen providers

### Frontend (`frontend/.env`)
- `VITE_API_BASE` - API base URL:
  - Development: `http://localhost:3001/api`
  - Production: `/api` (relative path)

### Collector (`collector/.env`)
- `SERVER_PORT` - Collector port (default: 8888)
- `STORAGE_DIR` - Absolute path to `collector/storage`

## MCP (Model Context Protocol) Integration

Mind.Law has **full MCP compatibility** for extending LLM capabilities with external tools and data sources.

**MCP Configuration**:
- Server-side integration in `server/utils/MCP/`
- Endpoints in `server/endpoints/mcpServers.js`
- MCP servers can be configured via the admin panel

## Multi-User & Permissions

**User Roles** (in `users.role` field):
- `admin` - Full system access
- `manager` - Can create workspaces and manage users
- `default` - Basic user access to assigned workspaces

**Workspace Access**:
- Junction table: `workspace_users` links users to workspaces
- Users can only see/access workspaces they're assigned to (unless admin)

**Embedded Chat Widgets**:
- Docker-only feature for multi-user instances
- Each workspace can have a public embed config
- Widget repo: https://github.com/Mintplex-Labs/anythingllm-embed

## Testing

Run individual tests by file:
```bash
cd server && npx jest path/to/test.spec.js
cd frontend && npm test -- path/to/test.spec.js
```

## Common Development Tasks

### Adding a New LLM Provider
1. Create provider class in `server/utils/AiProviders/[provider]/`
2. Implement required methods: `streamChat()`, `getChatCompletion()`, `embedTextInput()`
3. Register in LLM provider selection UI (frontend)
4. Add provider-specific env variables to `.env.example`

### Adding a New Vector Database
1. Create provider class in `server/utils/vectorDbProviders/[provider]/`
2. Implement required methods: `connect()`, `addDocumentToNamespace()`, `similarityResponse()`
3. Add setup documentation in provider folder (e.g., `SETUP.md`)
4. Register in vector DB selection UI

### Creating a New Endpoint
1. Create file in `server/endpoints/[endpoint].js`
2. Export function: `module.exports.nameEndpoints = function(app) { ... }`
3. Register in `server/index.js` by calling the exported function
4. Add authentication middleware if needed (from `server/utils/middleware/`)

### Database Schema Changes
1. Edit `server/prisma/schema.prisma`
2. Run `yarn prisma:migrate` to create migration
3. Migration files generated in `server/prisma/migrations/`
4. Commit both schema and migration files

## WebSocket & Streaming

**Agent Invocations**: Real-time agent communication via WebSocket
- Endpoint pattern: `ws://localhost:3001/api/agent-invocation/:uuid`
- Handles streaming responses from agents during tool use

**Chat Streaming**: HTTP streaming for LLM responses
- Uses Server-Sent Events (SSE) via `@microsoft/fetch-event-source`
- Nginx config requires `proxy_buffering off` for streaming

## Production Deployment Notes

- **Bare metal guide**: See `BARE_METAL.md` in root
- **Docker**: See `docker/HOW_TO_USE_DOCKER.md`
- **Cloud deployments**: Templates in `cloud-deployments/` (AWS, GCP, DigitalOcean, Railway, etc.)
- **Build order**: Frontend → copy to server/public → start server → start collector
- **Process management**: Use PM2 or systemd for process supervision

## Telemetry & Privacy

Mind.Law collects anonymous usage telemetry via PostHog (event-only, no content):
- Installation type (Docker/Desktop)
- Document add/remove events
- Vector DB and LLM provider types
- Chat send events (not chat content)

**Disable telemetry**: Set `DISABLE_TELEMETRY=true` in server env or via UI (sidebar → Privacy)

## Known File Locations

- **Database**: `server/storage/anythingllm.db` (SQLite)
- **Documents cache**: `server/storage/documents/`
- **Vector cache**: `server/storage/vector-cache/`
- **Collector hot directory**: `collector/hotdir/`
- **User uploads**: Processed through collector, then stored as JSON
- **Frontend build**: `frontend/dist/` → copied to `server/public/`

## Browser Extension & Mobile App

- **Chrome extension**: Separate repo (submodule in `browser-extension/`)
- **Desktop apps**: Available for Mac, Windows, Linux (see README for download links)
- **Mobile connection**: Desktop ↔ Mobile device pairing via `desktop_mobile_devices` table
