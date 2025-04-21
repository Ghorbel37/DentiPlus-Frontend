import 'package:denti_plus/modals/enums.dart';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../modals/appointmentModal.dart';
import '../../modals/doctorModal.dart';
import '../../providers/appointment_provider.dart';
import '../Views/doctor_details_screen.dart';

class shedule_annule_card extends StatefulWidget {
  final Appointment appointment;
  final PatientCreate? doctor;
  final String date;
  final String time;
  final String? confirmation;
  final VoidCallback onCancel;


  const shedule_annule_card({
    super.key,
    required this.appointment,
    required this.doctor,
    required this.date,
    required this.time,
    required this.confirmation,
    required this.onCancel,
  });

  @override
  _SheduleAnnuleCardState createState() => _SheduleAnnuleCardState();
}

class _SheduleAnnuleCardState extends State<shedule_annule_card> {
  bool isCancelled = false; // Variable pour gérer l'état du rendez-vous

  @override
  Widget build(BuildContext context) {
    if (isCancelled) {
      return const SizedBox(); // Cache le widget si annulé
    }

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Docteur ${widget.doctor?.name}' ?? "Unknown Doctor",
                          style: GoogleFonts.poppins(
                              fontSize: 17.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.confirmation!.substring(16),
                          style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 99, 99, 99)),
                        ),
                      ],
                    ),
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      image: widget.doctor?.profilePhoto != null
                          ? DecorationImage(
                        image: NetworkImage(doctor!.photoUrl!),
                        fit: BoxFit.cover,
                      )
                          : const DecorationImage(
                        image: AssetImage("lib/icons/default_doctor.png"),
                      ),
                    ),
                  ),
                )*/
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.07,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/icons/callender2.png"),
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  Text(
                    widget.date,
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 99, 99, 99)),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.07,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/icons/watch.png"),
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  Text(
                    widget.time,
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 99, 99, 99)),
                  ),
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton "Annuler"
                  GestureDetector(
                    onTap: () {
                      showConfirmationDialog(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.38,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 233, 233),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Annuler",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(255, 61, 61, 61),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Bouton "Reprogrammer"
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetails(),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.38,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 4, 190, 144),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Reprogrammer",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 252, 252, 252),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Attention !",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Vous voulez annuler le rendez-vous ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Non",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AppointmentProvider>()
                            .cancelAppointment(widget.appointment.id!);
                        setState(() {
                          isCancelled = true;
                        });
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF03BE96),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Oui",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
