class ToDo {
  String? id;
  String? todoText;
  int? priority;
  String? todoSubText;

  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.priority = 1,
    required this.todoSubText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      // ToDo(
      //     id: "1",
      //     todoText: "Add to do using +",
      //     todoSubText: "try clicking +",
      //     priority:1),
      // ToDo(
      //     id: "2",
      //     todoText: "Mark them done",
      //     todoSubText: "try clicking the box",
      //     priority:2),
      // ToDo(
      //     id: "3",
      //     todoText: "Delete the task",
      //     todoSubText: "try clicking delete icon",
      //     priority:3)
    ];
  }

  toJson() {
    return {
      "id": id,
      "todoSubText": todoSubText,
      "todoText": todoText,
      "isDone": isDone,
      "priority": priority
    };
  }

  static fromJson(jsonData) {
    return ToDo(
        id: jsonData['id'],
        todoText: jsonData['todoText'],
        todoSubText: jsonData['todoSubText'],
        priority: jsonData['priority'],
        isDone: jsonData['isDone']);
  }
}
