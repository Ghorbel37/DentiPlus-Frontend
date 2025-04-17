// lib/config.dart

class Config {
  // Base URL for your backend API – update this to your actual backend URL.
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Authentication
  static const String authTokenUrl = '$baseUrl/auth/token';

  // Consultation (Doctor)
  static const String consultationDoctorUrl = '$baseUrl/consultation-doctor';
  // Endpoints for doctor consultations:
  static const String getAllDoctorConsultationsUrl = '$consultationDoctorUrl/consultations';
  // Filtered consultations by etat
  static String getDoctorConsultationsByEtatUrl(String etat) =>
      '$consultationDoctorUrl/consultations/by-etat/$etat';
  static String validateConsultationUrl(int consultationId) =>
      '$consultationDoctorUrl/consultations/$consultationId/validate';
  static String reconsultationUrl(int consultationId) =>
      '$consultationDoctorUrl/consultations/$consultationId/reconsultation';

  // Consultation (Patient)
  static const String consultationPatientUrl = '$baseUrl/consultation-patient/';
  static const String createConsultationUrl = '$consultationPatientUrl';
  static String addChatMessageUrl(int consultationId) =>
      '$consultationPatientUrl$consultationId/messages';
  static String getConsultationUrl(int consultationId) =>
      '$consultationPatientUrl$consultationId';
  static String getConsultationChatHistoryUrl(int consultationId) =>
      '$consultationPatientUrl$consultationId/chat-history';
  static String sendChatMessageUrl(int consultationId) =>
      '$consultationPatientUrl$consultationId/chat';
  static String finishConsultationUrl(int consultationId) =>
      '$consultationPatientUrl$consultationId/finish';
  static String addAppointmentUrl(int consultationId) =>
      '$consultationPatientUrl$consultationId/appointments';

  // Diagnostics
  static const String diagnosticsUrl = '$baseUrl/diagnostics';
  static String getDiagnosticsByPatientUrl(int patientId) =>
      '$diagnosticsUrl/patient/$patientId';
  static String getDiagnosticsByPatientAndEtatUrl(int patientId, String etat) =>
      '$diagnosticsUrl/patient/$patientId/etat/$etat';
  static String getDiagnosticsByEtatUrl(String etat) =>
      '$diagnosticsUrl/etat/$etat';
  static String getDiagnosticForPatientUrl(int diagnosticId) =>
      '$diagnosticsUrl/patient/$diagnosticId';
  static String getDiagnosticForDoctorUrl(int diagnosticId) =>
      '$diagnosticsUrl/doctor/$diagnosticId';
  static const String createDiagnosticUrl = '$diagnosticsUrl/';
  static String getConversationHistoryUrl(int diagnosticId) =>
      '$diagnosticsUrl/$diagnosticId/conversation';
  static String addConversationUrl(int diagnosticId) =>
      '$diagnosticsUrl/$diagnosticId/add-conversation';
  static String finishDiagnosticUrl(int diagnosticId) =>
      '$diagnosticsUrl/$diagnosticId/finish';
  static String respondToConsultationUrl(int diagnosticId) =>
      '$diagnosticsUrl/$diagnosticId/respond';

  // Doctors
  static const String doctorsUrl = '$baseUrl/doctors';
  static String getDoctorByIdUrl(int id) => '$doctorsUrl/$id';
  static String getDoctorsByNameUrl(String name) => '$doctorsUrl/name/$name';
  // (For update, same URL as getting a doctor by id)

  // Patients
  static const String patientsUrl = '$baseUrl/patients/';
  static String getPatientByIdUrl(int id) => '$patientsUrl/$id';
  static String getPatientsByNameUrl(String name) => '$patientsUrl/name/$name';

  // Users
  static const String usersUrl = '$baseUrl/users';
  static String getUserByIdUrl(int id) => '$usersUrl/$id';
  static String getUsersByNameUrl(String name) => '$usersUrl/name/$name';
  static const String updatePasswordUrl = '$usersUrl/me/password';

  // LLM diagnosis endpoints (if used separately)
  static const String diagnoseEnUrl = '$baseUrl/diagnose-en';
  static const String diagnoseFrUrl = '$baseUrl/diagnose-fr';
}
