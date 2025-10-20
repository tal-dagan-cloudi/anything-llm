# Spec Delta: Legal Assistant Capability

**Change ID**: `transform-legal-platform`
**Capability**: `legal-assistant`
**Last Updated**: 2025-10-20

## Overview

This spec defines the Legal Assistant capability that transforms existing workspace chat functionality into a legal-specific AI assistant with domain expertise, terminology awareness, and legal document template support.

## ADDED Requirements

### REQ-LA-001: Legal Terminology Dictionary

**Priority**: High
**Dependencies**: None

The system SHALL maintain a comprehensive legal terminology dictionary that provides context-aware definitions and usage patterns for legal terms.

**Acceptance Criteria**:
- Dictionary contains at least 500 common legal terms across major practice areas
- Terms include jurisdiction-specific variations (US Federal, State, UK, etc.)
- Each term includes: definition, synonyms, related terms, usage context
- Dictionary is searchable and supports fuzzy matching
- Terms can be dynamically loaded based on workspace practice area

#### Scenario: Contract Lawyer Using Specialized Terms

**Given** a workspace configured for "Corporate Law" practice area
**When** the user types a query containing "force majeure"
**Then** the system recognizes the term and provides enhanced context about its meaning in contract law
**And** suggests related terms like "Act of God", "frustration of purpose"
**And** includes jurisdiction-specific interpretations

### REQ-LA-002: Legal Context Layer

**Priority**: High
**Dependencies**: REQ-LA-001

The system SHALL enhance all chat prompts with legal context based on the workspace configuration (jurisdiction, practice area, matter type).

**Acceptance Criteria**:
- System prompts include jurisdiction-specific legal principles
- Prompts adapt based on practice area (Litigation vs. Corporate vs. IP)
- Context includes relevant procedural rules and standards
- Legal citations are encouraged in responses
- Disclaimers about legal advice are automatically included

#### Scenario: Litigation Matter in California State Court

**Given** a workspace configured for:
- Practice Area: "Litigation"
- Jurisdiction: "California State"
- Matter Type: "Civil Lawsuit"

**When** the user asks "What are the pleading requirements?"
**Then** the system response includes California Code of Civil Procedure requirements
**And** references California-specific rules (e.g., CCP § 425.10)
**And** distinguishes from Federal Rules of Civil Procedure
**And** includes appropriate legal disclaimer

### REQ-LA-003: Legal Document Templates

**Priority**: High
**Dependencies**: None

The system SHALL provide a library of legal document templates organized by category, jurisdiction, and practice area.

**Acceptance Criteria**:
- Template library includes at least 20 common document types
- Categories: Contracts, Briefs, Memos, Pleadings, Motions, Discovery
- Templates support variable substitution (client name, dates, jurisdiction)
- Templates can be customized and saved per workspace or user
- Templates include guidance text and legal citations where applicable

#### Scenario: Generating a Motion to Dismiss

**Given** a workspace for a litigation matter
**When** the user requests "Create a motion to dismiss template"
**Then** the system presents template options:
- "Motion to Dismiss - Federal Court (FRCP 12(b)(6))"
- "Motion to Dismiss - California State Court"
- "Motion to Dismiss - New York State Court"

**And When** the user selects "Federal Court" option
**Then** the system generates a template with:
- Proper caption format
- Standard sections (Introduction, Statement of Facts, Argument, Conclusion)
- Placeholder variables: [PLAINTIFF_NAME], [DEFENDANT_NAME], [CASE_NUMBER]
- Citation placeholders with format guidance
- Notice of motion requirements

### REQ-LA-004: Legal Response Formatting

**Priority**: Medium
**Dependencies**: REQ-LA-001, REQ-LA-002

The system SHALL format responses according to legal writing standards including proper citation formats, section organization, and professional tone.

**Acceptance Criteria**:
- Responses use formal legal writing style
- Citations follow Bluebook, APA, or MLA format (configurable per workspace)
- Long responses are organized with headings and sub-sections
- Legal terms of art are used correctly
- Hedging language is used appropriately ("may", "could", "likely")

#### Scenario: Legal Memo Response with Citations

**Given** a workspace configured for Bluebook citation format
**When** the user asks "Analyze the enforceability of this non-compete clause"
**Then** the system response includes:
- **Issue**: Clear statement of the legal question
- **Short Answer**: Concise conclusion
- **Analysis**: Detailed reasoning with legal principles
- **Conclusion**: Summary with recommendations
- **Citations**: Properly formatted case law references (e.g., *Smith v. Jones*, 123 F.3d 456 (9th Cir. 2020))

### REQ-LA-005: Practice Area Specialization

**Priority**: Medium
**Dependencies**: REQ-LA-001, REQ-LA-002

The system SHALL adapt its behavior and knowledge base based on the selected practice area (Litigation, Corporate, Intellectual Property, Family Law, etc.).

**Acceptance Criteria**:
- At least 6 practice areas supported initially
- Each practice area has specialized terminology and templates
- System prompts include practice area-specific considerations
- Suggested follow-up questions are practice area-aware
- Document templates filtered by practice area

#### Scenario: Switching from Corporate to Litigation Practice Area

**Given** a workspace initially configured for "Corporate Law"
**When** the user changes practice area to "Litigation"
**Then** the system:
- Updates available templates to litigation-focused documents
- Adjusts terminology dictionary to emphasize litigation terms
- Modifies response style to include procedural considerations
- Suggests litigation-specific workflows (e.g., "Draft discovery requests")

### REQ-LA-006: Multi-Jurisdiction Support

**Priority**: Medium
**Dependencies**: REQ-LA-002

The system SHALL support multiple legal jurisdictions with jurisdiction-specific legal principles, procedural rules, and citation formats.

**Acceptance Criteria**:
- Initial support for: US Federal, CA, NY, TX, FL, IL state courts
- Each jurisdiction has specific procedural rules database
- Citation formats adapt to jurisdiction requirements
- Conflict of laws analysis available for multi-jurisdiction matters
- Clear indication when legal principles differ by jurisdiction

#### Scenario: Multi-State Contract Dispute

**Given** a workspace for a contract dispute involving:
- Parties: One in California, one in New York
- Contract: Contains New York choice of law provision

**When** the user asks "What law governs this dispute?"
**Then** the system response:
- Identifies the choice of law provision
- Explains New York law will govern contract interpretation
- Notes California law may still apply to certain tort claims
- Cites relevant choice of law principles
- Flags potential conflicts between CA and NY law

### REQ-LA-007: Legal Risk Flagging

**Priority**: Medium
**Dependencies**: REQ-LA-002, REQ-LA-004

The system SHALL automatically identify and flag potential legal risks, compliance issues, or areas requiring attorney review in its responses.

**Acceptance Criteria**:
- Risk flags appear as highlighted warnings in responses
- Categories: Statute of Limitations, Ethical Issues, Compliance, Privilege
- Each flag includes explanation of the risk
- Flags link to relevant rules or statutes
- User can configure risk sensitivity level (Conservative, Moderate, Aggressive)

#### Scenario: Statute of Limitations Warning

**Given** a workspace for a potential personal injury case
**And** the injury date was 3 years ago
**When** the user asks "Can we file this lawsuit?"
**Then** the system response includes:

🚨 **STATUTE OF LIMITATIONS RISK**
The incident occurred more than 2 years ago. Most personal injury claims in California have a 2-year statute of limitations (CCP § 335.1). This case may be time-barred unless an exception applies (e.g., discovery rule, tolling).

**And** provides:
- Link to CCP § 335.1
- Explanation of potential tolling doctrines
- Recommendation to consult with supervising attorney immediately

### REQ-LA-008: Attorney-Client Privilege Protection

**Priority**: High
**Dependencies**: None

The system SHALL protect attorney-client privileged communications and provide warnings when privilege may be at risk.

**Acceptance Criteria**:
- All workspace chats marked as "Privileged Communication"
- Privilege warnings when:
  - Adding non-attorney users to workspace
  - Sharing or exporting chat content
  - Using external APIs or services
- Audit log tracks all access to privileged communications
- Option to mark specific chats as "Non-Privileged" (e.g., public information research)

#### Scenario: Adding Non-Attorney to Privileged Workspace

**Given** a workspace containing attorney-client privileged communications
**When** a workspace administrator attempts to add a user with role "Paralegal" or "Staff"
**Then** the system displays a warning:

⚠️ **PRIVILEGE WARNING**
You are about to grant access to a workspace containing attorney-client privileged communications. Adding non-attorneys may waive privilege. Ensure this user:
- [ ] Has a legitimate need to know
- [ ] Understands confidentiality obligations
- [ ] Is acting under attorney supervision

Continue adding user? [Yes] [No]

### REQ-LA-009: Legal Workflow Integration

**Priority**: Low
**Dependencies**: REQ-LA-003

The system SHALL suggest and launch appropriate legal workflows based on the conversation context.

**Acceptance Criteria**:
- System detects when a workflow would be helpful
- Presents workflow as a suggestion (not forced)
- User can launch workflow from chat interface
- Workflow results are integrated back into chat
- Workflows are context-aware (practice area, jurisdiction, matter type)

#### Scenario: Contract Review Workflow Suggestion

**Given** a workspace chat about reviewing a vendor contract
**When** the user uploads a PDF contract and asks "What should I look for?"
**Then** the system suggests:

💡 **Workflow Suggestion**
I can run a comprehensive contract review workflow that will:
- Extract key terms (parties, dates, payment terms)
- Identify potential risks and unfavorable clauses
- Check for compliance with your standard provisions
- Generate a summary memo

[Launch Contract Review Workflow] [Continue Manual Review]

### REQ-LA-010: Legal Knowledge Base Integration

**Priority**: Low
**Dependencies**: REQ-LA-002

The system SHALL integrate with the Legal Knowledge capability to provide seamless research capabilities within chat conversations.

**Acceptance Criteria**:
- In-line research queries without leaving chat
- Results presented with proper citations
- Research results can be saved to workspace documents
- Research history tracked for matter documentation
- Deep links to external legal research databases

#### Scenario: In-Chat Legal Research

**Given** a workspace chat about employment law
**When** the user asks "What's the current standard for wrongful termination in California?"
**Then** the system:
1. Recognizes this as a research query
2. Queries Legal Knowledge system
3. Returns synthesized answer with citations:
   - Recent case law (*Smith v. ABC Corp.*, 2023)
   - Relevant statutes (California Labor Code § 2922)
   - Secondary sources (treatises, practice guides)
4. Offers: [Save Research to Documents] [See Full Research Results]

## UI/UX Requirements

### REQ-LA-UI-001: Legal Workspace Creation

**Priority**: High

The workspace creation modal SHALL include legal-specific configuration options.

**Acceptance Criteria**:
- Practice area dropdown (Litigation, Corporate, IP, Family Law, etc.)
- Jurisdiction selector (US Federal, State-specific, International)
- Matter type field (Case, Transaction, Advisory)
- Optional fields: Matter number, Client name, Opposing party
- Template workspace option (pre-configured for common matter types)

### REQ-LA-UI-002: Legal Assistant Indicator

**Priority**: Medium

The chat interface SHALL clearly indicate when Legal Assistant mode is active and display current legal context.

**Acceptance Criteria**:
- Visual indicator in chat header (e.g., "⚖️ Legal Assistant Active")
- Tooltip showing current context: jurisdiction, practice area
- Quick access to change legal context
- Disclaimer about legal advice prominently displayed
- Option to switch to "General Assistant" mode

### REQ-LA-UI-003: Citation Preview

**Priority**: Low

Legal citations in responses SHALL be interactive with hover previews and click-through to sources.

**Acceptance Criteria**:
- Citations are highlighted and clickable
- Hover shows: case name, court, year, holding summary
- Click opens: external legal database or case text
- Copy citation button in standard formats (Bluebook, APA, MLA)

## Non-Functional Requirements

### REQ-LA-NFR-001: Response Latency

The Legal Assistant SHALL maintain response times comparable to standard chat mode despite additional legal context processing.

**Target**: 95th percentile response time < 3 seconds for standard queries

### REQ-LA-NFR-002: Terminology Dictionary Updates

The legal terminology dictionary SHALL be updateable without requiring application redeployment.

**Implementation**: Dictionary stored in database, admin interface for additions/edits

### REQ-LA-NFR-003: Audit Logging

All legal assistant interactions SHALL be logged for compliance and audit purposes.

**Logged Events**:
- Chat messages (timestamp, user, workspace)
- Legal context changes (jurisdiction, practice area)
- Template usage and customization
- Risk flags triggered
- Privilege warnings displayed

## Success Metrics

- **Adoption**: 80% of new workspaces created with Legal Assistant mode enabled
- **Engagement**: Average 10+ messages per legal workspace per week
- **Template Usage**: 50% of legal workspaces use at least one template
- **Risk Flagging**: 90% of flagged risks acknowledged by users
- **User Satisfaction**: 4.5/5 rating from legal professionals in beta testing

## Out of Scope

- Fine-tuning LLM on firm-specific legal documents (Phase 2)
- Integration with external case management systems (Future)
- E-signature integration for template documents (Future)
- Automated legal research (handled by Legal Knowledge capability)
- Document comparison and redlining (Future enhancement)

## References

- Mind.Law Architecture: `/Users/tald/Projects/mind.law-platform/openspec/project.md`
- Harvey AI Legal Assistant: https://www.harvey.ai/
- Transformation Design: `/Users/tald/Projects/mind.law-platform/openspec/changes/transform-legal-platform/design.md`
