// page.dart
import 'package:devoir1/user_model.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class ShowUsers extends StatefulWidget {
  @override
  _ShowUserState createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUsers> {
  final ApiService apiService = ApiService();
  final TextEditingController identifiantController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Example'),
      ),
      body: FutureBuilder<List<User>>(
        future: apiService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].identifiant),
                  subtitle: Text(users[index].nom),
                );
              },
            );
          }
        },
      ),
    );
  }
}
