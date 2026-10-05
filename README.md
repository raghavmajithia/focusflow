# FocusFlow

**Name:** Raghav Majithia
**UMID:** 72631531

FocusFlow is a personal planning workspace for coursework and life. Capture a task, give it an area and priority, review the day, and mark work complete from the web, mobile, or CLI surface.

## Prerequisites

- Jac 0.37 or newer
- For native mobile builds: the Android SDK or Xcode, depending on platform
- A terminal and a browser

Install Jac using the official installer, then confirm it is available:

```bash
jac --version
```

## Run the web app

From the repository root:

```bash
jac run
```

Open `http://localhost:8000/`.

The server and browser UI are compiled from `main.jac`. `Task` nodes are attached to `root`, so the Jac runtime persists them between sessions. The public functions `add_task`, `get_tasks`, and `complete_task` are the shared planning API.

For development hot reload:

```bash
jac run --dev
```

## Mobile app

The mobile surface is in `mobile/main.jac` and uses Jac's `@jac/mobui` components for quick capture, task review, and completion through the shared task API. Complete this one-time setup from the repository root:

```bash
jac setup mobile
jac install --npm
```

Keep the shared server running in one terminal:

```bash
jac run
```

Then start the native app in another terminal, pointing it at the computer running the shared server:

```bash
JAC_CLIENT_API_BASE_URL=http://<computer-LAN-IP>:8001 jac run --dev mobile
```

Use the host address reachable from the device: `localhost` for an iOS simulator, `10.0.2.2` for the standard Android emulator, or the computer's LAN IP for a physical phone. Native builds require the Android SDK or Xcode. `jac build --platform web mobile` builds the browser target; its separate dev-server origin currently hits a Jac CORS restriction for API calls, so use the native app for the complete mobile workflow. See [mobile/README.md](mobile/README.md) for details.

## CLI

The CLI is in `cli/main.jac`. Start the web app first because the CLI bridge calls its public API:

```bash
jac run web
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac today
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac add "Read chapter 4"
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac done "Read chapter 4"
```

These commands call the public functions in `main.jac`, preserving one source of truth for task data. See [cli/README.md](cli/README.md).

## Project shape

- `main.jac`: persistent graph model, server functions, and web app
- `mobile/main.jac`: mobile capture surface
- `cli/main.jac`: terminal surface
- `jac.toml`: default web entrypoint and mobile app registration
- `.github/copilot-instructions.md`: project-specific development rules

All three interfaces call the public functions in `main.jac`; `Task` nodes attached to `root` are the shared persisted source of truth. The web app offers task organization and review, mobile is designed for quick capture and completion, and the CLI provides fast terminal actions.

## What makes it stand out

FocusFlow keeps planning deliberately lightweight: one graph-backed task model powers three interfaces, while each interface supports a different moment in the workflow. The web app is the planning desk, mobile is the on-the-go companion, and the CLI is for quick terminal updates.

## Verification

All Jac app entrypoints pass:

```bash
jac check --app web
jac check --app mobile
jac check --app cli
```

To verify that the CLI uses the running web server, start `jac run` in one terminal, then use another:

```bash
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac add "Verify shared tasks"
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac today
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac done "Verify shared tasks"
```

Jac may emit non-blocking JSX and DOM typing warnings; each check should still finish with `1 passed`. Native mobile builds require the platform tools listed above.
