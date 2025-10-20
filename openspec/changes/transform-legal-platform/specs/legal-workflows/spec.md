# Spec Delta: Legal Workflows Capability

**Change ID**: `transform-legal-platform`
**Capability**: `legal-workflows`
**Last Updated**: 2025-10-20

## Overview

This spec defines the Legal Workflows capability that provides pre-built and customizable multi-step legal processes for document analysis, compliance checks, due diligence, and other routine legal tasks.

## ADDED Requirements

### REQ-LW-001: Workflow Engine

**Priority**: High
**Dependencies**: None

The system SHALL provide a workflow execution engine that runs multi-step legal processes with support for branching logic, user review points, and error handling.

**Acceptance Criteria**:
- Workflows defined as JSON with steps and dependencies
- Each step can invoke: LLM analysis, document parsing, external API, user prompt
- Branching logic based on step outcomes
- User review/approval gates between steps
- Progress tracking with real-time status updates (WebSocket)
- Automatic rollback on step failures

#### Scenario: Contract Review Workflow Execution

**Given** a contract review workflow with 5 steps:
1. Extract parties and dates
2. Identify key terms
3. Check compliance with standard clauses
4. Flag risks
5. Generate summary memo (requires user review)

**When** the workflow is launched with a contract PDF
**Then** the system:
- Executes steps 1-4 automatically
- Streams progress updates: "Step 1/5: Extracting parties... ✓"
- Pauses at step 5 with: "Review required before generating memo"
- User reviews flagged risks
- User approves or modifies
- Step 5 executes and generates final memo

**And If** step 3 fails (API error)
**Then** workflow pauses, logs error, and prompts: "Retry step 3 or skip?"

### REQ-LW-002: Pre-Built Workflow Library

**Priority**: High
**Dependencies**: REQ-LW-001

The system SHALL provide at least 10 pre-built workflows for common legal tasks across multiple practice areas.

**Acceptance Criteria**:
- Minimum 10 workflows covering: Contracts, Litigation, Due Diligence, Compliance
- Each workflow includes: description, inputs required, expected outputs, execution time estimate
- Workflows are practice area-tagged and jurisdiction-aware
- Workflows can be customized without affecting the original template
- Public workflow library with user ratings and usage counts

**Pre-Built Workflows (Minimum Set)**:
1. **Contract Review** - Analyze contract terms, risks, compliance
2. **Due Diligence Checklist** - Generate and track diligence items
3. **Discovery Request Generation** - Draft interrogatories and document requests
4. **Compliance Check** - Verify document compliance with regulations
5. **Non-Disclosure Agreement Review** - NDA-specific analysis
6. **Employment Agreement Review** - Employment contract analysis
7. **Lease Agreement Review** - Commercial/residential lease analysis
8. **Motion to Dismiss Preparation** - Generate motion structure and research
9. **Deposition Preparation** - Organize facts and prepare question outlines
10. **Trademark Clearance Search** - Multi-source trademark conflict search

#### Scenario: Launching Pre-Built Due Diligence Workflow

**Given** a workspace for an M&A transaction
**When** the user selects "Due Diligence Checklist" workflow
**Then** the system presents workflow configuration:

**Due Diligence Checklist Workflow**
*Estimated Time: 45-60 minutes*
*Jurisdiction: [Select] → Delaware*
*Transaction Type: [Select] → Asset Purchase*

**Required Inputs**:
- [ ] Upload Letter of Intent (LOI)
- [ ] Upload Target Company Information
- [ ] Industry Sector: [Technology]

**This workflow will**:
1. Extract key transaction terms from LOI
2. Generate customized due diligence checklist (120-150 items)
3. Categorize items by: Corporate, Financial, Legal, IP, Employment, Environmental
4. Assign priority levels and assign owners
5. Create tracking document

[Launch Workflow] [Customize Steps] [Preview Checklist Template]

### REQ-LW-003: Workflow Builder (Custom Workflows)

**Priority**: Medium
**Dependencies**: REQ-LW-001

The system SHALL provide a no-code workflow builder for creating custom legal workflows with drag-and-drop step configuration.

**Acceptance Criteria**:
- Visual workflow builder with drag-and-drop interface
- Step types: Document Analysis, LLM Query, Research, User Input, Conditional Branch, Parallel Execution, API Call
- Each step configurable with: name, inputs, outputs, error handling
- Test mode to run workflow with sample data
- Version control for workflow iterations
- Share custom workflows with workspace or make public

#### Scenario: Building Custom Trademark Clearance Workflow

**Given** a user wants to create a custom trademark clearance workflow
**When** the user opens the Workflow Builder
**Then** the system displays a canvas with a "Start" node
**And** a step library on the left:

**Available Steps**:
- 📄 Document Analysis
- 🤖 AI Analysis
- 🔍 Legal Research
- 👤 User Input
- 🔀 Conditional Branch
- ⚡ Parallel Execution
- 🌐 API Call
- 📧 Send Notification

**When** the user drags "AI Analysis" step onto canvas
**Then** step configuration panel appears:

**AI Analysis Step**
- **Name**: "Analyze Trademark for Distinctiveness"
- **Input**: {{trademark_text}}
- **Prompt**: "Analyze this trademark for distinctiveness under Abercrombie spectrum..."
- **Output Variable**: {{distinctiveness_score}}
- **On Error**: [Skip] [Retry 3x] [Fail Workflow]

[Save Step] [Test with Sample Data]

### REQ-LW-004: Document-Triggered Workflows

**Priority**: Medium
**Dependencies**: REQ-LW-001, REQ-LW-002

The system SHALL automatically suggest and launch workflows when documents matching specific patterns are uploaded.

**Acceptance Criteria**:
- Document type detection (contract, brief, complaint, etc.)
- Automatic workflow suggestion based on document type
- User can accept, decline, or modify suggested workflow
- Workflow pre-populated with document as input
- Rules engine for custom document-to-workflow mappings

#### Scenario: Auto-Suggesting Contract Review Workflow

**Given** a workspace configured for corporate law
**When** a user uploads a file named "Vendor_Services_Agreement_2024.pdf"
**Then** the system:
1. Detects document type: "Contract - Services Agreement"
2. Displays notification:

💡 **Workflow Suggestion**
I detected a Services Agreement. Would you like to run a comprehensive review?

**Recommended Workflow**: Contract Review (Services)
- Extract key terms (parties, term, fees, termination)
- Identify non-standard clauses
- Check indemnification and limitation of liability
- Flag missing provisions (force majeure, confidentiality)

[Run Workflow Now] [Customize First] [Skip]

**When** user clicks "Run Workflow Now"
**Then** workflow launches with PDF pre-loaded as input

### REQ-LW-005: Workflow Collaboration

**Priority**: Medium
**Dependencies**: REQ-LW-001

The system SHALL support multi-user collaboration on workflow execution with task assignments, notifications, and approval chains.

**Acceptance Criteria**:
- Assign workflow steps to specific users
- Email/in-app notifications when step requires user action
- Approval chains (e.g., paralegal completes → attorney reviews → client approves)
- Comments on workflow steps
- Audit log of who completed each step and when

#### Scenario: Multi-User Due Diligence Workflow

**Given** a due diligence workflow with 150 checklist items
**And** workspace has 3 users: Senior Attorney, Associate, Paralegal
**When** the workflow is launched
**Then** the system:
- Assigns items based on categories:
  - Corporate/Governance → Senior Attorney (40 items)
  - Contracts/Commercial → Associate (60 items)
  - Administrative/Compliance → Paralegal (50 items)
- Sends notifications:
  - 📧 "You've been assigned 60 due diligence items in Project Alpha M&A"
- Tracks completion:
  - Paralegal: 45/50 complete (90%)
  - Associate: 50/60 complete (83%)
  - Senior Attorney: 30/40 complete (75%)
  - **Overall**: 125/150 complete (83%)

**When** Paralegal completes all items
**Then** Associate receives notification: "Paralegal completed their section. Please review items P1-P50."

### REQ-LW-006: Workflow Templates with Variables

**Priority**: Medium
**Dependencies**: REQ-LW-001, REQ-LW-002

Workflows SHALL support variable substitution allowing dynamic content based on matter-specific information.

**Acceptance Criteria**:
- Variables defined as {{variable_name}} in workflow steps
- Variable types: Text, Date, Number, Document, User, Jurisdiction
- Variable prompts during workflow launch
- Default values from workspace configuration (client name, jurisdiction, etc.)
- Conditional logic based on variable values

#### Scenario: Contract Review Workflow with Jurisdiction-Specific Compliance

**Given** a contract review workflow with a compliance check step
**And** the step has conditional logic based on {{jurisdiction}} variable
**When** workflow is launched with jurisdiction="California"
**Then** the compliance step:
- Checks for required California clauses (e.g., choice of law, venue)
- Verifies Labor Code compliance for employment terms
- Flags missing CCPA data privacy provisions

**When** the same workflow runs with jurisdiction="New York"
**Then** the compliance step:
- Checks for New York-specific requirements
- Different labor law compliance checks
- Different data privacy requirements (not CCPA)

### REQ-LW-007: Workflow Scheduling and Automation

**Priority**: Low
**Dependencies**: REQ-LW-001

The system SHALL support scheduled and automated workflow execution for routine tasks.

**Acceptance Criteria**:
- Schedule workflows: One-time, Daily, Weekly, Monthly
- Trigger workflows based on events: Document uploaded, Deadline approaching, Matter status change
- Automated workflows run without user intervention
- Results delivered via email or saved to workspace
- Automation log with execution history

#### Scenario: Monthly Compliance Audit Workflow

**Given** a workspace for ongoing compliance monitoring
**When** user schedules "Regulatory Compliance Check" workflow
**Then** configuration options include:

**Schedule Workflow**
- **Frequency**: [Monthly] on the [1st] day
- **Time**: [9:00 AM] [EST]
- **Auto-Run**: ✅ Run automatically without confirmation
- **Notifications**:
  - ✅ Email results to workspace members
  - ✅ Create summary document in workspace
  - ⬜ Notify only if issues found

**And** on the 1st of each month at 9:00 AM
**Then** workflow executes automatically:
1. Reviews all documents uploaded in prior month
2. Checks for compliance with current regulations
3. Flags any new compliance risks
4. Generates summary report
5. Emails report to: senior-partner@lawfirm.com, compliance@lawfirm.com

### REQ-LW-008: Workflow Result Export

**Priority**: Low
**Dependencies**: REQ-LW-001

The system SHALL export workflow results in multiple formats for integration with other tools and client delivery.

**Acceptance Criteria**:
- Export formats: PDF, DOCX, Excel, JSON
- Exports include: workflow summary, all step results, timestamps, user actions
- Branded templates for client-facing exports
- Bulk export for multiple workflow runs
- Export includes source document references and citations

#### Scenario: Exporting Contract Review Results for Client

**Given** a completed contract review workflow
**When** user clicks "Export Results"
**Then** export options appear:

**Export Workflow Results**
- **Format**: [PDF] [DOCX] [Excel] [JSON]
- **Template**: [Standard Report] [Client Executive Summary] [Detailed Analysis]
- **Include**:
  - ✅ Summary of findings
  - ✅ Risk assessment matrix
  - ✅ Recommended changes
  - ✅ Source document excerpts
  - ⬜ Full chat transcript
  - ⬜ Internal notes

[Export] [Preview]

**When** "Client Executive Summary" template is selected
**Then** the PDF includes:
- Cover page with firm branding
- Executive summary (1 page)
- Key findings and recommendations (2-3 pages)
- Risk matrix (visual diagram)
- Appendix with detailed analysis

### REQ-LW-009: Workflow Performance Analytics

**Priority**: Low
**Dependencies**: REQ-LW-001

The system SHALL track workflow performance metrics and provide analytics for optimization.

**Acceptance Criteria**:
- Metrics tracked: execution time, success rate, user satisfaction, cost (LLM API calls)
- Analytics dashboard showing: most used workflows, average completion time, bottleneck steps
- Workflow efficiency recommendations
- Cost analysis per workflow type
- Export analytics reports

#### Scenario: Analyzing Contract Review Workflow Performance

**Given** 50 completed contract review workflows over 2 months
**When** admin views workflow analytics dashboard
**Then** the dashboard displays:

**Contract Review Workflow - Performance**
- **Total Runs**: 50
- **Success Rate**: 94% (47 successful, 3 failed)
- **Avg. Completion Time**: 28 minutes
- **Time Savings**: 4.5 hours per review (vs. manual: 5 hours)
- **Total Time Saved**: 225 hours
- **Cost per Run**: $2.40 (LLM API calls)
- **Total Cost**: $120

**Bottleneck Analysis**:
- Step 4 (Risk Flagging) averages 12 minutes (42% of workflow time)
- Recommendation: Optimize LLM prompt or add caching

**User Satisfaction**: 4.7/5 ⭐⭐⭐⭐⭐

[View Detailed Analytics] [Export Report]

### REQ-LW-010: Workflow Integration with Legal Assistant

**Priority**: Low
**Dependencies**: REQ-LW-001, REQ-LA-001 (Legal Assistant)

Workflows SHALL be seamlessly integrated with the Legal Assistant chat interface for conversational workflow execution.

**Acceptance Criteria**:
- Workflows launchable from chat with natural language command
- Workflow progress updates appear in chat
- User can interact with workflow via chat messages (answer prompts, approve steps)
- Workflow results presented as formatted chat messages
- Ability to modify workflow mid-execution via chat commands

#### Scenario: Conversational Workflow Execution

**Given** a user in a Legal Assistant chat session
**When** user types: "Review this contract for risks"
**And** attaches a contract PDF
**Then** the Legal Assistant responds:

🤖 I can run a comprehensive contract review workflow. This will take about 30 minutes and will:
- Extract key terms and parties
- Identify non-standard or risky clauses
- Check for missing protections
- Generate a risk assessment report

Shall I proceed?

**When** user types: "Yes, do it"
**Then** workflow launches and progress appears in chat:

⚙️ **Contract Review Workflow Running**
✅ Step 1/5: Extracting parties and dates... Complete
✅ Step 2/5: Identifying key terms... Complete
🔄 Step 3/5: Checking compliance... In Progress

**When** workflow reaches review step
**Then** chat message appears:

👤 **Your Review Required**
I've flagged 3 potential risks in the indemnification clause (Section 8).

🚩 Risk 1: Uncapped liability for consequential damages
🚩 Risk 2: No carve-out for gross negligence
🚩 Risk 3: One-sided indemnification favoring vendor

Should I include these in the final report? Type 'yes' to approve or 'modify' to adjust.

**When** user types: "yes"
**Then** workflow completes final step and presents results:

✅ **Contract Review Complete**
I've generated a comprehensive report with 8 findings across 4 risk categories.

[View Full Report] [Export PDF] [Start New Review]

## UI/UX Requirements

### REQ-LW-UI-001: Workflow Library Interface

**Priority**: High

The system SHALL provide a visual workflow library interface accessible from the workspace sidebar.

**Acceptance Criteria**:
- Card-based layout with workflow thumbnails
- Filter by: Practice Area, Complexity, Duration, Rating
- Search workflows by name or tags
- Preview workflow steps before launching
- "Recently Used" and "Recommended" sections

### REQ-LW-UI-002: Workflow Execution Dashboard

**Priority**: High

The system SHALL provide a real-time dashboard showing workflow execution progress.

**Acceptance Criteria**:
- Visual progress bar with step indicators
- Expandable step details showing inputs/outputs
- Live log stream for debugging
- Pause/resume/cancel controls
- Side-by-side view of source documents during execution

### REQ-LW-UI-003: Workflow Builder Canvas

**Priority**: Medium

The Workflow Builder SHALL provide an intuitive drag-and-drop canvas interface.

**Acceptance Criteria**:
- Zoom and pan controls for large workflows
- Visual connectors between steps showing data flow
- Mini-map for navigation in complex workflows
- Copy/paste steps and sub-workflows
- Undo/redo functionality
- Auto-save with version history

## Non-Functional Requirements

### REQ-LW-NFR-001: Workflow Execution Performance

Workflows SHALL execute with minimal latency between steps.

**Target**: < 1 second transition time between steps (excluding LLM processing)

### REQ-LW-NFR-002: Workflow Reliability

Workflows SHALL have >95% success rate with automatic retry and error recovery.

**Implementation**:
- Automatic retry (3x) for transient failures
- Checkpoint system for long-running workflows
- Resume from last successful step after failure

### REQ-LW-NFR-003: Workflow Concurrency

The system SHALL support concurrent execution of multiple workflows per workspace.

**Target**: Up to 10 concurrent workflow executions per workspace without performance degradation

### REQ-LW-NFR-004: Workflow Storage

Workflow execution history SHALL be retained for compliance and audit purposes.

**Retention**: Minimum 7 years for legal matters, configurable per workspace

## Success Metrics

- **Workflow Adoption**: 60% of legal workspaces use at least one workflow per month
- **Time Savings**: Average 50% reduction in time for routine legal tasks (user survey)
- **Workflow Success Rate**: >95% of workflows complete successfully
- **Custom Workflows**: 20% of users create at least one custom workflow
- **User Satisfaction**: 4.5/5 rating for workflow usability and effectiveness

## Out of Scope

- Integration with external workflow tools (Zapier, Make.com) - Future
- Workflow marketplace for buying/selling workflows - Future
- AI-powered workflow generation from natural language - Phase 2
- Workflow debugging IDE with breakpoints - Future
- Mobile workflow execution - Future

## References

- Mind.Law Architecture: `/Users/tald/Projects/mind.law-platform/openspec/project.md`
- Harvey AI Workflows: https://www.harvey.ai/
- Mind.Law Agent System: `server/utils/agents/`
- Transformation Design: `/Users/tald/Projects/mind.law-platform/openspec/changes/transform-legal-platform/design.md`
