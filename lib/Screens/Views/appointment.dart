import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:denti_plus/Screens/Widgets/doctorList.dart';
import 'package:denti_plus/Screens/Views/doctor_details_screen.dart';

import '../../modals/consultationModal.dart';
import '../../providers/appointment_provider.dart';

class appointment extends StatefulWidget {
  final String selectedDate;
  final String selectedTime;
  final PatientCreate? doctor;

  const appointment(
      {super.key, required this.selectedDate, required this.selectedTime, required this.doctor});

  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  String _selectedPaymentMethod = "Visa"; // Default selected value
  final List<String> _paymentMethods = ["Visa", "Mastercard", "D17", "PayPal"];
  Consultation? _selectedConsultation;
  List<Consultation> _reconsultations = [];
  bool _loadingConsultations = true;

  @override
  void initState() {
    super.initState();
    _fetchReconsultations();
  }

  Future<void> _fetchReconsultations() async {
    try {
      final provider = context.read<AppointmentProvider>();
      final consultations =
          await provider.fetchConsultationsReconsultaion();

      setState(() {
        _reconsultations = consultations;
        if (consultations.isNotEmpty) {
          _selectedConsultation = consultations.first;
        }
        _loadingConsultations = false;
      });
    } catch (e) {
      setState(() => _loadingConsultations = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load consultations: ${e.toString()}')),
      );
    }
  }

  Future<void> _bookAppointment() async {
    if (_selectedConsultation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a consultation')),
      );
      return;
    }

    try {
      final formattedDate = _parseSelectedDateTime();
      // Verify the values
      //print('Consultation ID: ${_selectedConsultation!.id}');
      //print('Formatted Date: ${formattedDate.toIso8601String()}');

      await context.read<AppointmentProvider>().addAppointment(
        _selectedConsultation!.id!, // Will be non-null here
        {'dateAppointment': formattedDate.toIso8601String()},
      );

      showSuccessDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tu as déja un rendez-vous pour cette consultation !")),
      );
    }
  }

  DateTime _parseSelectedDateTime() {
    // Split ISO date string "2025-04-23"
    final dateParts = widget.selectedDate.split('-');

    // Parse date components
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    // Parse time from "4:00 PM"
    final timeParts = widget.selectedTime.split(' ');
    final hourMinute = timeParts[0].split(':');

    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    // Handle AM/PM conversion
    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    // Create final DateTime in UTC
    return DateTime(year, month, day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: DoctorDetails()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("lib/icons/back1.png", height: 24, width: 24),
            ),
          ),
          title: Text(
            "Planifier RDV",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 70,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    doctorList(
                      distance: "800m away",
                      image: "lib/icons/male-doctor.png",
                      maintext: 'Dr.${doctor?.name}' ?? "Dr. Unknown",
                      numRating: "4.7",
                      subtext: "Cardiologist",
                    ),
                    SizedBox(height: 15),
                    _buildConsultationDropdown(),
                    SizedBox(height: 10),

                    // ** Date & Time Selection **
                    buildSectionTitle("Date"),
                    buildDetailRow("lib/icons/callender.png",
                        "${widget.selectedDate} | ${widget.selectedTime}"),

                    // ** Reason Selection **
                    /*SizedBox(height: 15),
                    buildSectionTitle("Reason"),
                    buildDetailRow("lib/icons/pencil.png", "Chest pain"),*/

                    // ** Payment Details **
                    SizedBox(height: 20),
                    buildSectionTitle("Détails de paiement"),
                    buildPaymentRow("Consultation", "\$60"),
                    buildPaymentRow("frais additionnels", "\$5.00"),
                    buildPaymentRow("Remise supplémentaire", "-"),
                    Divider(color: Colors.black12, thickness: 1),
                    buildPaymentRow("Totale", "\$65.00", isTotal: true),

                    // ** Payment Method Selection with Dropdown **
                    SizedBox(height: 20),
                    Text("Methode de paiement",
                        style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87)),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPaymentMethod,
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            // Fix icon misalignment
                            child: Icon(
                                Icons.credit_card, color: Colors.black54),
                          ),
                          items: _paymentMethods.map((method) {
                            return DropdownMenuItem(
                              value: method,
                              child: Text(method,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15.sp, color: Colors.black87)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPaymentMethod = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ** Fixed Booking Button at Bottom **
            SafeArea(
              child: GestureDetector(
                onTap: _bookAppointment,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 2, 179, 149),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: context
                        .watch<AppointmentProvider>()
                        .isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Book Appointment",
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  // Helper Function for Titles
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  // Helper Function for Date/Reason Rows
  Widget buildDetailRow(String iconPath, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 247, 247, 247),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Image.asset(iconPath,
                    height: 24, width: 24)), // Fixed icon alignment
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Function for Payment Details
  Widget buildPaymentRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 15.sp,
                color: isTotal ? Colors.black87 : Colors.black54,
                fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color:
                    isTotal ? Color.fromARGB(255, 4, 92, 58) : Colors.black87,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationDropdown() {
    if (_loadingConsultations) {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: LinearProgressIndicator(),
      );
    }

    if (_reconsultations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          "Pas de RECONSULTATION",
          style: GoogleFonts.poppins(color: Colors.red),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text("Choisir consultation",
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Consultation>(
              value: _selectedConsultation,
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.medical_services, color: Colors.black54),
              ),
              items: _reconsultations.map((consultation) {
                return DropdownMenuItem<Consultation>(
                  value: consultation,
                  child: Text(
                    "Consultation ${consultation.id} - ${DateFormat('MMM dd, yyyy').format(consultation.date!)}",
                    style: GoogleFonts.poppins(fontSize: 15.sp),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedConsultation = newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Return to previous screen
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/done_24px.png', // Update with your actual image path
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Rendez-vous\nplanifié",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
