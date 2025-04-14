// lib/models/doctor.dart
import 'userModal.dart';

class Doctor {
  final int? id;
  final String? description;
  final double? rating;
  final User? user;

  Doctor({
    this.id,
    this.description,
    this.rating,
    this.user,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int?,
      description: json['description'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'rating': rating,
      'user': user?.toJson(),
    };
  }
}
