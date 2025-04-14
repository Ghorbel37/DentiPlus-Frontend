import 'package:flutter/material.dart';
import '../modals/patientCreateModal.dart';
import '../modals/patientModal.dart';
import '../services/api_service.dart';

class PatientProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Patient? _patient;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Patient? get patient => _patient;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch a patient profile by their [id]
  Future<void> fetchPatient(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.fetchPatient(id);
      _patient = result;
    } catch (e) {
      _errorMessage = e.toString();
      _patient = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new patient from a [Patient] model
  Future<void> createPatient(PatientCreate pc) async {
    final startTime = DateTime.now();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createPatient(pc);
      // If successful, do anything you like here (e.g. store success state)
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // Calculate remaining time to reach 2 seconds
      final elapsed = DateTime.now().difference(startTime);
      final remaining = Duration(seconds: 2) - elapsed;

      if (remaining > Duration.zero) {
        await Future.delayed(remaining); // Wait if needed
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing patient by ID
  Future<void> updatePatient(int id, Patient updatedPatient) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _apiService.updatePatient(id, updatedPatient);
      _patient = updated;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear all patient data (on logout or reset)
  void clear() {
    _patient = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
