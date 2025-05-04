import 'package:flutter/material.dart';
import 'package:denti_plus/services/api_service.dart';
import '../modals/TimeSlot.dart';
import '../modals/appointmentModal.dart';
import '../modals/consultationModal.dart';
import '../modals/enums.dart';
import '../modals/patientCreateModal.dart';

class AppointmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Appointment> _appointments = [];
  List<Appointment> _plannedAppointments = [];
  List<Appointment> _completeAppointments = [];
  List<Appointment> _canceledAppointments = [];
  List<TimeSlot> _unavailableTimes = [];
  Appointment? _currentAppointment;
  bool _isLoading = false;
  String? _errorMessage;
  PatientCreate? _doctor;

  // Direct list access (now mutable)
  List<Appointment> get appointments => _appointments;

  List<TimeSlot> get unavailableTimes => _unavailableTimes;

  Appointment? get currentAppointment => _currentAppointment;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<Appointment> get plannedAppointments => _plannedAppointments;
  List<Appointment> get completeAppointments => _completeAppointments;
  List<Appointment> get canceledAppointments => _canceledAppointments;

  Future<void> addAppointment(
    int consultationId,
    Map<String, dynamic> appointmentData,
  ) async {
    _startLoading();
    try {
      final newAppointment = await _apiService.addAppointment(
        consultationId,
        appointmentData,
      );

      _appointments = [..._appointments, newAppointment];
      _currentAppointment = newAppointment;
    } catch (e) {
      _handleError(e);
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> changeAppointmentTime(
    int appointmentId,
    Map<String, dynamic> newTimeData,
  ) async {
    _startLoading();
    try {
      final updatedAppointment = await _apiService.changeAppointmentTime(
        appointmentId,
        newTimeData,
      );

      _appointments = _appointments
          .map((a) => a.id == appointmentId ? updatedAppointment : a)
          .toList();

      _currentAppointment = updatedAppointment;
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    _startLoading();
    try {
      final canceledAppointment = await _apiService.cancelAppointment(appointmentId);

      // Update the appointment in the list
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if(index != -1) {
        _appointments[index] = canceledAppointment;
      }

      notifyListeners();
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<void> fetchUnavailableTimes(DateTime date) async {
    _startLoading();
    try {
      final times = await _apiService.getUnavailableTimes(date);
      _unavailableTimes = times;
    } catch (e) {
      _handleError(e);
      _unavailableTimes = [];
    } finally {
      _stopLoading();
    }
  }

  void reset() {
    _currentAppointment = null;
    _errorMessage = null;
    _unavailableTimes = [];
    notifyListeners();
  }

  // Private helpers
  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _handleError(dynamic error) {
    _errorMessage = error.toString();
    if (error is Exception && error.toString().contains("409")) {
      _errorMessage = "Time slot unavailable. Please choose another time.";
    }
  }

  Future<List<Consultation>> fetchConsultationsReconsultaion() async {
    _startLoading();
    try {
      final consultations = await _apiService.getConsultationsReconsultation();
      return consultations;
    } catch (e) {
      _handleError(e);
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<List<Consultation>> fetchConsultationsByEtat(String etat) async {
    _startLoading();
    try {
      final consultations = await _apiService.getConsultationsByEtat(etat);
      return consultations;
    } catch (e) {
      _handleError(e);
      rethrow;
    } finally {
      _stopLoading();
    }
  }

  Future<void> fetchPatientAppointments() async {
    _startLoading();
    try {
      final appointments = await _apiService.getPatientAppointments();
      _appointments = appointments;

      // Initialize separate lists using enum comparison
      _plannedAppointments = appointments.where((a) =>
      a.etat == EtatAppointment.PLANIFIE).toList();

      _completeAppointments = appointments.where((a) =>
      a.etat == EtatAppointment.COMPLETE).toList();

      _canceledAppointments = appointments.where((a) =>
      a.etat == EtatAppointment.ANNULE).toList();

      _doctor= await fetchDoctor();
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<PatientCreate?> fetchDoctor() async {
    try {
      final doctor = await _apiService.fetchSingleDoctor();
      return doctor;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  Future<PatientCreate?> fetchDoctorById(int doctorId) async {
    try {
      final doctor = await _apiService.fetchDoctor(doctorId);
      return doctor;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }
}
