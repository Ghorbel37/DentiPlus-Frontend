// lib/models/enums.dart

enum RoleUser { DOCTOR, PATIENT }

RoleUser roleUserFromString(String value) {
  return RoleUser.values.firstWhere((e) => e.toString().split('.').last == value);
}

String roleUserToString(RoleUser role) {
  return role.toString().split('.').last;
}

enum EtatConsultation { VALIDE, EN_ATTENTE, EN_COURS, RECONSULTATION }

EtatConsultation etatConsultationFromString(String value) {
  return EtatConsultation.values.firstWhere((e) => e.toString().split('.').last == value);
}

String etatConsultationToString(EtatConsultation etat) {
  return etat.toString().split('.').last;
}

enum EtatAppointment { PLANIFIE, COMPLETE, ANNULE }

EtatAppointment etatAppointmentFromString(String value) {
  return EtatAppointment.values.firstWhere((e) => e.toString().split('.').last == value);
}

String etatAppointmentToString(EtatAppointment etat) {
  return etat.toString().split('.').last;
}

enum MessageSenderType { SYSTEM, USER, ASSISTANT, DOCTOR }

MessageSenderType messageSenderTypeFromString(String value) {
  return MessageSenderType.values.firstWhere((e) => e.toString().split('.').last == value);
}

String messageSenderTypeToString(MessageSenderType type) {
  return type.toString().split('.').last;
}
