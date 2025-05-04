import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:denti_plus/modals/diagModal.dart';
import 'package:denti_plus/providers/doctor_consultations_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:denti_plus/Screens/Widgets/doctorList.dart';
import 'package:denti_plus/Screens/Views/doctor_details_screen.dart';

class Consdetails extends StatefulWidget {
  final bool showBottomAppBar;
  final int idCons;

  const Consdetails(
      {super.key, required this.showBottomAppBar, required this.idCons});

  @override
  State<Consdetails> createState() => _appointmentState();
}

class _appointmentState extends State<Consdetails> {
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<DoctorConsultationsProvider>(context, listen: false);
    provider.fetchConsultationById(widget.idCons);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoctorConsultationsProvider>();
    final Diagmodal? consultation = provider.consultation;
    // Error state
    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }
    // Loading state
    if (consultation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("lib/icons/back1.png", height: 24, width: 24),
          ),
        ),
        title: Text(
          "Consultation",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
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
                  Text(
                    '${consultation.patient?.name ?? ''}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Patient',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Divider(color: Colors.black12, thickness: 1),
                  // ** Reason Selection **
                  SizedBox(height: 15),
                  buildSectionTitle("Contact"),
                  buildPaymentRow("Email", consultation.patient?.email ?? ''),
                  buildPaymentRow(
                      "Adresse", consultation.patient?.adress ?? ''),
                  const Divider(color: Colors.black12, thickness: 1),
                  buildSectionTitle("Symptômes"),
                  if (consultation.symptoms != null)
                    ...consultation.symptoms!.map((s) => buildRow(
                          "", // or whatever your Symptoms model exposes
                          '${s.symptom}', // adapt to your field names
                        )),
                  const Divider(color: Colors.black12, thickness: 1),
                  // ** Symptome Details **
                  SizedBox(height: 15),
                  buildSectionTitle("Les Hypothèses"),
                  if (consultation.hypotheses != null)
                    ...consultation.hypotheses!.map((s) => buildPaymentRow(
                          s.condition!,
                          // or whatever your Symptoms model exposes
                          '${s.confidence}%', // adapt to your field names
                        )),
                  const Divider(color: Colors.black12, thickness: 1),

                  // ** Payment Method Selection with Dropdown **
                  SizedBox(height: 20),
                  buildSectionTitle("Diagnostique d'Assistant"),
                  SizedBox(height: 8),
                  Text(
                    consultation.diagnosis ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  buildSectionTitle("Avis Docteur"),
                  SizedBox(height: 8),
                  Text(
                    consultation.doctorNote ??
                        'Pas encore mentionné votre avis!',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ** Fixed validation Button at Bottom **
          if (widget.showBottomAppBar)
            BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showNoteREDialog(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 92, 92),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "RE",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showNoteValDialog(context);
                      },
                      child: Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 179, 149),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Valider",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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

  Widget buildRow(String label, String amount, {bool isTotal = false}) {
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
          Expanded(
            child: Text(
              amount,
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color:
                      isTotal ? Color.fromARGB(255, 4, 92, 58) : Colors.black87,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  void showNoteValDialog(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.teal, width: 3),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Entrez votre note',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Écrivez ici...',
                  ),
                  maxLines: 7,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final provider = Provider.of<DoctorConsultationsProvider>(
                          context,
                          listen: false,
                        );
                        await provider.validateConsultation(
                          widget.idCons,
                          noteController.text.trim(),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Valider",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Annuler",
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      ),
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

  void showNoteREDialog(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                color: const Color.fromARGB(255, 254, 92, 92), width: 3),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.edit,
                        color: const Color.fromARGB(255, 254, 92, 92)),
                    SizedBox(width: 8),
                    Text(
                      'Entrez votre note',
                      style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 254, 92, 92),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Écrivez ici...',
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final provider = Provider.of<DoctorConsultationsProvider>(
                          context,
                          listen: false,
                        );
                        await provider.markReCons(
                          widget.idCons,
                          noteController.text.trim(),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 254, 92, 92),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Re-Cons",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Annuler",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 254, 92, 92),
                            fontSize: 16),
                      ),
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
