import 'package:denti_plus/modals/diagModal.dart';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:flutter/material.dart';
import 'package:denti_plus/modals/chat_messageModal.dart';
import 'package:denti_plus/services/api_service.dart';

import '../modals/consultationModal.dart';

class DoctorConsultationsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State fields to hold conversation data and status.
  List<Consultation> encoreConsultations = [];
  List<Consultation> valideConsultations = [];
  List<Consultation> reConsultations = [];
  bool _isLoading = false;
  String? _errorMessage;
  PatientCreate? _patient;
  Diagmodal? _consultation;

  final Map<int, PatientCreate> _patientCache = {};
  PatientCreate? getPatient(int id) => _patientCache[id];


  // Getters
  bool get isLoading => _isLoading;
  Diagmodal? get consultation => _consultation;
  String? get errorMessage => _errorMessage;
  PatientCreate? get patient => _patient;

  ///GET THE CONSULTATIONS and FILTER THEM
  Future<void> fetchConsultations() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Consultation> consultations =
      await _apiService.getDoctorConsultations();
      for (var c in consultations) {
        fetchUserById(c.patientId!);
      }
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
        // If the etat contains "EN_ATTENTE", show it as "Encore"
        return etatStr.contains("EN_ATTENTE");
      }).toList();

      valideConsultations = consultations.where((c) {
        String etatStr = "";
        if (c.etat != null) {
          etatStr = c.etat.toString();
        }
        // If the etat contains "VALIDE", show it as "Validé"
        return etatStr.contains("VALIDE");
      }).toList();

      reConsultations = consultations.where((c) {
        String etatStr = "";
        if (c.etat != null) {
          etatStr = c.etat.toString();
        }
        // If the etat contains "RECONSULTATION", show it as "Validé"
        return etatStr.contains("RECONSULTATION");
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


  Future<void> fetchUserById(int id) async {
    _errorMessage = null;
    if (_patientCache.containsKey(id)) return;
    try {
      final result = await _apiService.fetchUser(id);
      _patientCache[id] = result;
      //_patient = result;
    } catch (e) {
      _errorMessage = e.toString();
      _patient = null;
    }
    notifyListeners();
  }

  Future<void> fetchConsultationById(int id) async {
    _errorMessage = null;
    try {
      final result = await _apiService.getDoctorConsultationByID(id);
      _consultation = result;
    } catch (e) {
      _errorMessage = e.toString();
      _consultation = null;
    }
    notifyListeners();
  }

  Future<void> validateConsultation(int id, String note) async {
    _errorMessage = null;
    try {
      final result = await _apiService.validateConsultation(id, note);
      _consultation = result;
    } catch (e) {
      _errorMessage = e.toString();
      _consultation = null;
    }
    notifyListeners();
  }
  Future<void> markReCons(int id, String note) async {
    _errorMessage = null;
    try {
      final result = await _apiService.markReconsultation(id, note);
      _consultation = result;
    } catch (e) {
      _errorMessage = e.toString();
      _consultation = null;
    }
    notifyListeners();
  }

}
