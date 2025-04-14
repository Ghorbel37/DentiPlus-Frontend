// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../modals/userModal.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Logs in a user with [email] and [password].
  /// If successful, sets [_user] and notifies listeners.
  /*Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.login(email, password);
      _user = User.fromJson(data['user']); // or adjust if your backend returns different key
      // If you have token in response: save it here
      // String token = data['access_token'];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }*/
  // Inside your AuthProvider class
  Future<void> login(String email, String password) async {
    final startTime = DateTime.now(); // Track start time

    try {
      _isLoading = true;
      notifyListeners();
      // Your existing login logic
      final response = await ApiService().login(email, password);
      _user = User.fromJson(response);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      // Calculate remaining time to reach 2 seconds
      final elapsed = DateTime.now().difference(startTime);
      final remaining = Duration(seconds: 2) - elapsed;

      if (remaining > Duration.zero) {
        await Future.delayed(remaining); // Wait if needed
      }

      _isLoading = false; // Hide spinner after 2 seconds total
      notifyListeners();
    }
  }

  /// Logs out the current user
  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
    // Optionally: clear token if stored
  }
}
