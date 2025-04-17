// lib/models/patient_create.dart

class PatientCreate {
  final int? id;
  final String? email;
  final String? name;
  final String? adress; // spelled 'adress' to match your backend
  final String? birthdate; // optional
  final String? phoneNumber; // optional
  final int? calories;
  final int? frequenceCardiaque;
  final int? poids;
  final String? password;
  final String? role;
  final String? profilePhoto;

  PatientCreate({
    this.id,
    this.email,
    this.name,
    this.adress,
    this.birthdate,
    this.phoneNumber,
    this.calories,
    this.frequenceCardiaque,
    this.poids,
    this.password,
    this.role,
    this.profilePhoto,
  });

  PatientCreate copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? adress,
    String? birthdate,
    String? phoneNumber,
    int? calories,
    int? frequenceCardiaque,
    int? poids,
    String? profilePhoto,
  }) {
    return PatientCreate(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      adress: adress ?? this.adress,
      birthdate: birthdate ?? this.birthdate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      calories: calories ?? this.calories,
      frequenceCardiaque: frequenceCardiaque ?? this.frequenceCardiaque,
      poids: poids ?? this.poids,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  // Convert from JSON
  factory PatientCreate.fromJson(Map<String, dynamic> json) {
    return PatientCreate(
      id: json['id'] as int?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      adress: json['adress'] as String?,
      birthdate: json['birthdate'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      calories: json['calories'] as int?,
      frequenceCardiaque: json['frequenceCardiaque'] as int?,
      poids: json['poids'] as int?,
      password: json['password'] as String?,
      role: json['role'] as String?,
      profilePhoto: json['profile_photo'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'adress': adress,
      'birthdate': birthdate,
      'phoneNumber': phoneNumber,
      'calories': calories,
      'frequenceCardiaque': frequenceCardiaque,
      'poids': poids,
      'password': password,
      'role': role,
      'profile_photo': profilePhoto,
    };
  }
}
