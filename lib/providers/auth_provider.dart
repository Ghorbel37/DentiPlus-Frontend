// lib/providers/auth_provider.dart
import 'dart:convert';

import 'package:denti_plus/modals/doctorModal.dart';
import 'package:denti_plus/modals/patientModal.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../modals/patientCreateModal.dart';
import '../services/api_service.dart';
import '../modals/userModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  PatientCreate? _userDetect;
  PatientCreate? get userDetect => _userDetect;

  PatientCreate? _fetchedUser;
  PatientCreate? get fetchedUser => _fetchedUser;

  Future<void> initAuth() async {
    // Initial setup: read token and basic info from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userJson = prefs.getString('user_object');

    if (token != null) {
      final email = prefs.getString('email') ?? '';
      final role = prefs.getString('role') ?? '';
      final userId = prefs.getString('user_id') ?? '0';

      if (userJson != null) {
        _userDetect = PatientCreate.fromJson(json.decode(userJson));
      }
    }
    _isInitializing = false;
    notifyListeners();
  }

  AuthProvider() {
    initAuth();
  }

  /// Logs in a user with [email] and [password].
  Future<void> login(String email, String password) async {
    final startTime = DateTime.now();
    try {
      _isLoading = true;
      notifyListeners();

      // Call API (assumed to return token and basic user info)
      final response = await _apiService.login(email, password);
      _user = User.fromJson(response);
      final accessToken = response['access_token'];

      // Decode the token to get user data
      final decodedToken = JwtDecoder.decode(accessToken);
      final userEmail = decodedToken['sub'];
      final userRole = decodedToken['role'];
      final userId = decodedToken['id']?.toString() ?? '';

      // Save data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('email', userEmail);
      await prefs.setString('role', userRole);
      await prefs.setString('user_id', userId);

      // Update userDetect with minimal information.
      // After successful login:
      _fetchedUser = await _apiService.fetchUser(int.parse(userId));
      _userDetect = fetchedUser;
      await prefs.setString('user_object', json.encode(fetchedUser?.toJson()));
      notifyListeners();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      final elapsed = DateTime.now().difference(startTime);
      final remaining = Duration(seconds: 2) - elapsed;
      if (remaining > Duration.zero) await Future.delayed(remaining);

      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the current user's name and email.
  /// Calls the update endpoint based on the user's role.
  /*Future<void> updateUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? "";
    final userIdStr = prefs.getString('user_id') ?? "0";
    final userId = int.tryParse(userIdStr) ?? 0;

    try {
      if (role == "PATIENT") {
        final updatedPatient = PatientCreate(
          id: userId,
          email: email,
          name: name,
          role: role,
          adress: _fetchedUser?.adress ?? '',
          birthdate: _fetchedUser?.birthdate,
          phoneNumber: _fetchedUser?.phoneNumber,
          calories: _fetchedUser?.calories ?? 0,
          frequenceCardiaque: _fetchedUser?.frequenceCardiaque ?? 0,
          poids: _fetchedUser?.poids ?? 0,
        );
        await _apiService.updatePatient(userId, updatedPatient);
      } else if (role == "DOCTOR") {
        final updatedDoctor = PatientCreate(
          id: userId,
          email: email,
          name: name,
          role: role,
          adress: _fetchedUser?.adress ?? '',
          birthdate: _fetchedUser?.birthdate,
          phoneNumber: _fetchedUser?.phoneNumber,
          calories: _fetchedUser?.calories ?? 0,
          frequenceCardiaque: _fetchedUser?.frequenceCardiaque ?? 0,
          poids: _fetchedUser?.poids ?? 0,
        );
        await _apiService.updateDoctor(userId, updatedDoctor);
      }

      _fetchedUser = await _apiService.fetchUser(userId);

      // Update local state using copyWith.
      _userDetect = _fetchedUser?.copyWith(name: name, email: email);
      notifyListeners();
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour des informations");
    }
  }*/

  Future<void> updateUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? "";
    // Retrieve user_id as string, then parse it as int if needed.
    final userIdStr = prefs.getString('user_id') ?? "0";
    final userId = int.tryParse(userIdStr) ?? 0;

    try {
      // Use the previously fetched full user data if available,
      // and update only the name and email.
      final updateData = (_fetchedUser != null)
          ? _fetchedUser!.copyWith(name: name, email: email)
          : PatientCreate(email: email, name: name);

      // Make API call based on role
      if (role == "PATIENT") {
        await _apiService.updatePatient(userId, updateData);
      } else if (role == "DOCTOR") {
        await _apiService.updateDoctor(userId, updateData);
      }

      // Fetch updated user data
      final updatedUser = await _apiService.fetchUser(userId);

      // Update local state
      _userDetect = updatedUser;

      // Update SharedPreferences (if you want to store other fields)
      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('user_object', json.encode(updatedUser.toJson()));

      // Notify listeners in provider if needed
      notifyListeners();
    } catch (e) {
      throw "Update failed: ${e.toString()}";
    }
  }

  ///pass word change
  Future<Map<String, dynamic>> updatePassword(String currentPassword, String newPassword) async {
    try {
      // Call the ApiService's updatePassword method.
      final response = await _apiService.updatePassword(currentPassword, newPassword);
      // Optionally process the response (e.g., refresh token, update local state) if needed.
      // Here we just return the response.
      return response;
    } catch (e) {
      throw Exception("Failed to update passwordggggg: ${e.toString()}");
    }
  }



  /// Logs out the current user.
  Future<void> logout() async {
    _user = null;
    _errorMessage = null;
    // Clear SharedPreferences or any stored session info
    await _clearSession();
    notifyListeners();
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _userDetect = null;
    notifyListeners();
  }
}
