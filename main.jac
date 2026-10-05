node Task {
    has title: str;
    has area: str = "Personal";
    has priority: str = "steady";
    has due: str = "Today";
    has done: bool = False;
}

def:pub add_task(title: str, area: str = "Personal", priority: str = "steady") -> Task {
    task = Task(title=title, area=area, priority=priority);
    root ++> task;
    return task;
}

def:pub get_tasks -> list[Task] {
    return [root-->][?:Task];
}

def:pub complete_task(title: str) -> bool {
    for task in [root-->][?:Task] {
        if task.title == title {
            task.done = True;
            return True;
        }
    }
    return False;
}

def:pub clear_completed -> int {
    cleared = 0;
    for task in [root-->][?:Task] {
        if task.done {
            cleared += 1;
        }
    }
    return cleared;
}

glob web_styles = {
    "page": {
        "minHeight": "100vh", "margin": "-8px",
        "padding": "32px clamp(20px, 5vw, 72px) 56px",
        "boxSizing": "border-box", "backgroundColor": "#f3f0e7",
        "color": "#183b35", "fontFamily": "Georgia, 'Times New Roman', serif",
    },
    "header": {
        "maxWidth": "1100px", "margin": "0 auto 48px", "paddingBottom": "20px",
        "borderBottom": "1px solid #c9c9b9", "display": "flex",
        "justifyContent": "space-between", "alignItems": "center", "gap": "16px",
        "fontFamily": "'Avenir Next', Avenir, sans-serif",
    },
    "brand": {"fontSize": "15px", "fontWeight": "700", "letterSpacing": "0"},
    "header_note": {"fontSize": "13px", "color": "#61736b"},
    "shell": {
        "maxWidth": "1100px", "margin": "0 auto", "display": "grid",
        "gridTemplateColumns": "repeat(auto-fit, minmax(min(100%, 330px), 1fr))",
        "gap": "clamp(28px, 6vw, 76px)", "alignItems": "start",
    },
    "eyebrow": {
        "margin": "0 0 12px", "color": "#a64f36",
        "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "12px",
        "fontWeight": "700", "letterSpacing": "0", "textTransform": "uppercase",
    },
    "title": {"margin": "0", "fontSize": "48px", "lineHeight": "1.05", "fontWeight": "400"},
    "intro": {"maxWidth": "500px", "margin": "18px 0 36px", "color": "#61736b", "fontSize": "18px", "lineHeight": "1.55"},
    "section_heading": {
        "display": "flex", "justifyContent": "space-between", "alignItems": "baseline",
        "gap": "12px", "margin": "0 0 14px", "paddingBottom": "12px",
        "borderBottom": "2px solid #183b35",
    },
    "section_title": {"margin": "0", "fontSize": "25px", "fontWeight": "400"},
    "count": {"color": "#61736b", "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "13px"},
    "task_list": {"margin": "0", "padding": "0", "listStyle": "none"},
    "task": {
        "display": "flex", "justifyContent": "space-between", "alignItems": "center",
        "gap": "16px", "padding": "18px 0", "borderBottom": "1px solid #d5d5c8",
    },
    "task_title": {"margin": "0 0 6px", "fontSize": "17px", "overflowWrap": "anywhere"},
    "task_meta": {"margin": "0", "color": "#61736b", "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "12px"},
    "complete_button": {
        "flexShrink": "0", "border": "1px solid #183b35", "borderRadius": "2px",
        "padding": "9px 12px", "backgroundColor": "transparent", "color": "#183b35",
        "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "12px", "cursor": "pointer",
    },
    "completed": {"color": "#61736b", "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "12px"},
    "form_panel": {
        "padding": "26px", "border": "1px solid #d5d5c8", "borderTop": "4px solid #a64f36",
        "backgroundColor": "#faf9f4",
    },
    "form_title": {"margin": "0 0 8px", "fontSize": "25px", "fontWeight": "400"},
    "form_note": {"margin": "0 0 22px", "color": "#61736b", "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "13px", "lineHeight": "1.5"},
    "field_label": {"display": "block", "margin": "16px 0 7px", "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "12px", "fontWeight": "700"},
    "input": {
        "width": "100%", "boxSizing": "border-box", "minHeight": "44px",
        "border": "1px solid #aeb8ac", "borderRadius": "2px", "padding": "10px 12px",
        "backgroundColor": "#fff", "color": "#183b35",
        "fontFamily": "'Avenir Next', Avenir, sans-serif", "fontSize": "14px",
    },
    "form_row": {"display": "grid", "gridTemplateColumns": "1fr 1fr", "gap": "12px"},
    "add_button": {
        "width": "100%", "minHeight": "46px", "marginTop": "22px", "border": "0",
        "borderRadius": "2px", "padding": "12px 16px", "backgroundColor": "#183b35",
        "color": "#fffdf8", "fontFamily": "'Avenir Next', Avenir, sans-serif",
        "fontSize": "14px", "fontWeight": "700", "cursor": "pointer",
    },
    "empty": {"padding": "24px 0", "color": "#61736b", "fontSize": "15px"},
};

def:pub app() -> JsxElement {
    has tasks: list[Task] = [];
    has title: str = "";
    has area: str = "Coursework";
    has priority: str = "steady";

    async can with entry {
        tasks = await get_tasks();
    }

    async def add {
        if title.strip() {
            await add_task(title.strip(), area, priority);
            title = "";
            tasks = await get_tasks();
        }
    }

    async def complete(event: any) -> None {
        await complete_task(event.currentTarget.dataset.title);
        tasks = await get_tasks();
    }

    open_count = len([task for task in tasks if not task.done]);

    return <main style={web_styles["page"]}>
        <header style={web_styles["header"]}>
            <span style={web_styles["brand"]}>FOCUSFLOW / PERSONAL PLANNER</span>
            <span style={web_styles["header_note"]}>A little more room to think.</span>
        </header>
        <div style={web_styles["shell"]}>
            <section>
                <p style={web_styles["eyebrow"]}>Your planning desk</p>
                <h1 style={web_styles["title"]}>Make room for what matters.</h1>
                <p style={web_styles["intro"]}>Keep the next useful action close. Add a task, give it a place, and move on with your day.</p>
                <div style={web_styles["section_heading"]}>
                    <h2 style={web_styles["section_title"]}>Today</h2>
                    <span style={web_styles["count"]}>{open_count} open / {len(tasks)} total</span>
                </div>
                <ul style={web_styles["task_list"]}>
                    {[<li key={task_entry[0]} style={web_styles["task"]}>
                        <div>
                            <p style={web_styles["task_title"]}>{task_entry[1].title}</p>
                            <p style={web_styles["task_meta"]}>{task_entry[1].area} / {task_entry[1].priority}</p>
                        </div>
                        {<span style={web_styles["completed"]}>Completed</span> if task_entry[1].done else <button style={web_styles["complete_button"]} data-title={task_entry[1].title} onClick={complete}>Mark done</button>}
                    </li> for task_entry in enumerate(tasks)]}
                    {<li style={web_styles["empty"]}>Nothing on the list yet. Add one small next step.</li> if len(tasks) == 0 else None}
                </ul>
            </section>
            <section style={web_styles["form_panel"]}>
                <p style={web_styles["eyebrow"]}>Quick capture</p>
                <h2 style={web_styles["form_title"]}>Add a task</h2>
                <p style={web_styles["form_note"]}>Keep it concrete and small enough to start.</p>
                <label style={web_styles["field_label"]} htmlFor="task-title">What needs doing?</label>
                <input id="task-title" style={web_styles["input"]} value={title} onChange={lambda (event: any) { title = event.target.value; }} placeholder="e.g. Outline lab report" />
                <div style={web_styles["form_row"]}>
                    <div>
                        <label style={web_styles["field_label"]} htmlFor="task-area">Area</label>
                        <select id="task-area" style={web_styles["input"]} value={area} onChange={lambda (event: any) { area = event.target.value; }}><option>Coursework</option><option>Personal</option><option>Health</option><option>Work</option></select>
                    </div>
                    <div>
                        <label style={web_styles["field_label"]} htmlFor="task-priority">Priority</label>
                        <select id="task-priority" style={web_styles["input"]} value={priority} onChange={lambda (event: any) { priority = event.target.value; }}><option value="urgent">Urgent</option><option value="steady">Steady</option><option value="whenever">Whenever</option></select>
                    </div>
                </div>
                <button style={web_styles["add_button"]} onClick={add}>Add to today</button>
            </section>
        </div>
    </main>;
}
