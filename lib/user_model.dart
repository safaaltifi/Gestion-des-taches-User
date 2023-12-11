class User {

  final int id;
  final String nom;
  final String prenom;
  final String identifiant;
  final String mdp;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.identifiant,
    required this.mdp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['Nom'],
      prenom: json['prenom'],
      identifiant: json['identifiant'],
      mdp: json['mdp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Nom': nom,
      'prenom': prenom,
      'identifiant': identifiant,
      'mdp': mdp,
    };
  }

  static int _nextId = 0; // Initialize _nextId to 1

  static User createNewUser({
    required String nom,
    required String prenom,
    required String identifiant,
    required String mdp,
  }) {
    // Create a new user with the next available ID
    User newUser = User(
      id: _nextId,
      nom: nom,
      prenom: prenom,
      identifiant: identifiant,
      mdp: mdp,
    );

    // Increment the next available ID for the next user
    _nextId++;

    return newUser;
  }

  static void adjustNextId(List<User> users) {
    if (users.isNotEmpty) {
      // Find the maximum id value among the existing users
      int maxId = users.map((user) => user.id).reduce((value, element) => value > element ? value : element);

      // Set the nextId to be one greater than the maximum id
      _nextId = maxId + 1;
    }
  }
}
