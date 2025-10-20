# Frontend UI Redesign - Spec Deltas

## ADDED Requirements

### Requirement: Professional Light Theme as Default
The system SHALL provide a professional, light-themed user interface as the default theme that matches the visual design and color palette of the Mind.Law landing website (https://mind.law).

#### Scenario: Light theme is default for new users
- **WHEN** a new user accesses the platform for the first time
- **THEN** the light theme is applied by default
- **AND** the theme matches the landing website's professional aesthetic (white backgrounds, blue accents)

#### Scenario: Existing user theme preferences are preserved
- **WHEN** an existing user has selected dark theme
- **THEN** their dark theme preference is preserved after the UI update
- **AND** they can switch back to light theme at any time via theme toggle

### Requirement: Landing Website Color Palette
The system SHALL use colors extracted from the Mind.Law landing website as the primary color palette for all UI components.

#### Scenario: Primary brand colors match landing website
- **WHEN** rendering any primary action buttons or brand elements
- **THEN** the primary blue color #36bffa is used
- **AND** hover states use #0ba5ec (darker blue)
- **AND** colors match exactly what appears on https://mind.law

#### Scenario: Backgrounds use professional light colors
- **WHEN** rendering page backgrounds and containers
- **THEN** primary background is white (#ffffff)
- **AND** secondary background is light gray (#f9fbfd)
- **AND** sidebar background is light blue-gray (#edf2fa)

#### Scenario: Text colors ensure high readability
- **WHEN** rendering text content
- **THEN** primary text color is near-black (#0e0f0f)
- **AND** secondary text color is gray (#7a7d7e)
- **AND** contrast ratios meet WCAG AA standards (4.5:1 minimum)

### Requirement: Clean, Minimal Design Patterns
The system SHALL use clean, minimal design patterns with subtle shadows and borders instead of heavy gradients.

#### Scenario: Cards use subtle shadows
- **WHEN** rendering card components (workspace cards, settings cards, etc.)
- **THEN** cards use white backgrounds with subtle box shadows
- **AND** no gradient backgrounds are used
- **AND** borders are light gray (rgba(0, 0, 0, 0.1))

#### Scenario: Buttons use solid colors with hover states
- **WHEN** rendering buttons (primary, secondary, CTA)
- **THEN** buttons use solid background colors (no gradients)
- **AND** hover states darken or lighten the color slightly
- **AND** rounded corners (border-radius) match landing website style

### Requirement: Trust-Building Visual Elements
The system SHALL incorporate trust-building visual elements that convey professionalism and enterprise-grade quality.

#### Scenario: Professional typography hierarchy
- **WHEN** rendering headings and body text
- **THEN** font sizes follow clear hierarchy (h1 > h2 > h3 > body)
- **AND** font family is "plus-jakarta-sans" (existing professional sans-serif)
- **AND** line heights and letter spacing ensure readability

#### Scenario: White space improves content hierarchy
- **WHEN** rendering page layouts
- **THEN** generous padding and margins separate content sections
- **AND** content doesn't feel cramped or cluttered
- **AND** visual hierarchy guides user attention effectively

### Requirement: Updated Dark Theme Palette
The system SHALL provide an updated dark theme option with reduced gradient usage and improved contrast.

#### Scenario: Dark theme uses solid backgrounds
- **WHEN** user selects dark theme
- **THEN** backgrounds use solid dark colors (not gradients)
- **AND** subtle borders separate content sections
- **AND** blue accent colors (#36bffa, #0ba5ec) maintain brand consistency

#### Scenario: Dark theme maintains accessibility
- **WHEN** user selects dark theme
- **THEN** text contrast ratios meet WCAG AA standards
- **AND** all interactive elements are clearly visible
- **AND** focus states are prominent for keyboard navigation

## MODIFIED Requirements

### Requirement: Theme System Architecture
The system SHALL provide a theme system using CSS variables that supports light and dark themes with runtime switching capability.

**MODIFIED FROM**: Dark-first theme system with light mode as secondary option
**MODIFIED TO**: Light-first theme system with dark mode as secondary option

#### Scenario: CSS variables define theme colors
- **WHEN** the theme system initializes
- **THEN** `:root` CSS variables define light theme colors (default)
- **AND** `[data-theme="dark"]` CSS variables define dark theme colors
- **AND** all components reference CSS variables (not hardcoded colors)

#### Scenario: Theme toggle switches between light and dark
- **WHEN** user clicks theme toggle
- **THEN** `data-theme` attribute switches between "light" and "dark"
- **AND** CSS variables update via selector specificity
- **AND** theme preference is saved to localStorage
- **AND** UI updates immediately without page reload

### Requirement: Component Visual Design
The system SHALL render all UI components with visual styling that matches the landing website's design language.

**MODIFIED FROM**: Dark gradient-based component styling
**MODIFIED TO**: Clean, light-themed styling with subtle shadows and borders

#### Scenario: Buttons match landing website CTAs
- **WHEN** rendering primary action buttons
- **THEN** button styles match the "Request Demo" and "View Platform" buttons from landing website
- **AND** colors, padding, font size, and border radius match exactly
- **AND** hover states provide clear visual feedback

#### Scenario: Form inputs use clean border styling
- **WHEN** rendering text inputs, selects, and textareas
- **THEN** inputs use light backgrounds with gray borders
- **AND** focus states use blue border color (#36bffa)
- **AND** placeholder text is gray (#9ca3af) for readability

#### Scenario: Navigation matches landing website style
- **WHEN** rendering sidebar and navigation elements
- **THEN** navigation style matches the landing website's navigation patterns
- **AND** active states use subtle blue backgrounds
- **AND** hover states provide clear visual feedback

### Requirement: Layout and Spacing
The system SHALL use card-based layouts and generous spacing to improve content hierarchy and readability.

**MODIFIED FROM**: Compact layouts with minimal padding
**MODIFIED TO**: Spacious layouts with card-based content organization

#### Scenario: Workspace list uses card layout
- **WHEN** rendering workspace list on home page
- **THEN** each workspace is a card with white background and subtle shadow
- **AND** cards have rounded corners and appropriate padding
- **AND** hover states highlight the card with border or shadow change

#### Scenario: Settings pages use section cards
- **WHEN** rendering settings pages
- **THEN** each settings section is a card with clear heading
- **AND** cards are separated by vertical spacing
- **AND** form fields within cards have appropriate padding

## REMOVED Requirements

None - all existing functionality is preserved, only visual styling changes.
