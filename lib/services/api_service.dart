// lib/services/api_service.dart

import 'dart:convert';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

// Import your model classes here. For example:
import '../modals/userModal.dart';
import '../modals/doctorModal.dart';
import '../modals/patientModal.dart';
import '../modals/consultationModal.dart';
import '../modals/appointmentModal.dart';
import '../modals/hypotheseModal.dart';
import '../modals/symptomsModal.dart';
import '../modals/chat_messageModal.dart';
// Additionally, if you have a Token model or similar:
// import '../modals/token.dart';

class ApiService {
  // --------------------
  // AUTHENTICATION
  // --------------------

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(Config.authTokenUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,  // Field name must be "username" (FastAPI requirement)
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      // You could parse this into a Token model if you have one.
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      const errorMessage = "Incorrect email or password"; // Adjust based on your API
      throw Exception(errorMessage);
    }
  }

  // --------------------
  // USER ENDPOINTS
  // --------------------

  Future<User> fetchUser(int id) async {
    final url = Uri.parse(Config.getUserByIdUrl(id));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load user');
  }

  Future<List<User>> fetchUsersByName(String name) async {
    final url = Uri.parse(Config.getUsersByNameUrl(name));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users by name');
  }

  Future<Map<String, dynamic>> updatePassword(String currentPassword, String newPassword) async {
    final url = Uri.parse(Config.updatePasswordUrl);
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to update password: ${response.body}');
  }

  // --------------------
  // DOCTOR ENDPOINTS
  // --------------------

  Future<Doctor> fetchDoctor(int id) async {
    final url = Uri.parse(Config.getDoctorByIdUrl(id));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load doctor');
  }

  Future<List<Doctor>> fetchDoctorsByName(String name) async {
    final url = Uri.parse(Config.getDoctorsByNameUrl(name));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Doctor.fromJson(json)).toList();
    }
    throw Exception('No doctors found');
  }

  Future<Doctor> createDoctor(Doctor doctor) async {
    final url = Uri.parse(Config.doctorsUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(doctor.toJson()),
    );
    if (response.statusCode == 201) {
      return Doctor.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create doctor: ${response.body}');
  }

  Future<Doctor> updateDoctor(int id, Doctor updatedDoctor) async {
    final url = Uri.parse('${Config.doctorsUrl}/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedDoctor.toJson()),
    );
    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update doctor: ${response.body}');
  }

  // --------------------
  // PATIENT ENDPOINTS
  // --------------------

  Future<Patient> fetchPatient(int id) async {
    final url = Uri.parse(Config.getPatientByIdUrl(id));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load patient');
  }

  // in api_service.dart (or wherever you have createPatient)
  Future<void> createPatient(PatientCreate patientCreate) async {
    final url = Uri.parse(Config.patientsUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patientCreate.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw "Une erreur est survenue lors de l'enregistrement. le mail est déja utilisé.";
    }
  }


  Future<Patient> updatePatient(int id, Patient updatedPatient) async {
    final url = Uri.parse('${Config.patientsUrl}/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedPatient.toJson()),
    );
    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update patient');
  }

  // --------------------
  // CONSULTATION (DOCTOR) ENDPOINTS
  // --------------------

  Future<List<Consultation>> getDoctorConsultations() async {
    final url = Uri.parse(Config.getAllDoctorConsultationsUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Consultation.fromJson(json)).toList();
    }
    throw Exception('No consultations found for the doctor');
  }

  Future<List<Consultation>> getDoctorConsultationsByEtat(String etat) async {
    final url = Uri.parse(Config.getDoctorConsultationsByEtatUrl(etat));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Consultation.fromJson(json)).toList();
    }
    throw Exception('No consultations found for etat $etat');
  }

  Future<Consultation> validateConsultation(int consultationId, String doctorNote) async {
    final url = Uri.parse(Config.validateConsultationUrl(consultationId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'doctor_note': doctorNote}),
    );
    if (response.statusCode == 200) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to validate consultation');
  }

  Future<Consultation> markReconsultation(int consultationId, String doctorNote) async {
    final url = Uri.parse(Config.reconsultationUrl(consultationId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'doctor_note': doctorNote}),
    );
    if (response.statusCode == 200) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to mark consultation for reconsultation');
  }

  // --------------------
  // CONSULTATION (PATIENT) ENDPOINTS
  // --------------------

  Future<Consultation> createConsultation(Map<String, dynamic> consultationData) async {
    // Here you could pass a ConsultationCreate model or simply a Map.
    final url = Uri.parse(Config.createConsultationUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(consultationData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create consultation');
  }

  Future<ChatMessage> addChatMessage(int consultationId, Map<String, dynamic> messageData) async {
    final url = Uri.parse(Config.addChatMessageUrl(consultationId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(messageData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChatMessage.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add chat message');
  }

  Future<Consultation> getConsultation(int consultationId) async {
    final url = Uri.parse(Config.getConsultationUrl(consultationId));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Consultation not found');
  }

  Future<List<ChatMessage>> getConsultationChatHistory(int consultationId) async {
    final url = Uri.parse(Config.getConsultationChatHistoryUrl(consultationId));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    }
    return [];
  }

  Future<String> sendChatMessage(int consultationId, Map<String, dynamic> chatData) async {
    final url = Uri.parse(Config.sendChatMessageUrl(consultationId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(chatData),
    );
    if (response.statusCode == 200) {
      // This endpoint returns the LLM response as a string.
      return response.body;
    }
    throw Exception('Failed to send chat message');
  }

  Future<Consultation> finishConsultationChat(int consultationId) async {
    final url = Uri.parse(Config.finishConsultationUrl(consultationId));
    final response = await http.post(url);
    if (response.statusCode == 200) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to finish consultation chat');
  }

  Future<Appointment> addAppointment(int consultationId, Map<String, dynamic> appointmentData) async {
    final url = Uri.parse(Config.addAppointmentUrl(consultationId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointmentData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Appointment.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add appointment');
  }

  // --------------------
  // DIAGNOSTIC ENDPOINTS
  // --------------------

  Future<List<dynamic>> getDiagnosticsByPatient(int patientId) async {
    final url = Uri.parse(Config.getDiagnosticsByPatientUrl(patientId));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw Exception('No diagnostics found for patient');
  }

  Future<List<dynamic>> getDiagnosticsByPatientAndEtat(int patientId, String etat) async {
    final url = Uri.parse(Config.getDiagnosticsByPatientAndEtatUrl(patientId, etat));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw Exception('No diagnostics found for patient with etat $etat');
  }

  Future<List<dynamic>> getDiagnosticsByEtat(String etat) async {
    final url = Uri.parse(Config.getDiagnosticsByEtatUrl(etat));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw Exception('No diagnostics found for etat $etat');
  }

  Future<dynamic> createDiagnostic(Map<String, dynamic> diagnosticData) async {
    final url = Uri.parse(Config.createDiagnosticUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(diagnosticData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create diagnostic');
  }

  Future<List<dynamic>> getConversationHistoryForDiagnostic(int diagnosticId) async {
    final url = Uri.parse(Config.getConversationHistoryUrl(diagnosticId));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw Exception('No conversation history found');
  }

  Future<String> addConversationHistory(int diagnosticId, Map<String, dynamic> conversationData) async {
    final url = Uri.parse(Config.addConversationUrl(diagnosticId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(conversationData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Assuming the response returns a ChatMessage model.
      return response.body;
    }
    throw Exception('Failed to add conversation history');
  }

  Future<dynamic> finishDiagnostic(int diagnosticId) async {
    final url = Uri.parse(Config.finishDiagnosticUrl(diagnosticId));
    final response = await http.put(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to finish diagnostic');
  }

  Future<dynamic> respondToConsultation(int diagnosticId, String etat, String doctorNote) async {
    final url = Uri.parse(Config.respondToConsultationUrl(diagnosticId));
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'etat': etat, 'doctor_note': doctorNote}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to respond to consultation');
  }

  // --------------------
  // LLM DIAGNOSIS ENDPOINTS (if applicable)
  // --------------------

  Future<dynamic> diagnosePatientEn(List<String> symptoms, {String? additionalDetails}) async {
    final url = Uri.parse(Config.diagnoseEnUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'symptoms': symptoms,
        'additional_details': additionalDetails,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to diagnose (EN)');
  }

  Future<dynamic> diagnosePatientFr(List<String> symptoms, {String? additionalDetails}) async {
    final url = Uri.parse(Config.diagnoseFrUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'symptoms': symptoms,
        'additional_details': additionalDetails,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to diagnose (FR)');
  }
}
