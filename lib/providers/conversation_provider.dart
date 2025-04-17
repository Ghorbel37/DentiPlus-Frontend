import 'package:flutter/material.dart';
import 'package:denti_plus/modals/chat_messageModal.dart';
import 'package:denti_plus/services/api_service.dart';

import '../modals/consultationModal.dart';

class ConversationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State fields to hold conversation data and status.
  List<Consultation> encoreConsultations = [];
  List<Consultation> valideConsultations = [];
  List<ChatMessage> _chatHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  ///GET THE CONSULTATIONS and FILTER THEM
  Future<void> fetchConsultations() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Consultation> consultations =
          await _apiService.getPatientConsultations();

      // Depending on how your etat is stored, convert it to a string.
      // Here, we assume it's an enum and use simple string matching.
      encoreConsultations = consultations.where((c) {
        String etatStr = "";
        if (c.etat != null) {
          // If you have a helper function, use it:
          // etatStr = etatConsultationToString(c.etat!);
          // Otherwise, use:
          etatStr = c.etat.toString();
        }
        // If the etat contains "EN_COURS" or "EN_ATTENTE", show it as "Encore"
        return etatStr.contains("EN_COURS") || etatStr.contains("EN_ATTENTE");
      }).toList();

      valideConsultations = consultations.where((c) {
        String etatStr = "";
        if (c.etat != null) {
          etatStr = c.etat.toString();
        }
        // If the etat contains "VALIDE" or "RECONSULTATION", show it as "Validé"
        return etatStr.contains("VALIDE") || etatStr.contains("RECONSULTATION");
      }).toList();

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches the conversation (chat history) for a given consultation id.
  Future<void> fetchChatHistory(int consultationId) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<ChatMessage> messages =
          await _apiService.getConsultationChatHistory(consultationId);
      _chatHistory = messages;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new chat message to the conversation and updates the local list.
  Future<void> addChatMessage(
      int consultationId, Map<String, dynamic> messageData) async {
    try {
      ChatMessage newMessage =
          await _apiService.addChatMessage(consultationId, messageData);
      _chatHistory.add(newMessage);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Sends a chat message and returns the response from the backend.
  /// This could be useful, for instance, when using an LLM to generate an answer.
  Future<String> sendChatMessage(
      int consultationId, Map<String, dynamic> chatData) async {
    try {
      String response =
          await _apiService.sendChatMessage(consultationId, chatData);
      // Optionally, append the sent message to your history
      // and then call notifyListeners() if needed.
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Creates a new consultation using default values.
  ///
  /// Here we define default values for the consultation.
  /// Adjust the keys and values as required by your backend.
  Future<Consultation> createNewConsultation() async {
    // Define a minimal payload. Adjust the keys as needed.
    final Map<String, dynamic> consultationData = {
      "diagnosis": "", // or a default string
      "chat_summary": "",
      "doctor_note": "",
      "fraisAdministratives": 0,
      "prix": 0,
    };

    try {
      Consultation newConsultation =
          await _apiService.createConsultation(consultationData);
      // Optionally, update your local lists if needed.
      // For example, if the new consultation state is 'ENCORE':
      if (newConsultation.etat! == "EN_ATTENTE" ||
          newConsultation.etat! == "EN_COURS") {
        encoreConsultations.add(newConsultation);
      } else if (newConsultation.etat! == "VALIDE" ||
          newConsultation.etat! == "RECONSULTATION") {
        valideConsultations.add(newConsultation);
      }
      notifyListeners();
      return newConsultation;
    } catch (e) {
      throw Exception("Failed to create consultation: ${e.toString()}");
    }
  }
}
