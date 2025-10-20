# Design: Legal Platform Transformation Architecture

**Change ID**: `transform-legal-platform`
**Last Updated**: 2025-10-20

## Overview

This document outlines the architectural approach for transforming Mind.Law into a legal professional platform with Harvey AI-like capabilities while maintaining the existing flexible LLM/vector database architecture.

## Architectural Principles

### 1. **Legal-First, General-Purpose Second**
- Legal features are primary, prominently displayed
- General-purpose features remain available in "Advanced" or "Developer" mode
- UI/UX defaults to legal professional workflows

### 2. **Backward Compatibility**
- Existing workspaces continue to function
- Current RAG system remains operational
- No breaking changes to API endpoints
- Gradual migration path for existing users

### 3. **Modular Legal Components**
- Legal features implemented as pluggable modules
- Can be enabled/disabled per installation
- Allows white-label and industry-specific variants

### 4. **Data Security & Compliance**
- Attorney-client privilege safeguards
- Enhanced encryption for legal documents
- Audit trail for all document access
- SOC2 Type II, GDPR, CCPA compliance paths

## System Architecture

###

 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend (React + Vite)                   │
│                                                               │
│  ┌────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │ Legal Workspace│  │ Legal Knowledge │  │   Workflows   │ │
│  │   Interface    │  │   Research UI   │  │    Builder    │ │
│  └────────────────┘  └─────────────────┘  └──────────────┘ │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │         Legal UI Components & Terminology               │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Server (Node.js + Express)                │
│                                                               │
│  ┌────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │ Legal Assistant│  │ Legal Research  │  │   Workflow    │ │
│  │     Engine     │  │    Service      │  │    Engine     │ │
│  └────────────────┘  └─────────────────┘  └──────────────┘ │
│                                                               │
│  ┌────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   Citation     │  │  Legal Template │  │   Audit Log   │ │
│  │    Manager     │  │     Library     │  │    Service    │ │
│  └────────────────┘  └─────────────────┘  └──────────────┘ │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │          Existing: RAG, Vector DB, LLM Providers        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                           │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────┐ │
│  │   Prisma DB  │  │  Vector DB   │  │  Legal Research   │ │
│  │  (SQLite/PG) │  │  (LanceDB)   │  │   API (External)  │ │
│  └──────────────┘  └──────────────┘  └───────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Component Design Decisions

### 1. Legal Assistant Engine

**Decision**: Enhance existing workspace chat with legal context layer

**Rationale**:
- Leverages existing RAG infrastructure
- Adds legal terminology dictionary and prompting strategies
- Minimal disruption to current architecture

**Implementation**:
```javascript
// server/utils/agents/LegalAssistant/
class LegalAssistant {
  constructor(workspace, legalContext) {
    this.workspace = workspace;
    this.legalContext = legalContext; // jurisdiction, practice area, etc.
    this.terminologyDict = new LegalTerminologyDictionary();
    this.templateLibrary = new LegalTemplateLibrary();
  }

  async enhancePrompt(userQuery) {
    // Add legal context to system prompt
    // Inject relevant legal terminology
    // Apply legal-specific formatting
  }

  async analyzeResponse(llmResponse) {
    // Verify citations
    // Flag potential legal issues
    // Format according to legal standards
  }
}
```

**Trade-offs**:
- ✅ Fast to implement, reuses existing code
- ✅ No LLM fine-tuning required initially
- ⚠️ Limited compared to truly fine-tuned legal models
- ⚠️ Citation accuracy depends on LLM capabilities

### 2. Legal Knowledge Research

**Decision**: Integrate external legal research APIs + local RAG

**Rationale**:
- Legal case law databases are specialized and constantly updated
- External APIs (Casetext, Fastcase, CourtListener) provide authoritative sources
- Local RAG handles firm-specific documents and precedents

**Implementation**:
```javascript
// server/utils/LegalResearch/
class LegalResearchService {
  constructor() {
    this.externalAPIs = [
      new CasetextAPI(),
      new CourtListenerAPI(),
      new FastcaseAPI()
    ];
    this.citationManager = new CitationManager();
    this.localRAG = new LocalDocumentRAG();
  }

  async research(query, jurisdiction, dateRange) {
    // 1. Search external legal databases
    const externalResults = await this.searchExternalSources(query, jurisdiction);

    // 2. Search local documents (firm precedents)
    const localResults = await this.localRAG.search(query);

    // 3. Merge and rank results
    const rankedResults = this.rankByRelevance([...externalResults, ...localResults]);

    // 4. Generate citations
    return this.citationManager.formatResults(rankedResults);
  }
}
```

**Trade-offs**:
- ✅ Access to authoritative legal sources
- ✅ Always up-to-date case law
- ⚠️ API costs for external research
- ⚠️ Requires API key management and rate limiting

### 3. Legal Workflows Engine

**Decision**: Build workflow system on top of existing agent infrastructure

**Rationale**:
- Mind.Law already has agent system with tool use
- Workflows are essentially structured agent tasks with predefined steps
- Reuse existing WebSocket streaming for workflow progress

**Implementation**:
```javascript
// server/utils/workflows/LegalWorkflowEngine.js
class LegalWorkflowEngine {
  constructor(workspace) {
    this.workspace = workspace;
    this.workflows = new WorkflowLibrary();
    this.stepExecutor = new WorkflowStepExecutor();
  }

  async executeWorkflow(workflowId, inputs) {
    const workflow = this.workflows.get(workflowId);
    const context = { workspace: this.workspace, inputs };

    for (const step of workflow.steps) {
      // Stream progress to frontend via WebSocket
      await this.stepExecutor.execute(step, context);

      // Check for user intervention points
      if (step.requiresReview) {
        await this.waitForUserApproval(step.output);
      }
    }

    return workflow.generateFinalOutput(context);
  }
}

// Pre-built workflows
const CONTRACT_REVIEW_WORKFLOW = {
  id: 'contract-review',
  steps: [
    { name: 'extract-parties', tool: 'legal-parser' },
    { name: 'identify-terms', tool: 'legal-analyzer' },
    { name: 'check-compliance', tool: 'compliance-checker' },
    { name: 'flag-risks', tool: 'risk-assessor' },
    { name: 'generate-summary', tool: 'legal-summarizer', requiresReview: true }
  ]
};
```

**Trade-offs**:
- ✅ Leverages existing agent infrastructure
- ✅ Flexible and extensible
- ✅ Real-time progress updates
- ⚠️ Complex workflows may be slow
- ⚠️ Requires careful error handling and rollback

### 4. Legal UI/UX Transformation

**Decision**: Redesign UI with legal-specific terminology and workflows, maintain responsive framework

**Rationale**:
- Legal professionals expect familiar terminology (matters, cases, briefs)
- Document-centric workflows are primary
- Need to maintain existing Tailwind CSS and React architecture

**Implementation Changes**:

**Terminology Mapping**:
- "Workspaces" → "Matters" or "Cases"
- "Documents" → "Pleadings", "Contracts", "Briefs"
- "Chats" → "Legal Consultations" or "Research Sessions"
- "Threads" → "Case Threads" or "Matter Discussions"

**UI Component Structure**:
```
frontend/src/
├── components/
│   ├── LegalWorkspace/  (renamed from Workspace)
│   │   ├── MatterCard.jsx
│   │   ├── CaseOverview.jsx
│   │   └── DocumentLibrary.jsx
│   ├── LegalResearch/
│   │   ├── ResearchInterface.jsx
│   │   ├── CitationManager.jsx
│   │   └── JurisdictionSelector.jsx
│   ├── LegalWorkflows/
│   │   ├── WorkflowBuilder.jsx
│   │   ├── WorkflowLibrary.jsx
│   │   └── WorkflowExecutor.jsx
│   └── LegalSidebar/  (enhanced Sidebar)
│       ├── MatterList.jsx
│       └── QuickActions.jsx
├── pages/
│   ├── MatterWorkspace/  (renamed from WorkspaceChat)
│   ├── LegalResearch/
│   └── WorkflowManagement/
```

**Trade-offs**:
- ✅ Familiar to legal professionals
- ✅ Document-centric approach matches legal workflows
- ⚠️ Learning curve for existing users
- ⚠️ Requires comprehensive UI refactoring

## Database Schema Changes

### New Tables

```prisma
// Legal-specific extensions to existing schema

model legal_matters {
  id               Int      @id @default(autoincrement())
  workspace_id     Int      @unique
  matter_number    String?  // Law firm matter number
  client_name      String?
  practice_area    String?  // Litigation, Corporate, IP, etc.
  jurisdiction     String?  // US Federal, CA State, etc.
  opposing_counsel String?
  court            String?
  case_number      String?
  status           String   @default("active")
  created_at       DateTime @default(now())
  updated_at       DateTime @default(now())

  workspace        workspaces @relation(fields: [workspace_id], references: [id], onDelete: Cascade)
}

model legal_templates {
  id              Int      @id @default(autoincrement())
  name            String
  category        String   // Contract, Brief, Memo, Pleading
  jurisdiction    String?
  template_text   String   @db.Text
  variables       Json     // Template variables for customization
  created_by      Int?
  created_at      DateTime @default(now())
  updated_at      DateTime @default(now())

  user            users?   @relation(fields: [created_by], references: [id], onDelete: SetNull)
}

model legal_workflows {
  id               Int      @id @default(autoincrement())
  name             String
  description      String?  @db.Text
  workflow_type    String   // contract-review, due-diligence, compliance, custom
  steps            Json     // Workflow step definitions
  is_public        Boolean  @default(false)
  created_by       Int?
  workspace_id     Int?
  created_at       DateTime @default(now())
  updated_at       DateTime @default(now())

  user             users?      @relation(fields: [created_by], references: [id], onDelete: SetNull)
  workspace        workspaces? @relation(fields: [workspace_id], references: [id], onDelete: Cascade)
}

model legal_research_cache {
  id               Int      @id @default(autoincrement())
  query            String   @db.Text
  jurisdiction     String
  results          Json     // Cached research results with citations
  source           String   // casetext, courtlistener, fastcase
  expires_at       DateTime
  created_at       DateTime @default(now())
}

model legal_citations {
  id               Int      @id @default(autoincrement())
  workspace_chat_id Int
  citation_text    String   @db.Text
  citation_format  String   // bluebook, apa, mla
  source_url       String?
  verified         Boolean  @default(false)
  created_at       DateTime @default(now())

  chat             workspace_chats @relation(fields: [workspace_chat_id], references: [id], onDelete: Cascade)
}

model legal_audit_log {
  id               Int      @id @default(autoincrement())
  user_id          Int
  workspace_id     Int?
  action           String   // access, modify, delete, export
  resource_type    String   // document, chat, matter
  resource_id      Int?
  details          Json?
  ip_address       String?
  created_at       DateTime @default(now())

  user             users      @relation(fields: [user_id], references: [id], onDelete: Cascade)
  workspace        workspaces? @relation(fields: [workspace_id], references: [id], onDelete: SetNull)
}
```

## Security & Compliance Design

### Attorney-Client Privilege Protection

1. **Data Segregation**:
   - Legal matters stored separately from general workspaces
   - Enhanced encryption for legal document storage
   - Separate backup procedures for legal data

2. **Access Control**:
   - Role-based access (attorney, paralegal, staff, client)
   - Matter-level permissions
   - Audit trail for all document access

3. **Data Retention**:
   - Configurable retention policies
   - Secure deletion with verification
   - Export capabilities for matter closure

### Compliance Framework

```javascript
// server/utils/compliance/LegalComplianceManager.js
class LegalComplianceManager {
  constructor() {
    this.regulations = [
      new SOC2TypeII(),
      new GDPR(),
      new CCPA(),
      new AttorneyClientPrivilege()
    ];
  }

  async validateAction(user, action, resource) {
    // Check all compliance requirements
    for (const regulation of this.regulations) {
      const result = await regulation.validate(user, action, resource);
      if (!result.allowed) {
        return { allowed: false, reason: result.reason };
      }
    }

    // Log action for audit trail
    await this.auditLog.record(user, action, resource);

    return { allowed: true };
  }
}
```

## Performance Considerations

### Legal Research Caching

- Cache legal research results for 24 hours (case law doesn't change frequently)
- Jurisdiction-specific cache keys
- Invalidation on explicit user request

### Workflow Optimization

- Parallel execution of independent workflow steps
- Streaming results as they become available
- Background processing for long-running workflows

### UI Responsiveness

- Lazy loading for document libraries
- Virtualized lists for large case/matter lists
- Progressive enhancement for legal research results

## Migration Strategy

### Phase 1: Additive Changes (Weeks 1-4)
- Add new legal database tables
- Implement legal assistant engine alongside existing chat
- Build legal UI components without removing existing ones
- Deploy behind feature flag

### Phase 2: UI Transformation (Weeks 5-8)
- Gradual UI terminology changes
- Legal-specific navigation and layouts
- Maintain "Classic Mode" toggle for existing users

### Phase 3: Feature Completion (Weeks 9-12)
- Complete legal research integration
- Launch workflow engine
- Full legal template library
- Beta testing with legal professionals

### Phase 4: Production Rollout (Weeks 13-16)
- Migrate existing workspaces to "matters"
- Remove feature flags
- Full production deployment
- Marketing launch as legal platform

## Rollback Plan

- Feature flags allow instant disable of legal features
- Database migrations are reversible
- UI maintains fallback to general-purpose mode
- Export capabilities for users who want to migrate away

## Open Questions

1. **Legal Research API Selection**: Which legal research API provider(s) to integrate first?
   - Options: Casetext, Fastcase, CourtListener (free but limited)

2. **Fine-Tuning vs. RAG**: When to implement LLM fine-tuning on proprietary documents?
   - Phase 1: RAG only
   - Phase 2: Optional fine-tuning for enterprise customers

3. **Multi-Jurisdiction Support**: Which jurisdictions to support initially?
   - Phase 1: US Federal + Top 5 states (CA, NY, TX, FL, IL)
   - Phase 2: Expand to all US states
   - Phase 3: International (UK, Canada, EU)

4. **Template Library Source**: Build from scratch or license existing legal templates?
   - Option A: Partner with legal template provider
   - Option B: Crowdsource from user community
   - Option C: Hire legal professionals to create library

## References

- Harvey AI Platform: https://www.harvey.ai/
- Harvey Features Analysis: https://www.msba.org/site/site/content/News-and-Publications/News/General-News/An_Overview_of_Harvey_AIs_Features_for_Lawyers.aspx
- Mind.Law Current Architecture: `/Users/tald/Projects/mind.law-platform/openspec/project.md`
