import 'package:flutter/material.dart';
import 'package:denti_plus/modals/chat_messageModal.dart';
import 'package:denti_plus/services/api_service.dart';

import '../modals/enums.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ChatMessage> _chatHistory = [];
  bool _isLoading = false;
  bool _isSending = false;
  bool _isFinishing = false; // New flag for finishing consultation
  String? _errorMessage;

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isFinishing => _isFinishing;
  String? get errorMessage => _errorMessage;

  /// Fetch the entire chat history for a consultation.
  Future<void> fetchChatHistory(int consultationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final messages = await _apiService.getConsultationChatHistory(consultationId);
      _chatHistory = messages;
      print('Fetched chat history: ${messages.length} messages');
    } catch (e) {
      _errorMessage = e.toString();
      print('Error fetching chat history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send a new user message, display it immediately, then reload the chat history.
  Future<void> sendMessage(int consultationId, String message) async {
    if (message.isEmpty || _isSending) return;

    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    // Create a temporary user message
    final tempMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch, // Temporary unique ID
      consultationId: consultationId,
      content: message,
      senderType: MessageSenderType.USER,
      timestamp: DateTime.now(),
      consultation: null, // Not needed for temporary message
    );

    // Add the message to chat history immediately
    _chatHistory.add(tempMessage);
    print('Added user message locally: $message');
    notifyListeners();

    try {
      // Send message to backend
      await _apiService.sendChatMessage(consultationId, {'message': message});
      print('Server response received for message: $message');

      // Re-fetch entire history to pick up both user and assistant messages
      await fetchChatHistory(consultationId);
    } catch (e) {
      _errorMessage = e.toString();
      print('Error sending message: $e');
      _chatHistory.removeWhere((msg) => msg.id == tempMessage.id);
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  /// Finish a consultation by sending a request to the backend.
  Future<bool> finishConsultation(int consultationId) async {
    if (_isFinishing) return false;

    _isFinishing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.finishConsultationChat(consultationId);
      print('Consultation $consultationId finished successfully');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error finishing consultation: $e');
      return false;
    } finally {
      _isFinishing = false;
      notifyListeners();
    }
  }
}