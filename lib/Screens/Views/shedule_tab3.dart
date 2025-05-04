import 'package:denti_plus/Screens/Views/shedule_tab2.dart';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Widgets/shedule_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../modals/appointmentModal.dart';
import '../../modals/doctorModal.dart';
import '../../providers/appointment_provider.dart';
import '../../services/api_service.dart';
import '../Widgets/shedule_annule_card.dart';

class ScheduleTab3 extends StatefulWidget {
  const ScheduleTab3({
    super.key,
  });

  @override
  State<ScheduleTab3> createState() => _ScheduleTab1State();
}

class _ScheduleTab1State extends State<ScheduleTab3> {
  final ApiService _apiService = ApiService();
  final Map<int, PatientCreate> _doctorCache = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().fetchPatientAppointments();
    });
  }

  Future<PatientCreate?> _getDoctorForAppointment(
      Appointment appointment) async {
    if (_doctorCache.containsKey(appointment.consultationId)) {
      return _doctorCache[appointment.consultationId];
    }

    try {
      final consultation = await _apiService.getConsultation(appointment.consultationId!);
      final doctor = await _apiService.fetchDoctor(consultation.doctorId!);
      _doctorCache[appointment.consultationId!] = doctor;
      return doctor;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  String _formatDate(DateTime isoDate) {
    return DateFormat('dd/MM/yyyy').format(isoDate);
  }

  String _formatTime(DateTime isoDate) {
    return DateFormat('hh:mm a').format(isoDate);
  }

  @override
  Widget build(BuildContext context) {
    final appointments =
        context.watch<AppointmentProvider>().canceledAppointments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: appointments.isEmpty
          ? const Center(child: shedule_tab2())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return FutureBuilder<PatientCreate?>(
                  future: _getDoctorForAppointment(appointment),
                  builder: (context, snapshot) {
                    final doctor = snapshot.data;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: shedule_annule_card(
                        appointment: appointment,
                        doctor: doctor,
                        date: _formatDate(appointment.dateAppointment!),
                        time: _formatTime(appointment.dateAppointment!),
                        confirmation: appointment.etat.toString(),
                        onCancel: () =>
                            _handleCancelAppointment(appointment.id!),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _handleCancelAppointment(int appointmentId) {
    context.read<AppointmentProvider>().cancelAppointment(appointmentId);
  }
}
