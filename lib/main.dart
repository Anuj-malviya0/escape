// ignore: unused_import
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'theme/themes.dart';
import 'package:provider/provider.dart';
import 'screens/setting.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ToDo app",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeModel>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: Home(),
    );
  }
}
