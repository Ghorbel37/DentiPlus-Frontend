import 'package:denti_plus/Screens/Dentist_Space/ConsDetails.dart';
import 'package:denti_plus/modals/diagModal.dart';
import 'package:denti_plus/providers/doctor_consultations_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Views/doctor_details_screen.dart';

class ConsCard extends StatefulWidget {
  final String mainText;
  final String subText;
  final String date;
  final String time;
  final int idCons;

  const ConsCard({
    super.key,
    required this.mainText,
    required this.subText,
    required this.date,
    required this.time,
    required this.idCons,
  });

  @override
  _SheduleCardState createState() => _SheduleCardState();
}

class _SheduleCardState extends State<ConsCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<DoctorConsultationsProvider>(
          builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage != null) {
          return Center(
            child: Text(
              provider.errorMessage!,
              style: GoogleFonts.openSans(color: Colors.red),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: Consdetails(
                    showBottomAppBar: true,
                    idCons: widget.idCons,
                  )),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.19,
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
                              widget.mainText,
                              style: GoogleFonts.poppins(
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.subText,
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 99, 99, 99)),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton "Annuler"
                      GestureDetector(
                        onTap: () {
                          showNoteREDialog(context);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.045,
                          width: MediaQuery.of(context).size.width * 0.38,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 92, 92),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Re-Cons",
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bouton "Reprogrammer"
                      GestureDetector(
                        onTap: () {
                          showNoteValDialog(context);
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
                              "Valider",
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
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void showNoteValDialog(BuildContext context) {
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
                      onPressed: () {
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
                      onPressed: () {
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
