# Implementation Tasks - UI Redesign

## 1. Foundation Setup (Days 1-2)

- [ ] 1.1 Extract exact color values from landing website (https://mind.law) using browser dev tools
- [ ] 1.2 Create color mapping document with hex codes for all theme variables
- [ ] 1.3 Screenshot all current pages as baseline for visual regression testing
- [ ] 1.4 Create visual testing checklist (all routes, all states)

## 2. Theme System Updates (Days 2-3)

- [ ] 2.1 Update `frontend/src/index.css` `:root` CSS variables to light theme defaults
  - Primary colors: #36bffa, #0ba5ec
  - Backgrounds: #ffffff, #f9fbfd, #edf2fa
  - Text: #0e0f0f, #7a7d7e
  - Borders: rgba(0, 0, 0, 0.1)
- [ ] 2.2 Update `[data-theme="dark"]` CSS variables for improved dark theme (remove gradients)
- [ ] 2.3 Update `frontend/tailwind.config.js` theme extension with new color palette
- [ ] 2.4 Update `ThemeContext.jsx` to default to light theme for new users
- [ ] 2.5 Test theme toggle functionality (light ↔ dark switching)
- [ ] 2.6 Verify CSS variables propagate correctly to all components

## 3. Core Components - Buttons (Day 3)

- [ ] 3.1 Update primary button styling to match landing "Request Demo" button
  - Solid background color (no gradients)
  - Rounded corners
  - Hover state with color darken
- [ ] 3.2 Update secondary button styling (outlined style with blue border)
- [ ] 3.3 Update icon buttons with clean hover states
- [ ] 3.4 Update CTA buttons for high visibility actions
- [ ] 3.5 Test all button variants across light and dark themes
- [ ] 3.6 Verify button accessibility (focus states, keyboard navigation)

## 4. Core Components - Inputs & Forms (Day 4)

- [ ] 4.1 Update text input styling (light background, gray border, blue focus)
- [ ] 4.2 Update select dropdown styling to match input patterns
- [ ] 4.3 Update textarea styling for consistency
- [ ] 4.4 Update checkbox and radio button styling
- [ ] 4.5 Update form labels and help text typography
- [ ] 4.6 Test form validation states (error, success, disabled)
- [ ] 4.7 Verify input accessibility (labels, ARIA attributes)

## 5. Core Components - Cards & Containers (Day 5)

- [ ] 5.1 Update card component with white background and subtle shadow
- [ ] 5.2 Remove gradient backgrounds from all cards
- [ ] 5.3 Add border-radius to match landing website style
- [ ] 5.4 Update card hover states (shadow increase or border highlight)
- [ ] 5.5 Update container components with clean backgrounds
- [ ] 5.6 Test card layouts in grid and list views

## 6. Layout Components - Sidebar (Day 6)

- [ ] 6.1 Update sidebar background to light blue-gray (#edf2fa)
- [ ] 6.2 Update sidebar item default state (clean, minimal)
- [ ] 6.3 Update sidebar item selected state (subtle blue background)
- [ ] 6.4 Update sidebar item hover state (light blue highlight)
- [ ] 6.5 Update sidebar footer icons and styling
- [ ] 6.6 Test sidebar responsiveness (collapse on mobile)
- [ ] 6.7 Verify sidebar dark theme styling (solid backgrounds)

## 7. Layout Components - Navigation (Day 7)

- [ ] 7.1 Update top navigation bar styling to match landing website nav
- [ ] 7.2 Update navigation links with clean hover states
- [ ] 7.3 Update mobile navigation menu (hamburger, drawer)
- [ ] 7.4 Update breadcrumbs styling for clear hierarchy
- [ ] 7.5 Test navigation across all breakpoints
- [ ] 7.6 Verify navigation accessibility (keyboard, screen reader)

## 8. Layout Components - Modals & Overlays (Day 8)

- [ ] 8.1 Update modal container with clean white background
- [ ] 8.2 Update modal header with clear title typography
- [ ] 8.3 Update modal borders and shadows
- [ ] 8.4 Update backdrop overlay (subtle dark overlay)
- [ ] 8.5 Update confirmation dialogs, prompts, alerts
- [ ] 8.6 Test modal animations and transitions
- [ ] 8.7 Verify modal accessibility (focus trap, ESC key)

## 9. Page Components - Workspace Pages (Days 9-10)

- [ ] 9.1 Update workspace list page (card-based layout)
- [ ] 9.2 Update workspace chat interface
  - Message bubbles with clean styling
  - Input area with light background
  - Sidebar thread list
- [ ] 9.3 Update workspace settings pages
- [ ] 9.4 Update workspace document list (clean table or card layout)
- [ ] 9.5 Test workspace creation and deletion flows
- [ ] 9.6 Verify workspace responsive design

## 10. Page Components - Settings Pages (Days 11-12)

- [ ] 10.1 Update general settings pages (card-based sections)
- [ ] 10.2 Update LLM preference page styling
- [ ] 10.3 Update vector database settings page
- [ ] 10.4 Update user management pages (admin)
- [ ] 10.5 Update API keys page with clean card layout
- [ ] 10.6 Update branding settings page
- [ ] 10.7 Test all settings forms and validations

## 11. Page Components - Authentication (Day 12)

- [ ] 11.1 Update login page with clean professional styling
- [ ] 11.2 Update SSO login pages
- [ ] 11.3 Update onboarding flow with step indicators
- [ ] 11.4 Update password reset pages
- [ ] 11.5 Test authentication flows end-to-end

## 12. Visual QA & Testing (Days 13-14)

- [ ] 12.1 Cross-browser testing
  - [ ] Chrome (latest)
  - [ ] Firefox (latest)
  - [ ] Safari (latest)
  - [ ] Edge (latest)
- [ ] 12.2 Responsive design validation
  - [ ] Mobile (320px-480px)
  - [ ] Tablet (768px-1024px)
  - [ ] Desktop (1280px+)
- [ ] 12.3 Accessibility audit
  - [ ] Run axe-core automated checks
  - [ ] Manual keyboard navigation testing
  - [ ] Color contrast verification (WCAG AA: 4.5:1)
  - [ ] Screen reader testing (VoiceOver/NVDA)
- [ ] 12.4 Performance testing
  - [ ] Lighthouse performance score (>90)
  - [ ] CSS bundle size comparison
  - [ ] Paint times and layout shifts
- [ ] 12.5 Visual regression testing
  - [ ] Compare screenshots against baseline
  - [ ] Verify all pages match design spec
  - [ ] Check dark theme consistency

## 13. Polish & Refinements (Day 15)

- [ ] 13.1 Review all pages for visual consistency
- [ ] 13.2 Fix any visual bugs discovered in QA
- [ ] 13.3 Optimize CSS (remove unused styles, consolidate duplicates)
- [ ] 13.4 Update theme toggle UI if needed (make it prominent)
- [ ] 13.5 Add any missing hover states or transitions
- [ ] 13.6 Final cross-browser check

## 14. Documentation & Deployment (Day 16)

- [ ] 14.1 Update UI guidelines documentation
- [ ] 14.2 Document new color palette and theme variables
- [ ] 14.3 Update component examples (if Storybook exists)
- [ ] 14.4 Create migration notes for release
- [ ] 14.5 Deploy to staging environment
- [ ] 14.6 Conduct user acceptance testing (UAT) with stakeholders
- [ ] 14.7 Address UAT feedback
- [ ] 14.8 Deploy to production
- [ ] 14.9 Monitor analytics (theme preference distribution)
- [ ] 14.10 Monitor user feedback channels for issues

## Validation Criteria

### Visual Consistency
- ✅ All components match landing website design language
- ✅ Color palette exactly matches extracted values from https://mind.law
- ✅ Typography hierarchy is clear and professional
- ✅ White space and padding create comfortable layouts

### Functionality
- ✅ All existing features work without regression
- ✅ Theme toggle switches correctly between light and dark
- ✅ User theme preferences are preserved
- ✅ No console errors or warnings

### Accessibility
- ✅ WCAG AA contrast ratios met (4.5:1 for normal text, 3:1 for large text)
- ✅ Keyboard navigation works on all interactive elements
- ✅ Screen reader announces content correctly
- ✅ Focus states are visible and clear

### Performance
- ✅ Lighthouse performance score > 90
- ✅ CSS bundle size increase < 10%
- ✅ No layout shifts or paint delays
- ✅ Theme switching is instant (no flash)

### Cross-Platform
- ✅ Chrome, Firefox, Safari, Edge all render correctly
- ✅ Mobile (320px), tablet (768px), desktop (1280px+) responsive
- ✅ No horizontal scrolling on any breakpoint
- ✅ Touch targets are appropriately sized on mobile (44px minimum)

## Rollback Plan

If critical issues discovered:
- **Minor issue** (< 2 hours to fix): Deploy hotfix
- **Moderate issue** (2-8 hours): Revert specific component via Git
- **Critical issue** (> 8 hours): Full rollback to previous deployment
- **Emergency**: Add feature flag `REACT_APP_LEGACY_THEME=true` to revert to old theme
