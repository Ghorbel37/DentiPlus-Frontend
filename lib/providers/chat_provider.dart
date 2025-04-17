import 'package:flutter/material.dart';
import 'package:denti_plus/modals/chat_messageModal.dart';
import 'package:denti_plus/services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ChatMessage> _chatHistory = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  /// Fetch the entire chat history for a consultation.
  Future<void> fetchChatHistory(int consultationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final messages = await _apiService.getConsultationChatHistory(consultationId);
      _chatHistory = messages;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send a new user message, then reload the chat history.
  Future<void> sendMessage(int consultationId, String message) async {
    if (message.isEmpty) return;

    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call backend; it will persist both user + assistant messages.
      await _apiService.sendChatMessage(consultationId, {'message': message});

      // Re-fetch entire history to pick up both sides.
      await fetchChatHistory(consultationId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}
