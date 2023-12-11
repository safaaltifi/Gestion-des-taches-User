import 'package:flutter/material.dart';
import 'login_page.dart'; // Importe la page d'authentification
import 'showusers.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Démarre avec la page d'authentification
    );
  }
}
