// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modals/IntegrityResult.dart';
import '../modals/TimeSlot.dart';
import '../modals/diagModal.dart';
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
        'username': email,
        // Field name must be "username" (FastAPI requirement)
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final tokenData = jsonDecode(response.body);
      final accessToken = tokenData['access_token'];

      // Decode the JWT to get user data
      final decodedToken = JwtDecoder.decode(accessToken);
      final userEmail = decodedToken['sub']; // From your token's "sub" claim
      final userRole = decodedToken['role']; // From your token's "role" claim
      final userId = decodedToken['id'];

      // Store user data (e.g., in SharedPreferences)
      await _storeUserData(userEmail, userRole, userId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);

      // You could parse this into a Token model if you have one.
      return jsonDecode(response.body);
    } else {
      final errorBody = jsonDecode(response.body);
      const errorMessage =
          "Incorrect email or password"; // Adjust based on your API
      throw Exception(errorMessage);
    }
  }

  Future<void> _storeUserData(String email, String role, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('role', role);
    await prefs.setInt('user_id', id);
  }

  // Add to ApiService class
  Future<PatientCreate> uploadProfilePhoto(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.usersUrl}/me/photo'),
      )..headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return PatientCreate.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception('Failed to upload photo: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  /// Fetches the current user’s profile photo as raw bytes.
  /// Returns a [Uint8List] that you can feed into a MemoryImage.
  Future<Uint8List> fetchProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('${Config.usersUrl}/me/photo');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/octet-stream',
      },
    );

    if (response.statusCode == 200) {
      // bodyBytes is the raw image data
      return response.bodyBytes;
    } else {
      throw Exception(
        'Failed to load profile photo (${response.statusCode}): ${response.reasonPhrase}',
      );
    }
  }

  // --------------------
  // USER ENDPOINTS
  // --------------------

  Future<PatientCreate> fetchUser(int id) async {
    final url = Uri.parse(Config.getUserByIdUrl(id));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return PatientCreate.fromJson(jsonDecode(response.body));
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

  Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Optional: Debug print the token (remove in production)
    //print("Using token: $token");

    final url = Uri.parse(Config.updatePasswordUrl);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    // Optional: print response body for debugging
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to update password: ${response.body}');
  }

  // --------------------
  // DOCTOR ENDPOINTS
  // --------------------

  Future<PatientCreate> fetchSingleDoctor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.getSingleDoctorUrl());
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return PatientCreate.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load doctor');
  }

  Future<PatientCreate> fetchDoctor(int id) async {
    final url = Uri.parse(Config.getDoctorByIdUrl(id));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return PatientCreate.fromJson(jsonDecode(response.body));
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

  Future<PatientCreate> updateDoctor(
      int id, PatientCreate updatedDoctor) async {
    final url = Uri.parse('${Config.doctorsUrl}/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedDoctor.toJson()),
    );
    if (response.statusCode == 200) {
      return PatientCreate.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update doctor: ${response.body}');
  }

  // --------------------
  // PATIENT ENDPOINTS
  // --------------------

  Future<PatientCreate> fetchPatient(int id) async {
    final url = Uri.parse(Config.getPatientByIdUrl(id));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return PatientCreate.fromJson(jsonDecode(response.body));
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

  Future<PatientCreate> updatePatient(
      int id, PatientCreate updatedPatient) async {
    final url = Uri.parse('${Config.patientsUrl}$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedPatient.toJson()),
    );
    if (response.statusCode == 200) {
      return PatientCreate.fromJson(jsonDecode(response.body));
    }
    // Print or include the response body in the exception for debugging.
    throw Exception('Failed to update patient: ${response.body}');
  }

  // --------------------
  // CONSULTATION (DOCTOR) ENDPOINTS
  // --------------------

  Future<List<Consultation>> getDoctorConsultations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.getAllDoctorConsultationsUrl);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Consultation.fromJson(json)).toList();
    }
    throw Exception('No consultations found for the doctor');
  }

  Future<Diagmodal> getDoctorConsultationByID(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.getDoctorConsultationByIdUrl(id));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Diagmodal.fromJson(data);
    }
    throw Exception('No consultation found with id : $id');
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

  Future<Diagmodal> validateConsultation(
      int consultationId, String doctorNote) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse(Config.validateConsultationUrl(consultationId));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ 'doctor_note': doctorNote }),
    );

    // ** DEBUG LOGGING **
    print('✅ validateConsultation status: ${response.statusCode}');
    print('📦 validateConsultation body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return Diagmodal.fromJson(jsonDecode(response.body));
      }
      // no body: return minimal successful model
      return Diagmodal(id: consultationId, doctorNote: doctorNote);
    }

    // surface the real error:
    throw Exception(
        'validateConsultation failed (${response.statusCode}): ${response.body}'
    );
  }


  Future<Diagmodal> markReconsultation(
      int consultationId, String doctorNote) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.reconsultationUrl(consultationId));
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'doctor_note': doctorNote,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return Diagmodal.fromJson(jsonDecode(response.body));
      }
      // no body: return minimal successful model
      return Diagmodal(id: consultationId, doctorNote: doctorNote);
    }

    // surface the real error:
    throw Exception(
        'ReConsultation failed (${response.statusCode}): ${response.body}'
    );
  }

  // --------------------
  // CONSULTATION (PATIENT) ENDPOINTS
  // --------------------

  Future<Consultation> createConsultation(
      Map<String, dynamic> consultationData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Optional: Debug print the token (remove in production)
    //print("Using token: $token");
    // Here you could pass a ConsultationCreate model or simply a Map.
    final url = Uri.parse(Config.createConsultationUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(consultationData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create consultation');
  }

  Future<ChatMessage> addChatMessage(
      int consultationId, Map<String, dynamic> messageData) async {
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Optional: Debug print the token (remove in production)
    //print("Using token: $token");
    final url = Uri.parse(Config.getConsultationUrl(consultationId));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Consultation not found');
  }

  Future<List<ChatMessage>> getConsultationChatHistory(
      int consultationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Optional: Debug print the token (remove in production)
    //print("Using token: $token");

    final url = Uri.parse(Config.getConsultationChatHistoryUrl(consultationId));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Consultation>> getConsultationsReconsultation() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('${Config.baseUrl}/consultation-patient/reconsultations/available/');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Consultation.fromJson(e)).toList();
    }

    throw Exception('Failed to fetch consultations: ${response.statusCode}');
  }

  Future<List<Consultation>> getConsultationsByEtat(String etat) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('${Config.baseUrl}/consultation-patient/by-etat/$etat');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Consultation.fromJson(e)).toList();
    }

    throw Exception('Failed to fetch consultations: ${response.statusCode}');
  }

  Future<String> sendChatMessage(
      int consultationId, Map<String, dynamic> chatData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Optional: Debug print the token (remove in production)
    //print("Using token: $token");

    final url = Uri.parse(Config.sendChatMessageUrl(consultationId));
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(chatData),
    );
    if (response.statusCode == 200) {
      // This endpoint returns the LLM response as a string.
      return response.body;
    }
    throw Exception('Failed to send chat message');
  }

  Future<Consultation> finishConsultationChat(int consultationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.finishConsultationUrl(consultationId));
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );
    if (response.statusCode == 200) {
      return Consultation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to finish consultation chat');
  }

  Future<List<Appointment>> getPatientAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.patientAppointmentsUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Appointment.fromJson(json)).toList();
    }

    throw Exception('Failed to fetch appointments: ${response.statusCode} - ${response.body}');
  }

  Future<Appointment> addAppointment(
      int consultationId, Map<String, dynamic> appointmentData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.addAppointmentUrl(consultationId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token',},
      body: jsonEncode(appointmentData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Appointment.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add appointment');
  }

  Future<Appointment> changeAppointmentTime(
      int appointmentId, Map<String, dynamic> appointmentData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.changeAppointmentTimeUrl(appointmentId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(appointmentData),
    );
    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to change appointment time: ${response.body}');
  }

  // New method to cancel appointment
  Future<Appointment> cancelAppointment(int appointmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.cancelAppointmentUrl(appointmentId));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to cancel appointment: ${response.body}');
  }

  // New method to get unavailable times
  Future<List<TimeSlot>> getUnavailableTimes(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse(Config.unavailableTimesUrl);
    // Format date to match backend expectation
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'date': formattedDate }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['unavailable_times'] as List)
          .map((e) => TimeSlot.fromJson(e))
          .toList();
    }
    throw Exception('Failed to get unavailable times: ${response.body}');
  }

  Future<List<Consultation>> getPatientConsultations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse(Config
        .consultationPatientUrl); // Make sure to define this URL in your Config class.
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Consultation.fromJson(json)).toList();
    }
    throw Exception('No consultations found: ${response.body}');
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

  Future<List<dynamic>> getDiagnosticsByPatientAndEtat(
      int patientId, String etat) async {
    final url =
        Uri.parse(Config.getDiagnosticsByPatientAndEtatUrl(patientId, etat));
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

  Future<List<dynamic>> getConversationHistoryForDiagnostic(
      int diagnosticId) async {
    final url = Uri.parse(Config.getConversationHistoryUrl(diagnosticId));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw Exception('No conversation history found');
  }

  Future<String> addConversationHistory(
      int diagnosticId, Map<String, dynamic> conversationData) async {
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

  Future<dynamic> respondToConsultation(
      int diagnosticId, String etat, String doctorNote) async {
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

  Future<dynamic> diagnosePatientEn(List<String> symptoms,
      {String? additionalDetails}) async {
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

  Future<dynamic> diagnosePatientFr(List<String> symptoms,
      {String? additionalDetails}) async {
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

// --------------------
// LLM DIAGNOSIS ENDPOINTS (if applicable)
// --------------------

  Future<IntegrityResult> verifyConsultationIntegrity(
      int consultationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('${Config.baseUrl}/verify-integrity/$consultationId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return IntegrityResult.fromJson(body);
    } else if (response.statusCode == 404) {
      throw Exception('Consultation not found (404)');
    } else {
      // you can parse error detail if your backend returns one
      final err =
      response.body.isNotEmpty ? jsonDecode(response.body)['detail'] : null;
      throw Exception(
          'Failed to verify integrity: ${err ?? response.statusCode}');
    }
  }
}
