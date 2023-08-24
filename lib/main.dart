import 'package:flutter/material.dart';
import 'LoadingScreen.dart';
import 'DataBase.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DataBase.instance.database;
  runApp(MyApp());
  
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}

