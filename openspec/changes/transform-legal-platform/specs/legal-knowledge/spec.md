# Spec Delta: Legal Knowledge Capability

**Change ID**: `transform-legal-platform`
**Capability**: `legal-knowledge`
**Last Updated**: 2025-10-20

## Overview

This spec defines the Legal Knowledge capability that provides comprehensive legal research functionality with access to case law, statutes, regulations, and secondary sources, all with proper citation management and source grounding.

## ADDED Requirements

### REQ-LK-001: Multi-Source Legal Research

**Priority**: High
**Dependencies**: None

The system SHALL query multiple legal research sources (external APIs and local documents) and return ranked, relevant results with citations.

**Acceptance Criteria**:
- Integrates with at least 2 external legal research APIs
- Searches local workspace documents simultaneously
- Results ranked by relevance score
- Each result includes: title, citation, jurisdiction, date, excerpt
- Results grouped by source type (Case Law, Statutes, Secondary Sources)

#### Scenario: Federal Employment Law Research

**Given** a research query for "federal employment discrimination standards"
**And** the workspace jurisdiction is set to "US Federal"
**When** the research is executed
**Then** the system returns results from:
- **Case Law**: Recent Supreme Court and Circuit Court decisions
- **Statutes**: Title VII of Civil Rights Act, ADA, ADEA
- **Regulations**: EEOC guidelines
- **Local Documents**: Firm memos on discrimination cases
**And** results are ranked with most relevant at top
**And** each result shows proper legal citation

### REQ-LK-002: Citation Generation and Formatting

**Priority**: High
**Dependencies**: REQ-LK-001

The system SHALL automatically generate properly formatted legal citations in multiple citation styles (Bluebook, APA, MLA).

**Acceptance Criteria**:
- Supports Bluebook (primary), APA, MLA citation formats
- Citations include all required elements (case name, reporter, court, year)
- Parallel citations included when available
- Short-form citations for subsequent references
- Signal words and parentheticals supported
- Copy-to-clipboard functionality for citations

#### Scenario: Bluebook Citation for Supreme Court Case

**Given** a research result for "Brown v. Board of Education"
**When** the user selects "Copy Bluebook Citation"
**Then** the system generates:

**Full Citation**: Brown v. Bd. of Educ., 347 U.S. 483 (1954).

**Short Citation**: *Brown*, 347 U.S. at 495.

**Parenthetical with Holding**: *Brown v. Bd. of Educ.*, 347 U.S. 483, 495 (1954) (holding that separate educational facilities are inherently unequal).

### REQ-LK-003: Jurisdiction-Specific Research

**Priority**: High
**Dependencies**: REQ-LK-001

The system SHALL filter research results by jurisdiction and provide jurisdiction-specific legal authority.

**Acceptance Criteria**:
- Jurisdiction selector: US Federal, 50 States, Circuits, Districts
- Results automatically filtered to selected jurisdiction
- Authority hierarchy respected (binding vs. persuasive)
- Clear indication of which court issued each decision
- Option to expand to persuasive authority from other jurisdictions

#### Scenario: California State Court Research with Federal Comparison

**Given** a research query for "reasonable accommodation standards"
**And** jurisdiction set to "California State"
**When** research is executed
**Then** the system returns:
- **Primary**: California state court decisions (binding)
- **Secondary**: Federal Ninth Circuit decisions (persuasive)
- **Comparison**: Side-by-side view of CA vs. Federal standards
**And** clearly labels which authorities are binding in California

### REQ-LK-004: Case Law Deep Links

**Priority**: Medium
**Dependencies**: REQ-LK-001

The system SHALL provide deep links to full case text in external legal research databases or free sources.

**Acceptance Criteria**:
- Links to Google Scholar, Justia, CourtListener for free access
- Optional links to paid services (Westlaw, Lexis) if user has subscription
- Fallback to official court websites when available
- PDF download option for cases
- "Read more" expands case excerpt within interface

#### Scenario: Accessing Full Case Text

**Given** a research result for *Obergefell v. Hodges*
**When** the user clicks on the case name
**Then** the system provides options:
- [Read on Google Scholar] (free)
- [Open in Westlaw] (if subscription configured)
- [Open in LexisNexis] (if subscription configured)
- [View on Supreme Court Website] (official source)
- [Download PDF]

**And** a preview excerpt expands in-line with option to collapse

### REQ-LK-005: Statute and Regulation Research

**Priority**: High
**Dependencies**: REQ-LK-001

The system SHALL provide access to federal and state statutes, regulations, and administrative codes with current and historical versions.

**Acceptance Criteria**:
- US Code (federal statutes) fully searchable
- State codes for all 50 states
- Code of Federal Regulations (CFR)
- Historical versions available with effective dates
- Amendment history tracked
- Cross-references to related statutes

#### Scenario: Finding Current and Historical Statute Text

**Given** a research query for "California Civil Code § 1542"
**When** the statute is retrieved
**Then** the system displays:
- **Current Version**: Full text as currently in effect
- **Effective Date**: January 1, 2020
- **Amendment History**: Links to previous versions (2015, 2010, 1992)
- **Cross-References**: Related sections (§ 1541, § 1543)
- **Annotations**: Links to cases citing this statute
- **Citation**: Cal. Civ. Code § 1542 (West 2020)

### REQ-LK-006: Legal Research Cache

**Priority**: Medium
**Dependencies**: REQ-LK-001

The system SHALL cache research results to reduce API costs and improve response times while maintaining result freshness.

**Acceptance Criteria**:
- Cache duration: 24 hours for case law (doesn't change frequently)
- Cache duration: 1 hour for statutes (may have recent amendments)
- Cache key: query + jurisdiction + date range
- Manual refresh option to bypass cache
- Cache statistics visible to admins (hit rate, cost savings)

#### Scenario: Repeated Research Query Within 24 Hours

**Given** a research query for "contract formation elements"
**And** the same query was performed 6 hours ago
**When** the research is re-executed
**Then** the system:
- Returns cached results instantly (< 200ms response time)
- Displays timestamp: "Results from 6 hours ago"
- Offers: [Use Cached Results] [Refresh from Sources]
**And If** user selects "Refresh"
**Then** new API queries are made and cache is updated

### REQ-LK-007: Secondary Source Integration

**Priority**: Low
**Dependencies**: REQ-LK-001

The system SHALL include secondary sources (treatises, law review articles, practice guides) in research results where available.

**Acceptance Criteria**:
- Integration with at least one secondary source provider
- Categories: Treatises, Law Reviews, Practice Guides, Legal Encyclopedias
- Full citations for secondary sources
- Relevance ranking includes secondary sources appropriately
- Option to filter results to exclude/include secondary sources

#### Scenario: Comprehensive Research with Secondary Sources

**Given** a research query for "piercing the corporate veil standards"
**When** secondary sources are enabled
**Then** results include:
- **Case Law**: Leading cases on veil piercing
- **Treatises**: Fletcher Cyclopedia of Corporations § 41
- **Law Reviews**: Harvard Law Review article on modern veil piercing
- **Practice Guides**: State-specific practice guide sections
**And** each secondary source includes:
- Full citation
- Excerpt with relevant text
- Publication date
- Authority level indicator (Highly Cited, Standard Reference, etc.)

### REQ-LK-008: Research History and Saved Searches

**Priority**: Medium
**Dependencies**: REQ-LK-001

The system SHALL track research history per workspace and allow users to save and rerun searches.

**Acceptance Criteria**:
- Research history stored per workspace
- History includes: query, date, results count, user
- Saved searches can be named and organized
- Saved searches can be shared within workspace
- Export research history as report (PDF, DOCX)

#### Scenario: Saving Recurring Research Query

**Given** a research query for "California wage and hour updates"
**When** the user clicks "Save This Search"
**Then** the system prompts for:
- Search Name: "CA Wage & Hour - Monthly Check"
- Alert Frequency: [None] [Daily] [Weekly] [Monthly]
**And When** saved with "Monthly" alert
**Then** the system:
- Runs search automatically on 1st of each month
- Emails results if new cases/statutes found
- Displays badge notification in workspace: "3 new results"

### REQ-LK-009: Citation Verification

**Priority**: Medium
**Dependencies**: REQ-LK-002

The system SHALL verify that cited cases exist, have accurate citations, and have not been overturned or modified by subsequent decisions.

**Acceptance Criteria**:
- Verification checks: case exists, citation format correct, still good law
- Shepardization or KeyCite-like functionality (negative treatment flags)
- Visual indicators: ✅ Good Law, ⚠️ Caution, ❌ Overruled
- Links to cases that distinguished, limited, or overruled
- Verification runs automatically on all citations in chat/documents

#### Scenario: Citation with Negative Treatment

**Given** a user cites *Plessy v. Ferguson*, 163 U.S. 537 (1896)
**When** citation verification runs
**Then** the system displays:

❌ **NEGATIVE TREATMENT WARNING**
*Plessy v. Ferguson* has been overruled by *Brown v. Board of Education*, 347 U.S. 483 (1954).

**Status**: Overruled
**Citing Authority**: *Brown v. Bd. of Educ.*, 347 U.S. 483 (1954)
**Issue**: "Separate but equal" doctrine in education unconstitutional

[View Full Treatment History]

### REQ-LK-010: Research Result Annotation

**Priority**: Low
**Dependencies**: REQ-LK-001

The system SHALL allow users to annotate research results with notes, tags, and importance ratings.

**Acceptance Criteria**:
- Per-result annotations: text notes, tags, 1-5 star rating
- Annotations shared across workspace users
- Filtered view: show only annotated results
- Export annotations with research results
- Annotations searchable

#### Scenario: Annotating Key Case for Matter

**Given** a research result for *Chevron U.S.A., Inc. v. Natural Resources Defense Council, Inc.*
**When** the user clicks "Add Annotation"
**Then** the annotation editor appears with:
- **Notes**: [Rich text editor for detailed analysis]
- **Tags**: [Add tags: "Deference", "Administrative Law", "Key Precedent"]
- **Rating**: [⭐⭐⭐⭐⭐] (5 stars for critical case)
- **Assign To**: [Select workspace users to review]
**And** annotations are visible to all workspace members
**And** annotated cases appear in "Starred Cases" quick access list

## UI/UX Requirements

### REQ-LK-UI-001: Research Interface

**Priority**: High

The system SHALL provide a dedicated legal research interface accessible from any workspace.

**Acceptance Criteria**:
- Search bar with jurisdiction selector and date range filters
- Tabbed results: Case Law, Statutes, Secondary Sources, Local Documents
- Side-by-side document viewer for comparing multiple sources
- Export results to workspace documents
- Quick access to recent searches and saved searches

### REQ-LK-UI-002: In-Line Research Widget

**Priority**: Medium

The chat interface SHALL provide an in-line research widget for quick research without leaving the conversation.

**Acceptance Criteria**:
- Keyboard shortcut to open research widget (e.g., Cmd+K)
- Widget appears as overlay on chat
- Results preview with "View Full Research" option
- Selected results can be inserted into chat as citations
- Widget remembers last jurisdiction and filters

### REQ-LK-UI-003: Citation Manager

**Priority**: Medium

The system SHALL provide a citation manager for organizing and exporting citations used in a workspace.

**Acceptance Criteria**:
- List of all citations used in workspace chats and documents
- Group by: Matter, Document, Date, Authority Type
- Bulk export to citation management tools (Zotero, EndNote)
- Generate Table of Authorities for briefs
- Check for duplicate citations

## Non-Functional Requirements

### REQ-LK-NFR-001: Research Response Time

Legal research queries SHALL return initial results within 5 seconds.

**Target**: 95th percentile < 5 seconds for cached queries, < 15 seconds for live queries

### REQ-LK-NFR-002: External API Rate Limiting

The system SHALL respect rate limits of external legal research APIs and handle quota exhaustion gracefully.

**Implementation**:
- Rate limit tracking per API provider
- Queue system for high-volume research
- User notification when approaching quota limits
- Automatic fallback to cached results when quota exceeded

### REQ-LK-NFR-003: Citation Accuracy

Citation generation SHALL have >99% accuracy for format compliance (Bluebook, APA, MLA).

**Validation**: Automated testing against citation manuals, manual review of 100 random citations

### REQ-LK-NFR-004: Data Freshness

Legal research results SHALL indicate data freshness and warn when results may be outdated.

**Implementation**:
- Display "Last Updated" timestamp on all results
- Warning if case law results are >30 days old
- Automatic refresh suggestion for results >60 days old

## Success Metrics

- **Research Volume**: Average 20+ research queries per legal workspace per month
- **Citation Quality**: 95% of generated citations pass format validation
- **API Cost Efficiency**: 70% cache hit rate for research queries
- **User Satisfaction**: 4.5/5 rating for research accuracy and relevance
- **Time Savings**: 60% reduction in research time compared to manual methods (user survey)

## Out of Scope

- Direct integration with Westlaw/LexisNexis (user brings own subscription)
- International law research beyond major English-speaking jurisdictions (Phase 2)
- Patent and trademark research (specialized future enhancement)
- Legislative history and bill tracking (Future)
- Docket monitoring and case alerts (Future)

## API Integration Requirements

### REQ-LK-API-001: CourtListener API Integration

**Priority**: High

Integrate with CourtListener (Free Law Project) API for case law research.

**Endpoints**:
- `/api/rest/v3/search/` - Search opinions
- `/api/rest/v3/clusters/{id}/` - Get opinion cluster details
- `/api/rest/v3/opinions/{id}/` - Get full opinion text

**Rate Limits**: 5,000 requests/day (free tier)

### REQ-LK-API-002: Case.law API Integration

**Priority**: Medium

Integrate with Harvard's case.law API for historical case law.

**Coverage**: US case law from 1658-2018 (40+ million cases)

### REQ-LK-API-003: Fastcase Integration (Optional)

**Priority**: Low

Provide optional integration with Fastcase for premium legal research.

**Requirements**: User must have Fastcase subscription and API key

## References

- Mind.Law Architecture: `/Users/tald/Projects/mind.law-platform/openspec/project.md`
- CourtListener API: https://www.courtlistener.com/api/
- The Bluebook Citation Guide: 21st Edition
- Transformation Design: `/Users/tald/Projects/mind.law-platform/openspec/changes/transform-legal-platform/design.md`
