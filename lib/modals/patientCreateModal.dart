// lib/models/patient_create.dart

class PatientCreate {
  final String? email;
  final String? name;
  final String? adress;       // spelled 'adress' to match your backend
  final String? birthdate;   // optional
  final String? phoneNumber; // optional
  final int? calories;
  final int? frequenceCardiaque;
  final int? poids;
  final String? password;

  PatientCreate({
    this.email,
    this.name,
    this.adress,
    this.birthdate,
    this.phoneNumber,
    this.calories,
    this.frequenceCardiaque,
    this.poids,
    this.password,
  });

  // Convert from JSON
  factory PatientCreate.fromJson(Map<String, dynamic> json) {
    return PatientCreate(
      email: json['email'] as String?,
      name: json['name']as String?,
      adress: json['adress']as String?,
      birthdate: json['birthdate'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      calories: json['calories'] as int?,
      frequenceCardiaque: json['frequenceCardiaque']as int?,
      poids: json['poids'] as int?,
      password: json['password']as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'adress': adress,
      'birthdate': birthdate,
      'phoneNumber': phoneNumber,
      'calories': calories,
      'frequenceCardiaque': frequenceCardiaque,
      'poids': poids,
      'password': password,
    };
  }
}
