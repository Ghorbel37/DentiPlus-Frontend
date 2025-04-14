// lib/models/symptoms.dart
import 'consultationModal.dart';

class Symptoms {
  final int? id;
  final String? symptom;
  final int? userId;
  final int? consultationId;
  final Consultation? consultation;

  Symptoms({
    this.id,
    this.symptom,
    this.userId,
    this.consultationId,
    this.consultation,
  });

  factory Symptoms.fromJson(Map<String, dynamic> json) {
    return Symptoms(
      id: json['id'] as int?,
      symptom: json['symptom'] as String?,
      userId: json['user_id'] as int?,
      consultationId: json['consultation_id'] as int?,
      consultation: json['consultation'] != null
          ? Consultation.fromJson(json['consultation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symptom': symptom,
      'user_id': userId,
      'consultation_id': consultationId,
      'consultation': consultation?.toJson(),
    };
  }
}
