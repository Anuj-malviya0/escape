// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'dart:convert';
import '/model/page_transition.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';


var list = [
  'Urgent & Important',
  'Urgent not Important',
  'Important not Urgent',
  'not Urgent not Important',
];
String dropdownValue = list.first;
Color accent = Color(0xff423F3E);

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences? prefs;
  final _textFieldController1 = TextEditingController();
  final _textFieldController2 = TextEditingController();

  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  bool _showContent = false;
  setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    String? stringTodo = prefs!.getString('todo');
    List todoList = jsonDecode(stringTodo!);
    for (var todo in todoList) {
      setState(() {
        _foundToDo.add(ToDo.fromJson(todo));
      });
    }
  }

  void saveTodo() {
    List items = _foundToDo.map((e) => e.toJson()).toList();
    prefs!.setString('todo', jsonEncode(items));
  }
  Future<void> _checkFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
    if (isFirstOpen) {
      setState(() {
        _showContent = true;
        todosList.add(ToDo(
          id: "1",
          todoText: "Add to do using +",
          todoSubText: "try clicking +",
          priority:1)
        );
        todosList.add(ToDo(
          id: "2",
          todoText: "Mark them done",
          todoSubText: "try clicking the box",
          priority:2));
        todosList.add(ToDo(
          id: "3",
          todoText: "Delete the task",
          todoSubText: "try clicking delete icon",
          priority:3));
      });
      await prefs.setBool('isFirstOpen', false);
    }
  }

final ConfettiController _controller =
      ConfettiController(duration: const Duration(seconds: 2));
final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _foundToDo = todosList;
    setupTodo();
    _checkFirstOpen();
    super.initState();
  }
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Color back = Color.fromRGBO(250, 242, 235, 1);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false, //to fix the Floating Acton button
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: (Theme.of(context).brightness == Brightness.dark)
                ? accent
                : Colors.white,
            elevation: 0,
            child: Icon(
              Icons.add,
              color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.white
                  : accent,
            ),
            onPressed: () async {
              dropdownValue = list.first;
              _showTextInputDialog(context);
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.white
                  : accent,
            notchMargin: 4.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.transparent,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // backgroundColor: back,
          appBar: _buildappbar(),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    searchbox(),
                    ConfettiWidget(
                                      confettiController: _controller,
                                      blastDirectionality: BlastDirectionality.explosive,
                                      colors: [
                                        Colors.green[400]!,
                                        Colors.red[400]!,
                                        Colors.blue,
                                        Colors.yellow,
                                        Colors.orange
                                      ],
                                      numberOfParticles: 30,
                                      minBlastForce: 10,
                                      maxBlastForce: 20,
                                      emissionFrequency: 0.001,
                                      gravity: .5,
                                      createParticlePath: (size) {
                                        final path = Path();
                                        path.addOval(Rect.fromCircle(center: Offset.zero, radius: 7));
                                        return path;
                                      },
                                      
                                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50, bottom: 20),
                            child: Text(
                              "To Do",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          ),
                          for (ToDo todoo in _foundToDo.reversed)
                            ToDoItem(
                              todo: todoo,
                              onToDoChanged: _handleToDoChange,
                              onDeleteItem: _deleteToDoItem,
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      saveTodo();
    });
    if(todo.isDone){
    setState(() {
                  _controller.play();
                });
                // Stop the confetti after 5 seconds
                Timer(const Duration(seconds: 1), () {
                  setState(() {
                    _controller.stop();
                  });
                });
  }
}
  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      saveTodo();
    });
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _addToDoItem(String toDo, String todosub, String prior) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
        todoSubText: todosub,
        priority: (prior == 'Urgent & Important')
            ? 0
            : (prior == 'Urgent not Important')
                ? 1
                : (prior == 'Important not Urgent')
                    ? 2
                    : 3,
      ));
    });
    saveTodo();
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('TODO',style:TextStyle(fontFamily: "PlayfairDisplay",fontWeight:FontWeight.w600),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [DropdownButtonExample()],
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                    if (value == null || value.isEmpty || value == " ") {
                      return "Title can't be empty";
                    }
                    return null;
                  },
                    style: TextStyle(color: (Theme.of(context).brightness == Brightness.dark)
                    ? Colors.white
                    : accent,),
                    controller: _textFieldController1,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Title",
                        hintStyle:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                    
                  ),
                ),
                TextField(
                   style: TextStyle(color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.white
                  : accent,),
                  maxLines: 2,
                  controller: _textFieldController2,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                      hintStyle:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Cancel"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          Navigator.pop(context);
                          _textFieldController1.clear();
                          _textFieldController2.clear();
                        },
                      ),
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Add'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {if (_formKey.currentState!.validate()) {
                      _addToDoItem(_textFieldController1.text,
                              _textFieldController2.text, dropdownValue);
                          _textFieldController1.clear();

                          _textFieldController2.clear();
                          Navigator.pop(context);
                    }
                          
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget searchbox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: (Theme.of(context).brightness == Brightness.dark)
              ? Colors.white
              : accent,
          borderRadius: BorderRadius.circular(25)),
      child: TextField(
          autofocus: false,
          onChanged: (value) => _runFilter(value),
          // keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? accent
                    : Colors.black,
                size: 20,
              ),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: 20, minWidth: 25),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.grey[500]))),
    );
  }

  AppBar _buildappbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: (Theme.of(context).brightness == Brightness.dark)? Brightness.dark: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color:Colors.transparent,
          size: 30,
        ),
        IconButton(
            onPressed: () {

              Navigator.of(context).push(FadedSlidePageRoute(page: SettingsPage(
                    themeModel: Provider.of<ThemeModel>(context, listen: false),), direction: true));
            },
            icon: Icon(
              Icons.settings,
              color: (Theme.of(context).brightness == Brightness.dark)
                  ? accent
                  : Colors.white,
              size: 30,
            ))
      ]),
      elevation: 0,
      backgroundColor: (Theme.of(context).brightness == Brightness.dark)
              ? Color.fromRGBO(250, 242, 235, 1)
              :  Color(0xff171010), //Colors.grey[350]
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      focusColor: Colors.transparent,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.white
                  : accent,),
            
          ),
        );
      }).toList(),
    );
  }
}
