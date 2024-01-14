import 'package:flutter/material.dart';
import 'login.dart';
import 'package:to_do_mobile_programming/task/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  notificationManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
        ),
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
