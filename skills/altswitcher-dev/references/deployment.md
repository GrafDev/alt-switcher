# Deployment and Release (AltSwitcher)

## Firebase Hosting Configuration
- **Project ID:** `altswitcher-fbf3e`
- **Domain:** `alt-switcher.web.app`

**Deployment Steps:**
1. Initialize Firebase in the website directory:
   ```bash
   firebase init hosting
   ```
2. Select the `altswitcher-fbf3e` project.
3. Configure the public directory (usually `dist` or the root folder depending on setup).
4. Deploy to production:
   ```bash
   firebase deploy --only hosting
   ```

## GitHub Repository Management
- **Repository URL:** `https://github.com/GrafDev/alt-switcher`

**Workflow Steps:**
1. Maintain separate branches for development (`dev`) and production (`main`).
2. **Releases:**
   - Create semantic version tags (e.g., `v1.0.0`) for every production release.
   - Attach the compiled macOS App (the `.dmg` file) to the GitHub Release.
3. **App Packaging:**
   - Use `create-dmg` or a custom bash script to package the compiled `.app` into a distributable `.dmg` format.
   - Code sign the app and notarize it with Apple before packaging to avoid Gatekeeper warnings on the user's end.

## CI/CD (Optional)
- Setup GitHub Actions to automatically run `firebase deploy` on pushes to the `main` branch.
- Setup GitHub Actions to build the macOS App and attach the `.dmg` to GitHub Releases when a new tag is pushed.
