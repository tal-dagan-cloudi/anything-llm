# Spec Delta: Legal UI/UX Capability

**Change ID**: `transform-legal-platform`
**Capability**: `legal-ui-ux`
**Last Updated**: 2025-10-20

## Overview

This spec defines the Legal UI/UX capability that transforms the Mind.Law interface from a general-purpose AI platform into a legal professional-focused application with appropriate terminology, workflows, and visual design.

## ADDED Requirements

### REQ-LU-001: Legal Terminology Throughout Interface

**Priority**: High
**Dependencies**: None

The system SHALL use legal-specific terminology consistently throughout the user interface, replacing general-purpose terms with legal equivalents.

**Terminology Mapping**:
| Current Term | Legal Term | Context |
|--------------|------------|---------|
| Workspace | Matter / Case | Primary organization unit |
| Document | Pleading / Brief / Contract / Filing | Based on document type |
| Chat | Consultation / Research Session | Conversation type |
| Thread | Case Thread / Matter Discussion | Conversation subtopic |
| Upload | File / Attach Exhibit | Document management |
| Settings | Preferences / Configuration | User/admin settings |
| History | Case History / Matter Timeline | Historical view |

**Acceptance Criteria**:
- All UI labels updated to legal terminology
- Terminology consistent across all pages and components
- Help text and tooltips use legal language
- Error messages use legal context
- Terminology configurable via "Classic Mode" toggle for existing users

#### Scenario: Matter-Centric Navigation

**Given** a user navigating the legal platform interface
**When** viewing the main sidebar
**Then** the interface displays:

**My Matters** (instead of "Workspaces")
├── 📁 Smith v. Jones Litigation
├── 📁 ABC Corp M&A Transaction
├── 📁 Estate Planning - Johnson
└── [+ New Matter]

**And** when hovering over a matter
**Then** tooltip shows: "Open matter workspace" (not "Open workspace")

### REQ-LU-002: Matter-Centric Organization Structure

**Priority**: High
**Dependencies**: REQ-LU-001

The system SHALL organize all content around legal matters with appropriate metadata and hierarchy.

**Acceptance Criteria**:
- Matter creation includes: Matter Number, Client Name, Matter Type, Jurisdiction, Practice Area
- Matters have visual status indicators (Active, On Hold, Closed)
- Matter cards show: Client, Type, Last Activity, Assigned Attorney
- Quick filters: My Matters, Team Matters, By Client, By Practice Area
- Matter templates for common matter types (Litigation, Transactional, Advisory)

#### Scenario: Creating a New Litigation Matter

**Given** a user clicks "[+ New Matter]"
**When** the matter creation modal appears
**Then** the form includes:

**Create New Matter**

**Matter Information**:
- Matter Name: [___________] (e.g., "Smith v. Jones")
- Matter Number: [___________] (optional, auto-generated if blank)
- Client Name: [___________]
- Matter Type: [Litigation ▼] (Litigation, Transactional, Advisory, Compliance, IP)

**Legal Context**:
- Practice Area: [Civil Litigation ▼]
- Jurisdiction: [California State ▼]
- Court: [___________] (optional, e.g., "Superior Court of Los Angeles")
- Case Number: [___________] (optional)

**Team**:
- Lead Attorney: [John Doe ▼]
- Assigned Team: [+ Add Team Members]

**Advanced**:
- ⬜ Use matter template: [Select Template ▼]
- ⬜ Enable Legal Assistant
- ⬜ Enable Workflows
- ⬜ Enable Legal Research

[Create Matter] [Cancel]

### REQ-LU-003: Document-Centric Layout

**Priority**: High
**Dependencies**: REQ-LU-001

The system SHALL provide document-centric layouts that prioritize document viewing, editing, and analysis workflows common in legal practice.

**Acceptance Criteria**:
- Split-screen layout: Document viewer (left) + Chat/Analysis (right)
- Document viewer supports: PDF, DOCX, images, transcripts
- Side-by-side document comparison for redlining
- Document annotation tools: highlight, comment, bookmark
- Quick access to related documents within matter
- Document templates accessible from matter workspace

#### Scenario: Contract Review with Split-Screen Layout

**Given** a user opens a matter containing a vendor contract
**When** the user clicks on "Vendor_Services_Agreement.pdf"
**Then** the interface displays split-screen layout:

**Left Pane (60% width)**: Document Viewer
- PDF rendered with zoom controls
- Page navigation sidebar
- Annotation toolbar: ✍️ Highlight | 💬 Comment | 🔖 Bookmark
- [⬇️ Download] [📄 Compare Versions] [📋 Extract Text]

**Right Pane (40% width)**: Legal Analysis Chat
- Chat input: "Analyze this contract for risks"
- Previous analysis results
- Quick actions:
  - 🔍 Research Related Cases
  - ⚙️ Run Contract Review Workflow
  - 📝 Generate Summary Memo
  - 🚩 Flag Key Provisions

### REQ-LU-004: Legal Dashboard and Analytics

**Priority**: Medium
**Dependencies**: REQ-LU-002

The system SHALL provide a legal professional dashboard with matter overview, deadlines, recent activity, and analytics.

**Acceptance Criteria**:
- Dashboard shows: Active matters, upcoming deadlines, recent documents, team activity
- Matter analytics: Document count, research queries, workflow runs, time tracking
- Calendar view with court dates and filing deadlines
- Quick access to frequently used templates and workflows
- Customizable dashboard widgets

#### Scenario: Attorney Dashboard View

**Given** a user logs into the legal platform
**When** the home page loads
**Then** the dashboard displays:

**Legal Dashboard** - Good morning, John Doe

**Active Matters (8)**
┌─────────────────────────────────────────┐
│ ⚖️ Smith v. Jones                        │
│ Status: Active | Last updated: 2 hrs ago│
│ ⏰ Deadline: Discovery due in 5 days     │
│ [Open Matter]                            │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ 🏢 ABC Corp M&A                          │
│ Status: Active | Last updated: 1 day ago│
│ 📄 15 new documents | 3 pending reviews │
│ [Open Matter]                            │
└─────────────────────────────────────────┘
[View All Matters →]

**Upcoming Deadlines (3)**
- 📅 Apr 25: Motion to Dismiss due - Smith v. Jones
- 📅 Apr 28: Discovery responses due - Johnson case
- 📅 May 2: Closing documents - ABC Corp M&A

**Recent Activity**
- Sarah completed Contract Review workflow - ABC Corp M&A (10 min ago)
- New case law found for Smith v. Jones (1 hour ago)
- Client uploaded 3 documents - Estate Planning matter (2 hours ago)

**This Week**
- 🔍 45 research queries
- ⚙️ 12 workflows executed
- 📄 127 documents processed
- ⏱️ 38.5 hours tracked

### REQ-LU-005: Legal Color Scheme and Branding

**Priority**: Medium
**Dependencies**: None

The system SHALL use a professional color scheme appropriate for legal practice with options for firm-specific branding.

**Acceptance Criteria**:
- Primary colors: Deep blue (#1e40af), charcoal (#374151), gold accent (#d97706)
- Light theme option (default for legal professionals)
- Dark theme option (for late-night work)
- Custom logo upload for law firms
- Custom color scheme for white-label deployments
- Professional typography (serif fonts for documents, sans-serif for UI)

**Color Palette**:
- **Primary**: Deep Blue (#1e40af) - Trust, authority
- **Secondary**: Charcoal Gray (#374151) - Professional, neutral
- **Accent**: Gold (#d97706) - Premium, importance
- **Success**: Forest Green (#059669) - Approval, completion
- **Warning**: Amber (#d97706) - Caution, review needed
- **Danger**: Crimson (#dc2626) - Risk, deadline
- **Background**: White (#ffffff) light theme, Dark Navy (#0f172a) dark theme

#### Scenario: Firm-Branded Interface

**Given** a law firm "Smith & Associates" uses the platform
**When** an admin configures firm branding
**Then** the interface reflects:
- Custom logo in sidebar header and login page
- Primary color changed to firm's brand color (#2c5aa0)
- Custom tagline: "Excellence in Legal Service"
- Branded email templates for workflow results
- Custom footer: "Smith & Associates LLP | Confidential Attorney Work Product"

### REQ-LU-006: Role-Based Interface Customization

**Priority**: Medium
**Dependencies**: REQ-LU-002, REQ-LU-004

The system SHALL provide role-specific interface customizations for different legal roles (Partner, Associate, Paralegal, Staff, Client).

**Acceptance Criteria**:
- Role-specific dashboard widgets and layouts
- Permission-based feature visibility (e.g., billing only for partners)
- Role-based navigation shortcuts
- Custom workflows per role
- Simplified "Client View" for client portal access

**Role Definitions**:
- **Partner**: Full access, billing, matter management, team oversight
- **Associate**: Matter work, research, document preparation, limited admin
- **Paralegal**: Document management, workflow execution, scheduling
- **Staff**: Limited access, administrative support
- **Client**: Read-only access to assigned matters, secure messaging

#### Scenario: Paralegal Interface View

**Given** a user with role "Paralegal" logs in
**When** the dashboard loads
**Then** the interface shows:

**Paralegal Dashboard** - Welcome, Jane Smith

**My Assignments (12 tasks)**
- [ ] Organize discovery documents - Smith v. Jones
- [ ] Run due diligence checklist - ABC Corp M&A
- [ ] Schedule depositions - Johnson case
- [ ] File courtesy copies - Williams matter
[View All Tasks →]

**Workflows Available** (limited to paralegal-appropriate workflows)
- Due Diligence Checklist
- Discovery Request Generator
- Document Organization
- Deposition Prep

**Recent Documents**
- Discovery responses - Smith v. Jones (uploaded 1 hour ago)
- Interrogatories - Johnson case (uploaded 3 hours ago)

**Hidden from Paralegal View**:
- ❌ Billing information
- ❌ Client acquisition data
- ❌ Partner-only workflows
- ❌ Financial analytics

### REQ-LU-007: Context-Aware Help and Onboarding

**Priority**: Low
**Dependencies**: REQ-LU-001

The system SHALL provide context-aware help, tooltips, and guided onboarding specifically designed for legal professionals.

**Acceptance Criteria**:
- Interactive walkthrough for new users (5-10 minutes)
- Practice area-specific tutorials
- Contextual help tooltips using legal terminology
- Video tutorials for common workflows
- In-app knowledge base with legal use cases
- "Legal AI 101" guide for attorneys new to AI tools

#### Scenario: New User Onboarding for Litigator

**Given** a new user with practice area "Litigation" completes registration
**When** they first log in
**Then** an onboarding wizard appears:

**Welcome to Mind.Law Legal Platform** (Step 1 of 5)

Let's get you started! This will take about 5 minutes.

**Your Practice Area**: Litigation ⚖️

We'll customize the platform for litigation practice, including:
- Case management and court calendaring
- Discovery and motion workflows
- Legal research with case law citations
- Pleading and brief templates

[Continue] [Skip Tutorial]

**Step 2/5: Create Your First Matter**
Let's set up a sample litigation matter to explore the platform...

**Step 3/5: Legal Research Basics**
Learn how to research case law and generate citations...

**Step 4/5: Running a Discovery Workflow**
See how workflows can automate discovery request generation...

**Step 5/5: You're All Set!**
🎉 You've completed the tutorial. Here are some next steps:
- [ ] Import your first case documents
- [ ] Explore workflow library
- [ ] Customize your dashboard

[Finish Tutorial] [Watch Video Guide]

### REQ-LU-008: Mobile-Responsive Legal Interface

**Priority**: Low
**Dependencies**: REQ-LU-001, REQ-LU-002

The system SHALL provide a mobile-responsive interface optimized for common legal tasks on phones and tablets.

**Acceptance Criteria**:
- Responsive design breakpoints: Mobile (< 768px), Tablet (768-1024px), Desktop (> 1024px)
- Mobile-optimized: Matter list, document viewer, quick chat, notifications
- Tablet-optimized: Split-screen document review, workflow execution
- Touch-friendly buttons and controls (minimum 44x44px touch targets)
- Offline mode for document viewing (PWA capabilities)

#### Scenario: Mobile Document Review

**Given** an attorney is traveling and needs to review a contract on their phone
**When** they open the Mind.Law mobile app
**Then** the interface displays:

**Mobile View (320px-767px)**:
- Hamburger menu (☰) for navigation
- Matter list with cards (full width)
- Tap matter → Document list
- Tap document → Full-screen document viewer
- Bottom action bar:
  - 💬 Chat
  - 🔍 Research
  - ⚙️ Workflows
  - 📤 Share
- Swipe gestures: Left (next page), Right (previous page), Pinch (zoom)

**Tablet View (768px-1023px)**:
- Side-by-side layout (document 60% | chat 40%)
- Persistent sidebar with matter list
- Full workflow execution capabilities
- Annotation tools optimized for Apple Pencil/stylus

### REQ-LU-009: Keyboard Shortcuts for Power Users

**Priority**: Low
**Dependencies**: None

The system SHALL provide comprehensive keyboard shortcuts for common legal workflows and navigation.

**Acceptance Criteria**:
- Global shortcuts: New matter (Cmd/Ctrl+N), Search (Cmd/Ctrl+K), Settings (Cmd/Ctrl+,)
- Matter-specific: New document (Cmd/Ctrl+D), Research (Cmd/Ctrl+R), Workflows (Cmd/Ctrl+W)
- Document shortcuts: Next page (→), Previous page (←), Zoom (Cmd/Ctrl + +/-), Annotate (Cmd/Ctrl+H)
- Chat shortcuts: New message (Cmd/Ctrl+Enter), Clear (Cmd/Ctrl+L)
- Shortcut help overlay (? or Cmd/Ctrl+/)

#### Scenario: Attorney Using Keyboard Shortcuts

**Given** an attorney is working on a litigation matter
**When** they want to quickly research a legal issue without using mouse
**Then** they can:
1. Press `Cmd+K` → Search modal opens
2. Type "Smith v. Jones" → Matter appears
3. Press `Enter` → Matter opens
4. Press `Cmd+R` → Research interface opens
5. Type research query → Execute with `Enter`
6. Press `Esc` → Return to matter
7. Press `Cmd+W` → Workflow library opens
8. Arrow keys → Navigate workflows
9. Press `Enter` → Launch workflow

**And** at any time, press `?` to see:

**Keyboard Shortcuts**
**Global**
- `Cmd+N` - New matter
- `Cmd+K` - Quick search
- `Cmd+R` - Research
- `Cmd+W` - Workflows
- `Cmd+,` - Settings

**Matter View**
- `Cmd+D` - New document
- `Cmd+E` - Export matter
- `Cmd+I` - Matter info

**Document View**
- `→` / `←` - Next/previous page
- `Cmd +/-` - Zoom in/out
- `Cmd+H` - Highlight
- `Cmd+/` - Comment

[Close]

### REQ-LU-010: Accessibility for Legal Professionals

**Priority**: Medium
**Dependencies**: None

The system SHALL meet WCAG 2.1 Level AA accessibility standards with specific considerations for legal professionals.

**Acceptance Criteria**:
- Screen reader support for all interface elements
- Keyboard navigation for all features
- High contrast mode for low vision users
- Text size adjustment (100%-200%)
- Color blind-friendly color schemes
- Alternative text for all images and icons
- ARIA labels for legal-specific components
- Voice input support for dictation (common in legal practice)

#### Scenario: Screen Reader User

**Given** an attorney using JAWS screen reader
**When** navigating the platform
**Then** screen reader announces:

"Main navigation. Matters list. Smith v. Jones, litigation matter, last updated 2 hours ago, status active, deadline in 5 days. Button: Open matter."

**And** when tabbing through documents:

"Document list. Vendor agreement PDF, uploaded April 15, 2024, 12 pages. Button: Review document. Button: Download. Button: Run workflow."

**And** all interactive elements are reachable via keyboard and have descriptive ARIA labels.

## UI Component Requirements

### REQ-LU-COMP-001: Legal Matter Card Component

**Priority**: High

Create a standardized Matter Card component for displaying matter information consistently.

**Component Specification**:
```jsx
<MatterCard
  matterName="Smith v. Jones"
  matterNumber="2024-LIT-001"
  client="John Smith"
  matterType="Litigation"
  practiceArea="Civil Litigation"
  status="Active"
  lastActivity="2 hours ago"
  deadlines={[
    { date: "2024-04-25", description: "Motion to Dismiss due" }
  ]}
  assignedAttorney="John Doe"
  teamMembers={["Jane Smith", "Bob Johnson"]}
  documentCount={45}
  onOpen={() => {}}
  onSettings={() => {}}
/>
```

### REQ-LU-COMP-002: Legal Document Viewer Component

**Priority**: High

Create a document viewer component optimized for legal documents (PDF, DOCX, etc.).

**Component Features**:
- PDF.js-based rendering with page thumbnails
- Annotation tools (highlight, comment, bookmark)
- Text selection and search
- Zoom controls and page navigation
- Citation extraction and linking
- Side-by-side comparison mode
- Print and export options

### REQ-LU-COMP-003: Citation Component

**Priority**: Medium

Create an interactive Citation component for displaying and managing legal citations.

**Component Specification**:
```jsx
<Citation
  type="case"
  fullCitation="Brown v. Board of Education, 347 U.S. 483 (1954)"
  shortCitation="Brown, 347 U.S. at 495"
  verified={true}
  treatment="good-law"
  onHover={() => showPreview()}
  onClick={() => openCaseText()}
  onCopy={(format) => copyCitation(format)}
/>
```

## Non-Functional Requirements

### REQ-LU-NFR-001: Interface Performance

The UI SHALL load pages and render components within performance budgets.

**Targets**:
- Initial page load: < 2 seconds
- Matter card rendering: < 100ms for 50 cards
- Document viewer load: < 3 seconds for 100-page PDF
- Chat message render: < 50ms per message

### REQ-LU-NFR-002: Browser Support

The UI SHALL support modern browsers commonly used by legal professionals.

**Supported Browsers**:
- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Opera 76+

**Not Supported**: Internet Explorer (discontinued)

### REQ-LU-NFR-003: Theme Switching Performance

Switching between light and dark themes SHALL be instant without page reload.

**Implementation**: CSS variables with smooth transitions

### REQ-LU-NFR-004: Print Styles

All legal documents and reports SHALL have print-optimized styles.

**Print Optimizations**:
- Remove navigation and sidebars
- Expand collapsed sections
- Page break handling for long documents
- Header/footer with matter information
- Black text on white background (regardless of theme)

## Success Metrics

- **User Satisfaction**: 4.5/5 rating for UI usability from legal professionals
- **Onboarding Time**: 80% of new users complete tutorial in < 10 minutes
- **Task Completion**: 90% of common legal tasks completable in ≤ 3 clicks
- **Accessibility**: WCAG 2.1 Level AA compliance (automated + manual testing)
- **Mobile Usage**: 30% of users access platform via mobile device weekly
- **Keyboard Efficiency**: 40% of power users adopt keyboard shortcuts within 1 month

## Out of Scope

- Video conferencing integration (Zoom, Teams) - Future
- E-signature interface (DocuSign, Adobe Sign) - Future
- Time tracking and billing interface - Future
- Court calendar synchronization - Future
- Client portal interface - Future (separate deployment)

## Migration Strategy

### Phase 1: Terminology Update (Week 1-2)
- Update all UI labels from general → legal terms
- Add "Classic Mode" toggle for existing users
- Update help documentation and tooltips

### Phase 2: Layout Transformation (Week 3-4)
- Implement matter-centric navigation
- Deploy legal dashboard
- Roll out document-centric layouts

### Phase 3: Visual Design (Week 5-6)
- Apply legal color scheme
- Update typography for professional look
- Add firm branding capabilities

### Phase 4: Mobile Optimization (Week 7-8)
- Responsive design implementation
- Touch optimization
- PWA capabilities for offline access

## References

- Mind.Law Current Frontend: `/Users/tald/Projects/mind.law-platform/frontend/`
- Tailwind Config: `/Users/tald/Projects/mind.law-platform/frontend/tailwind.config.js`
- Current Sidebar: `/Users/tald/Projects/mind.law-platform/frontend/src/components/Sidebar/index.jsx`
- Harvey AI Interface: https://www.harvey.ai/
- Transformation Design: `/Users/tald/Projects/mind.law-platform/openspec/changes/transform-legal-platform/design.md`
