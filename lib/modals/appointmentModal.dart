// lib/models/appointment.dart
import 'enums.dart';
import 'consultationModal.dart';

class Appointment {
  final int? id;
  final DateTime? dateCreation;
  final DateTime? dateAppointment;
  final EtatAppointment? etat;
  final int? consultationId;
  final Consultation? consultation;

  Appointment({
    this.id,
    this.dateCreation,
    this.dateAppointment,
    this.etat,
    this.consultationId,
    this.consultation,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int?,
      dateCreation: json['dateCreation'] != null
          ? DateTime.tryParse(json['dateCreation'])
          : null,
      dateAppointment: json['dateAppointment'] != null
          ? DateTime.tryParse(json['dateAppointment'])
          : null,
      etat: json['etat'] != null
          ? etatAppointmentFromString(json['etat'])
          : null,
      consultationId: json['consultation_id'] as int?,
      consultation: json['consultation'] != null
          ? Consultation.fromJson(json['consultation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreation': dateCreation?.toIso8601String(),
      'dateAppointment': dateAppointment?.toIso8601String(),
      'etat': etat != null ? etatAppointmentToString(etat!) : null,
      'consultation_id': consultationId,
      'consultation': consultation?.toJson(),
    };
  }
}
