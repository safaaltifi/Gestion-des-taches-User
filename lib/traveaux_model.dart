class Traveaux {
  final int id;
  late final String titre;
  late final String desc;
  final String type;
  final String position;
  final int idUtil;
  final Remarque remarque;

  Traveaux({
    required this.id,
    required this.titre,
    required this.desc,
    required this.type,
    required this.position,
    required this.idUtil,
    required this.remarque,
  });
  // CopyWith method to create a new Traveaux object with updated fields
  Traveaux copyWith({
    int? id,
    String? titre,
    String? desc,
    String? type,
    String? position,
    int? idUtil,
    Remarque? remarque,
  }) {
    return Traveaux(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      desc: desc ?? this.desc,
      type: type ?? this.type,
      position: position ?? this.position,
      idUtil: idUtil ?? this.idUtil,
      remarque: remarque ?? this.remarque,
    );
  }

  factory Traveaux.fromJson(Map<String, dynamic> json) {
    return Traveaux(
      id: json['id'],
      titre: json['titre'],
      desc: json['desc'],
      type: json['type'],
      position: json['position'],
      idUtil: json['idUtil'],
      remarque: Remarque.fromJson(json['remarque']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'desc': desc,
      'type': type,
      'position': position,
      'idUtil': idUtil,
      'remarque': remarque.toJson(),

    };
  }
}

class Remarque {
  final String desc;
  final List<String> photos;
  final String position;

  Remarque({
    required this.desc,
    required this.photos,
    required this.position,
  });

  factory Remarque.fromJson(Map<String, dynamic> json) {
    return Remarque(
      desc: json['desc'],
      photos: List<String>.from(json['photos']),
      position: json['position'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'photos': List<dynamic>.from(photos),
      'position': position,
    };
  }
}