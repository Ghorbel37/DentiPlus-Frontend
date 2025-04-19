// lib/models/consultation.dart
import 'dart:convert';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:intl/intl.dart';
import 'enums.dart';
import 'doctorModal.dart';
import 'patientModal.dart';
import 'appointmentModal.dart';
import 'hypotheseModal.dart';
import 'symptomsModal.dart';
import 'chat_messageModal.dart';

class Diagmodal {
  final int? id;
  final DateTime? date;
  final String? diagnosis;
  final String? chatSummary;
  final String? doctorNote;
  final EtatConsultation? etat;
  final double? fraisAdministratives;
  final double? prix;
  final PatientCreate? patient;
  final List<Hypothese>? hypotheses;
  final List<Symptoms>? symptoms;
  final List<ChatMessage>? chatMessages;

  Diagmodal({
    this.id,
    this.date,
    this.diagnosis,
    this.chatSummary,
    this.doctorNote,
    this.etat,
    this.fraisAdministratives,
    this.prix,
    this.patient,
    this.hypotheses,
    this.symptoms,
    this.chatMessages,
  });

  factory Diagmodal.fromJson(Map<String, dynamic> json) {
    return Diagmodal(
      id: json['id'] as int?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      diagnosis: json['diagnosis'] as String?,
      chatSummary: json['chat_summary'] as String?,
      doctorNote: json['doctor_note'] as String?,
      etat: json['etat'] != null ? etatConsultationFromString(json['etat']) : null,
      fraisAdministratives: (json['fraisAdministratives'] as num?)?.toDouble(),
      prix: (json['prix'] as num?)?.toDouble(),
      patient: json['patient'] != null ? PatientCreate.fromJson(json['patient']) : null,
      hypotheses: json['hypotheses'] != null
          ? List<Hypothese>.from(
          json['hypotheses'].map((x) => Hypothese.fromJson(x)))
          : null,
      symptoms: json['symptoms'] != null
          ? List<Symptoms>.from(
          json['symptoms'].map((x) => Symptoms.fromJson(x)))
          : null,
      chatMessages: json['chat_messages'] != null
          ? List<ChatMessage>.from(
          json['chat_messages'].map((x) => ChatMessage.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'diagnosis': diagnosis,
      'chat_summary': chatSummary,
      'doctor_note': doctorNote,
      'etat': etat != null ? etatConsultationToString(etat!) : null,
      'fraisAdministratives': fraisAdministratives,
      'prix': prix,
      'patient': patient?.toJson(),
      'hypotheses': hypotheses?.map((x) => x.toJson()).toList(),
      'symptoms': symptoms?.map((x) => x.toJson()).toList(),
      'chat_messages': chatMessages?.map((x) => x.toJson()).toList(),
    };
  }
}
