import from "@jac/mobui" { Text, Pressable, TextInput, ScrollView, StyleSheet, View }
import from ..main { Task, add_task, get_tasks, complete_task }

glob styles = StyleSheet.create({
    screen: {flex: 1, backgroundColor: "#f5f2ea", padding: 24, gap: 16},
    title: {fontSize: 28, fontWeight: "bold", color: "#18312f"},
    summary: {fontSize: 14, color: "#52645e"},
    button: {padding: 14, backgroundColor: "#c05b3d", alignItems: "center"},
    buttonText: {color: "#fffdf8", fontWeight: "bold"},
    sectionTitle: {fontSize: 18, fontWeight: "bold", color: "#18312f", marginTop: 12},
    taskRow: {flexDirection: "row", alignItems: "center", justifyContent: "space-between", gap: 12, paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: "#d3d6ca"},
    taskCopy: {flex: 1, gap: 4},
    taskTitle: {fontSize: 16, color: "#18312f"},
    taskMeta: {fontSize: 12, color: "#61736b"},
    doneButton: {paddingVertical: 9, paddingHorizontal: 12, backgroundColor: "#18312f"},
    doneButtonText: {color: "#fffdf8", fontSize: 12, fontWeight: "bold"},
    completed: {color: "#61736b", fontSize: 12},
    empty: {paddingVertical: 16, color: "#61736b"}
});

def:pub app -> JsxElement {
    has title: str = "";
    has tasks: list[Task] = [];

    async can with entry {
        tasks = await get_tasks();
    }

    async def add {
        if title.strip() {
            await add_task(title.strip(), "Personal", "steady");
            title = "";
            tasks = await get_tasks();
        }
    }

    async def finish_task(task_title: str) {
        await complete_task(task_title);
        tasks = await get_tasks();
    }

    return <ScrollView style={styles.screen}>
        <Text style={styles.title}>FocusFlow</Text>
        <Text>Capture the next useful thing while you are moving.</Text>
        <TextInput value={title} placeholder="Add a task" onChangeText={lambda (text: str) { title = text; }} />
        <Pressable style={styles.button} onPress={add}>
            <Text style={styles.buttonText}>Add task</Text>
        </Pressable>
        <Text style={styles.summary}>{len([task for task in tasks if not task.done])} open / {len(tasks)} total</Text>
        <Text style={styles.sectionTitle}>Today</Text>
        {[<View key={task_entry[0]} style={styles.taskRow}>
            <View style={styles.taskCopy}>
                <Text style={styles.taskTitle}>{task_entry[1].title}</Text>
                <Text style={styles.taskMeta}>{task_entry[1].area} / {task_entry[1].priority}</Text>
            </View>
            {<Pressable style={styles.doneButton} onPress={lambda (event: any) { finish_task(task_entry[1].title); }}>
                <Text style={styles.doneButtonText}>Done</Text>
            </Pressable> if not task_entry[1].done else <Text style={styles.completed}>Completed</Text>}
        </View> for task_entry in enumerate(tasks)]}
        {<Text style={styles.empty}>No tasks yet. Capture one small next step.</Text> if len(tasks) == 0 else None}
    </ScrollView>;
}
