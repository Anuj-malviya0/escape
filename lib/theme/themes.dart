import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode thememode = ThemeMode.dark;
  bool get isdarkmode => thememode == ThemeMode.dark;
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromRGBO(250, 242, 235, 1),
  primaryColor: Colors.black,
  // fontFamily: "FontsFree",
  textTheme: const TextTheme(
    headline1: TextStyle(color: Color(0xff000000),fontFamily: "FontsFree"),
    headline2: TextStyle(color: Color(0xff000000),fontFamily: "FontsFree"),
    bodyText2: TextStyle(color: Color(0xff000000),fontFamily: "FontsFree"),
    subtitle1: TextStyle(color: Color(0xff000000),fontFamily: "FontsFree"),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xff171010),
  textTheme: const TextTheme(
    headline1: TextStyle(color: Color(0xffffffff),fontFamily: "FontsFree"),
    headline2: TextStyle(color: Color(0xffffffff),fontFamily: "FontsFree"),
    bodyText2: TextStyle(color: Color(0xffffffff),fontFamily: "FontsFree"),
    subtitle1: TextStyle(color: Color(0xffffffff),fontFamily: "FontsFree"),
  ),
);
