---
name: app-plan-creator
description: Guidelines and template for creating a structured development plan for macOS applications. Use this skill when asked to write or update an app development plan.
---

# App Plan Creator

This skill provides a structured approach to writing comprehensive development plans for macOS applications.

## How to Create an App Plan

When asked to write an app plan, follow this structure:

### 1. Executive Summary & Goal
Briefly describe what the application does, its core value proposition, and the main objective of the development cycle.

### 2. Architecture & Core Components
List the main technical pieces required:
- UI Layer (AppKit / SwiftUI)
- Background processes / Daemons
- System APIs (e.g., Accessibility, Quartz Event Services)
- Data Storage (UserDefaults, local files)

### 3. Development Phases (Milestones)
Break the project down into logical, incremental steps:
- **Phase 1: Proof of Concept (PoC) / Core Engine.** Focus on the hardest technical challenge.
- **Phase 2: MVP Features.** Implement basic user flows.
- **Phase 3: User Interface & Preferences.** Build settings, menus, and user interactions.
- **Phase 4: Polish & Packaging.** Handling permissions, auto-start, signing, and dmg creation.

### 4. Risks & Challenges
Identify potential technical roadblocks (e.g., Apple's strict privacy permissions, performance bottlenecks in keyloggers) and propose mitigations.

### 5. Definition of Done
Criteria for when the application is considered ready for the first release.
