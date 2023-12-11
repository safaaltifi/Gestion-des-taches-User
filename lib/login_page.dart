import 'package:devoir1/showtraveaux.dart';
import 'package:devoir1/traveaux_model.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'api_service.dart';
import 'showusers.dart';
import 'showtraveaux.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late ApiService apiService; // Declare apiService at the class level

  @override
  void initState() {
    super.initState();
    apiService = ApiService(); // Initialize apiService in initState
  }
  Future<void> _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Fetch users from the API
    try {
      List<User> users = await apiService.getUsers();

      // Check if the entered username and password match any user in the list
      bool isUserValid = users.any((user) =>
      user.identifiant == username && user.mdp == password);

      User? loggedInUser = users.firstWhere(
            (user) => user.identifiant == username && user.mdp == password,
        orElse: () => null!,
      );

      if (isUserValid && loggedInUser != null) {
        // Successful login
        print('Login successful!');

        // Fetch travaux for the logged-in user
        List<Traveaux> userTravaux = await apiService.getTravauxForUser(loggedInUser.id);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowTraveaux(
            identifiant: loggedInUser.identifiant,
            mdp: loggedInUser.mdp,
            travauxList: userTravaux,
          ),
          ),
        );
      } else {
        // Invalid credentials
        print('Invalid username or password');
      }
    } catch (error) {
      // Handle error during API call
      print('Error fetching users: $error');
    }
  }

  Future<void> _handleRegistration() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    // Fetch users from the API
    List<User> users = await apiService.getUsers();


    // Check if the username already exists
    bool isUsernameTaken = users.any((user) => user.identifiant == username);

    if (isUsernameTaken) {
      // Username already exists, display an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Username Taken'),
            content: Text('The username is already taken. Choose another username.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      User.adjustNextId(users);
      // Username is available, proceed with registration
      User newUser = User.createNewUser(
        nom: 'NewUser',
        prenom: 'NewUser',
        identifiant: username,
        mdp: password,
      );

      // Add the new user to the list
      users.add(newUser);

      try {
        // Save the updated list to the API
        await apiService.saveUsers(newUser);
        print('Registration successful for $username');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowUsers()),
        );
      } catch (e) {
        // Handle the error (e.g., display an error message)
        print('Error during registration: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleRegistration,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

// class _LoginPageState extends State<LoginPage> {
//   final ApiService apiService = ApiService();
//   final TextEditingController identifiantController = TextEditingController();
//   final TextEditingController mdpController = TextEditingController();


  // @override
  // Widget build(BuildContext context) {
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Post Example'),
  //     ),
  //     body: FutureBuilder<List<User>>(
  //       future: apiService.getUsers(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return CircularProgressIndicator();
  //         } else if (snapshot.hasError) {
  //           return Text('Error: ${snapshot.error}');
  //         } else {
  //           List<User> posts = snapshot.data!;
  //           return ListView.builder(
  //             itemCount: posts.length,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title: Text(posts[index].identifiant),
  //                 subtitle: Text(posts[index].nom),
  //               );
  //             },
  //           );
  //         }
  //       },
  //     ),
  //
  //
  //   );
  // }


  // void _login(BuildContext context) async {
  //  // List<User> users = []; // Or whatever default value makes sense in your case
  //
  //   print("hello askima");
  //   try {
  //     // Assuming apiService.getUsers() returns a Future<List<User>>
  //     List<User> users = await apiService.getUsers();
  //     print(users);
  //   } catch (e) {
  //     // Handle exceptions
  //     print('Error fetching users: $e');
  //   }
  //   print("0000");
  // }

//   final List<User> userList = await users!;
  //   final String enteredIdentifiant = identifiantController.text;
  //   final String enteredMdp = mdpController.text;
  //
  //   final User? user = userList.firstWhere(
  //         (user) => user.identifiant == enteredIdentifiant && user.mdp == enteredMdp,
  //     orElse: () => null!,
  //   );
  //
  //   if (user != null) {
  //     // Naviguer vers une autre page
  //     // Tu peux utiliser Navigator.push() pour cela
  //     print('Utilisateur connecté: ${user.nom} ${user.prenom}');
  //   } else {
  //     // Afficher un message d'erreur
  //     print('Identifiants invalides');
  //   }
  // }

