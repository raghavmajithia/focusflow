# Mobile surface

The mobile surface is a capture-first companion built with Jac's `@jac/mobui` primitives. It loads, creates, and completes persistent tasks through the same `get_tasks`, `add_task`, and `complete_task` functions used by the web app and CLI.

From the repository root, run this one time to generate the native project and install the browser-side React Native compatibility packages:

```bash
jac setup mobile
jac install --npm
```

Start the shared server in one terminal:

```bash
jac run
```

In another terminal, launch the native mobile app and point it at the shared API on port 8001:

```bash
JAC_CLIENT_API_BASE_URL=http://<device-reachable-host>:8001 jac run --dev mobile
```

Use `localhost` for an iOS simulator, `10.0.2.2` for the standard Android emulator, or the computer's LAN IP for a physical device. Android and iOS builds require their respective platform tools. The mobile screen loads, adds, and completes tasks through the same public functions in `main.jac` as the web app and CLI.

To build the browser target, run `jac build --platform web mobile`. A live browser preview uses a different origin from the shared API; with the current Jac server CORS allowlist, its API calls are blocked by the `x-jac-endpoint` preflight header. The native workflow above avoids that browser-only restriction.
