import sys;
import asyncio;
import from ..main { add_task, get_tasks, complete_task }

with entry {
    args = sys.argv[1:];
    command = args[0] if len(args) > 0 else "today";

    if command == "add" and len(args) > 1 {
        task = asyncio.run(add_task(" ".join(args[1:]), "Personal", "steady"));
        print(f"Added: {task.title}");
    } elif command == "done" and len(args) > 1 {
        completed = asyncio.run(complete_task(" ".join(args[1:])));
        print("Completed." if completed else "No matching task found.");
    } elif command == "today" {
        tasks = asyncio.run(get_tasks());
        for task in tasks {
            marker = "x" if task.done else " ";
            print(f"[{marker}] {task.title} ({task.area}, {task.priority})");
        }
    } else {
        print("Usage: jac run cli/main.jac add \"task\"");
        print("       jac run cli/main.jac today");
        print("       jac run cli/main.jac done \"task\"");
    }
}
