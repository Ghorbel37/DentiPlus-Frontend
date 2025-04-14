// lib/models/hypothese.dart
import 'consultationModal.dart';

class Hypothese {
  final int? id;
  final String? condition;
  final int? confidence;
  final int? consultationId;
  final Consultation? consultation;

  Hypothese({
    this.id,
    this.condition,
    this.confidence,
    this.consultationId,
    this.consultation,
  });

  factory Hypothese.fromJson(Map<String, dynamic> json) {
    return Hypothese(
      id: json['id'] as int?,
      condition: json['condition'] as String?,
      confidence: json['confidence'] as int?,
      consultationId: json['consultation_id'] as int?,
      consultation: json['consultation'] != null
          ? Consultation.fromJson(json['consultation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'condition': condition,
      'confidence': confidence,
      'consultation_id': consultationId,
      'consultation': consultation?.toJson(),
    };
  }
}
