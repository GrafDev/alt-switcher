# macOS Application Development (AltSwitcher)

## Architecture & Frameworks
- **Language:** Swift 5/6
- **UI:** AppKit (for `NSStatusItem` in the Menu Bar and hidden dock icon via `LSUIElement`) and SwiftUI (for the Preferences window).

## Core Functionality Requirements
1. **Global Keystroke Interception:**
   - Use Quartz Event Services (`CGEventTapCreate`).
   - Listen for keyboard events system-wide before they reach other applications.

2. **Layout Management:**
   - Use Text Input Source Services (Carbon).
   - Switch layouts using `TISSelectInputSource`.

3. **Keystroke Simulation:**
   - Generate `Backspace` events to delete the incorrectly typed word.
   - Generate keystrokes to type the correctly mapped word.
   - Use `CGEventCreateKeyboardEvent` and `CGEventPost`.

4. **Permissions:**
   - Prompt user for Accessibility (`AXIsProcessTrustedWithOptions`) and Input Monitoring permissions on startup.

## Development Steps
1. Create a macOS App project without a main window.
2. Implement the Accessibility permissions request flow.
3. Write the `CGEventTap` listener to capture and log characters to an in-memory ring buffer.
4. Implement language mapping (e.g., Russian -> English and vice versa based on QWERTY/ЙЦУКЕН).
5. Implement manual replacement (triggering sequence on a specific hotkey).
6. Implement the UI (Preferences) for whitelisting/blacklisting apps and toggling auto-switch.
