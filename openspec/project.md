# Project Context

## Purpose
Mind.Law is a full-stack application that enables **private ChatGPT experiences** using commercial or open-source LLMs and vector databases. The application divides documents into isolated `workspaces` which function like threads with containerized document contexts.

**Key Goals:**
- Provide privacy-first AI chat experiences with local or self-hosted options
- Support multi-user environments with role-based permissions
- Enable document-aware conversations using RAG (Retrieval Augmented Generation)
- Offer flexibility across LLM providers (OpenAI, Anthropic, Ollama, etc.)
- Support multiple vector database backends (LanceDB, Pinecone, Chroma, etc.)

## Tech Stack

### Backend (Server - Port 3001)
- **Runtime**: Node.js with Express
- **Database**: Prisma ORM with SQLite (default) or PostgreSQL
- **WebSocket**: `@mintplex-labs/express-ws` for real-time agent communication
- **Authentication**: JWT-based session tokens
- **File Processing**: Node.js file system operations

### Frontend (Port 5173 in dev)
- **Framework**: React 18 with ViteJS
- **Routing**: React Router v6
- **State Management**: React Context API (no Redux)
- **Styling**: Tailwind CSS
- **Icons**: `@phosphor-icons/react`
- **API Client**: Fetch API with `@microsoft/fetch-event-source` for streaming
- **i18n**: 20+ language support in `frontend/src/locales/`

### Collector Service (Port 8888)
- **Runtime**: Node.js with Express
- **Document Parsing**:
  - PDF: `pdf-parse`
  - DOCX: Custom parsers
  - Web Scraping: Puppeteer
  - OCR: Tesseract
- **Output**: JSON files in `server/storage/documents/`

### Key Libraries & Tools
- **Prisma**: Database ORM and migrations
- **Yarn Workspaces**: Monorepo management
- **Concurrently**: Multi-service development
- **Nodemon**: Hot-reloading in development
- **Jest**: Testing framework
- **ESLint + Prettier**: Code linting and formatting

## Project Conventions

### Code Style
- **Linting**: ESLint + Prettier enforced across all three projects
- **Commands**:
  - `yarn lint` (root) - Lint all projects
  - Individual: `cd [project] && yarn lint`
- **Formatting**: Prettier auto-format on save recommended
- **Naming Conventions**:
  - **Components**: PascalCase (e.g., `WorkspaceChat.jsx`)
  - **Files**: camelCase for utilities, PascalCase for components
  - **API Endpoints**: kebab-case routes (e.g., `/api/workspace-documents`)
  - **Database**: snake_case table/column names (e.g., `workspace_chats`)

### Architecture Patterns

#### Monorepo Structure
```
mind.law-platform/
├── server/          # Backend API & database (port 3001)
├── frontend/        # React UI (port 5173 dev, served by server in prod)
├── collector/       # Document processor (port 8888)
└── [shared config]  # Root-level package.json, yarn workspaces
```

#### Server Architecture
- **Endpoint Pattern**: Each endpoint file exports a function:
  ```javascript
  module.exports.nameEndpoints = function (app) {
    app.get('/api/path', handler);
  }
  ```
- **Model Pattern**: Prisma-based models in `server/models/`:
  ```javascript
  static async get(clause = {}) { ... }
  static async create(data) { ... }
  ```
- **Utility Organization**:
  - `AiProviders/` - LLM integrations (OpenAI, Anthropic, etc.)
  - `EmbeddingEngines/` - Embedding model providers
  - `vectorDbProviders/` - Vector DB integrations
  - `agents/` - AI agent system with tool use
  - `MCP/` - Model Context Protocol integration

#### Frontend Architecture
- **Routing**: Path-based with React Router v6 in `App.jsx`
- **State**: Context API for global state, hooks for local state
- **Component Library**: Reusable components in `frontend/src/components/`
- **API Base**: Configured via `VITE_API_BASE` env variable
  - Dev: `http://localhost:3001/api`
  - Prod: `/api` (relative)

#### Document Processing Flow
1. **Upload** → Frontend sends to Collector (port 8888)
2. **Processing** → Collector parses/chunks/extracts text
3. **Storage** → JSON saved to `server/storage/documents/`
4. **Vectorization** → Server embeds chunks → stores in vector DB
5. **Retrieval** → Chat queries → vector search → context → LLM response

**JSON Format**:
```json
{
  "pageContent": "The actual text content",
  "published": "2024-01-01T00:00:00Z",
  "otherKey": "becomes metadata"
}
```

### Testing Strategy
- **Framework**: Jest for unit/integration tests
- **Command**: `yarn test` from root
- **Individual Tests**: `npx jest path/to/test.spec.js`
- **Coverage**: Tests exist but coverage not enforced (open-source project)
- **Testing Focus**:
  - Model CRUD operations
  - API endpoint logic
  - Document processing pipelines
  - Vector database interactions

### Git Workflow
- **Default Branch**: `master`
- **Commit Conventions**: Not strictly enforced, but conventional commits encouraged
- **PR Strategy**: Feature branches → PR to master
- **Migration Handling**:
  - Prisma migrations committed to `server/prisma/migrations/`
  - Schema changes require `yarn prisma:migrate`

## Domain Context

### Workspaces
- **Core Concept**: Isolated chat environments with specific document contexts
- **Analogy**: Like ChatGPT threads, but with attached document knowledge
- **Structure**: Each workspace has its own:
  - Document library (`workspace_documents`)
  - Chat history (`workspace_chats`)
  - Thread organization (`workspace_threads`)
  - Vector embeddings in the selected vector DB

### Multi-User & Permissions
**User Roles** (in `users.role`):
- `admin` - Full system access
- `manager` - Can create workspaces and manage users
- `default` - Basic user access to assigned workspaces

**Access Control**:
- Junction table: `workspace_users` links users to workspaces
- Users only see assigned workspaces (unless admin)
- Cascading deletes on user removal

### RAG (Retrieval Augmented Generation)
- Documents are chunked and vectorized on upload
- Chat queries trigger vector similarity search
- Top-K relevant chunks injected as context into LLM prompt
- Responses grounded in uploaded documents

### MCP (Model Context Protocol)
- **Purpose**: Extend LLM capabilities with external tools/data sources
- **Location**: `server/utils/MCP/`
- **Configuration**: Admin panel UI or API endpoints
- **Integration**: Server-side MCP server management

### Embedded Chat Widgets
- **Feature**: Public embeddable chat for workspaces
- **Availability**: Docker deployments only (multi-user instances)
- **Repo**: https://github.com/Mintplex-Labs/anythingllm-embed
- **Table**: `embed_configs` stores widget settings

## Important Constraints

### Technical Constraints
- **Database Default**: SQLite in `server/storage/anythingllm.db`
  - PostgreSQL optional (requires schema datasource change + `DATABASE_URL`)
- **Storage Paths**: Must be absolute paths in `.env` files
  - `STORAGE_DIR` for server and collector
- **WebSocket Requirement**: Nginx/reverse proxy must disable buffering for streaming:
  ```nginx
  proxy_buffering off;
  ```
- **Agent Streaming**: Real-time agent responses require WebSocket support

### Privacy & Telemetry
- **Anonymous Telemetry**: PostHog event tracking (installation type, document events, provider types)
- **No Content Tracking**: Chat messages and document content never sent
- **Disable Option**: `DISABLE_TELEMETRY=true` in server env or via UI (sidebar → Privacy)

### Multi-Tenancy
- **User Isolation**: Users cannot access other users' workspaces unless explicitly assigned
- **Admin Override**: Admins have global access to all workspaces
- **Workspace Assignment**: Managed via `workspace_users` junction table

### Document Processing
- **Supported Formats**: PDF, DOCX, TXT, web pages, and more
- **Processing Pipeline**: Collector service (port 8888) must be running
- **Output Location**: `server/storage/documents/` (JSON format)
- **Reserved Keys**: `pageContent` (required), `published` (timestamp)

## External Dependencies

### LLM Providers (Configurable)
- OpenAI (GPT-3.5, GPT-4, GPT-4 Turbo)
- Anthropic (Claude 2, Claude 3)
- Ollama (local open-source models)
- Azure OpenAI
- Google Gemini
- Groq
- And 20+ more providers

**Configuration**: Via `LLM_PROVIDER` env variable + provider-specific API keys

### Vector Databases (Configurable)
- **LanceDB** (default, local file-based)
- Pinecone (cloud)
- Chroma (local or cloud)
- Weaviate
- Qdrant
- Milvus
- And 10+ more providers

**Configuration**: Via `VECTOR_DB` env variable + provider-specific connection strings

### Embedding Engines
- OpenAI embeddings (text-embedding-ada-002)
- Azure OpenAI embeddings
- Ollama embeddings (local)
- Anthropic embeddings
- Cloud providers (Cohere, etc.)

### External Services (Optional)
- **PostHog**: Telemetry (can be disabled)
- **Puppeteer**: Web scraping in collector (requires Chrome/Chromium)
- **Tesseract**: OCR for image-based documents

### Deployment Platforms
**Supported cloud templates** in `cloud-deployments/`:
- AWS (EC2, ECS)
- GCP (Cloud Run, Compute Engine)
- DigitalOcean (Droplets, App Platform)
- Railway
- Render
- Heroku

**Docker**: Full Docker/Docker Compose support (see `docker/HOW_TO_USE_DOCKER.md`)

### Browser Extension & Desktop Apps
- **Chrome Extension**: Separate repo (submodule in `browser-extension/`)
- **Desktop Apps**: Electron-based for Mac, Windows, Linux
- **Mobile Pairing**: Via `desktop_mobile_devices` table for Desktop ↔ Mobile sync
