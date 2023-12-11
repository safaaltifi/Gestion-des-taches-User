import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'traveaux_model.dart';

class ApiService {
  final String apiUrl = 'http://localhost:3000/users';
  final String apiUrl2 = 'http://localhost:3000/traveaux';


  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((ff) => User.fromJson(ff)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }


    Future<void> saveUsers(User newUser) async {
      try {
        // Only post the newUser
        await http.post(
          Uri.parse('$apiUrl'), // Change the URL as needed
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(newUser.toJson()), // Post only the newUser
        );
      } catch (e) {
        print('Error saving user data: $e');
        throw Exception('Failed to save users');
      }
    }

  Future<List<Traveaux>> getTraveaux() async {
    final response = await http.get(Uri.parse(apiUrl2));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((ff) => Traveaux.fromJson(ff)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Traveaux>> getTravauxForUser(int userId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/traveaux?idUtil=$userId'));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);

      return jsonResponse.map((travail) => Traveaux.fromJson(travail)).toList();
    } else {
      throw Exception('Failed to load travaux for user');
    }
  }

  Future<void> editTraveau(int travId, Traveaux editedTrav) async {
    try {
      print(travId);
      print(editedTrav);
      // Send a PUT request to update the data on the server.
      await http.put(
        Uri.parse('$apiUrl2/${travId.toString()}'), // Use the specific user ID
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(editedTrav.toJson()), // Only send the edited user
      );

    } catch (e) {
      print('Error editing traveau: $e');
      throw Exception('Failed to edit traveau');
    }
  }

  Future<void> deleteTrav(int travId) async {
    try {
      await http.delete(Uri.parse('$apiUrl2/$travId'));
    } catch (e) {
      print('Error deleting traveau: $e');
      throw Exception('Failed to delete traveau');
    }
  }
  }





