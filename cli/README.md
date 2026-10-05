# CLI surface

The Jac CLI entrypoint is `cli/main.jac`. Start the web app in one terminal, then point the CLI bridge at its API:

```bash
jac run web
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac today
```

The CLI calls the shared `add_task`, `get_tasks`, and `complete_task` functions in `main.jac`. `add` creates a Personal/steady task, `today` lists tasks with completion markers, and `done` completes the exact matching title:

```bash
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac add "Read chapter 4"
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac today
JAC_APP_WEB_URL=http://localhost:8001 jac run cli/main.jac done "Read chapter 4"
```
