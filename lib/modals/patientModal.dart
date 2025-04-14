// lib/models/patient.dart
import 'package:denti_plus/modals/userModalRe.dart';

import 'userModal.dart';

class Patient {
  final int? id;
  final int? calories;
  final int? frequenceCardiaque;
  final int? poids;
  final UserRe? user;

  Patient({
    this.id,
    this.calories,
    this.frequenceCardiaque,
    this.poids,
    this.user,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as int?,
      calories: json['calories'] as int?,
      frequenceCardiaque: json['frequenceCardiaque'] as int?,
      poids: json['poids'] as int?,
      user: json['user'] != null ? UserRe.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calories': calories,
      'frequenceCardiaque': frequenceCardiaque,
      'poids': poids,
      'user': user?.toJson(),
    };
  }
}
