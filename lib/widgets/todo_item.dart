// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onToDoChanged,
      required this.onDeleteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        tileColor: (todo.priority == 0)
            ? Color.fromRGBO(35, 48, 56, 1)
            : (todo.priority == 1)
                ? Color.fromRGBO(144, 103, 198, 1)
                : (todo.priority == 2)
                    ? Color.fromRGBO(141, 134, 201, 1)
                    : Color.fromRGBO(202, 196, 206, 1),
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.white,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              decorationThickness: 3.0),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(2)),
          child: Container(
            child: IconButton(
                onPressed: () {
                  // print('clicked on delete');
                  onDeleteItem(todo.id);
                },
                icon: Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.white,
                )),
          ),
        ),
        subtitle: Text(
          todo.todoSubText!,
          style: TextStyle(color: Colors.white,decoration: todo.isDone ? TextDecoration.lineThrough : null,
              decorationThickness: 3.0),
          
        ),
      ),
    );
  }
}
