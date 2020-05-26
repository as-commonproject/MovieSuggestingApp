import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviesapp/login_signup/index.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            accentColor: Color.fromRGBO(150, 150, 240, 1),
            primaryColor: Color.fromRGBO(43, 53, 125, 1),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'GoogleSans'
        ),
        darkTheme: ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(1, 1, 1, 1),
            accentColor: Color.fromRGBO(150, 150, 240, 1),//Color.fromRGBO(253, 1, 86, 1),
            brightness: Brightness.dark,
            fontFamily: 'Quicksand'
        ),
        home: Index()
    );
  }
}
