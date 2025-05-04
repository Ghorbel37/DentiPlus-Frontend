import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/chat_screen.dart'; // Ensure you have imported your chat screen

class ConsultationCard extends StatelessWidget {
  final String date;
  final String time;
  final String title;
  /// New parameter for the consultation state (etat)
  final String? etat;

  const ConsultationCard({
    Key? key,
    required this.date,
    required this.time,
    required this.title,
    this.etat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the color of the side bar based on etat.
    Color sideBarColor = Colors.black45;
    if (etat.toString().contains("RECONSULTATION")) {
      sideBarColor = Colors.red.shade600;
    }
    if (etat.toString().contains("VALIDE")) {
      sideBarColor = Colors.green.shade600;
    }
    if (etat.toString().contains("EN_ATTENTE")) {
      sideBarColor = Colors.transparent;
    }
    return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              /// Vertical bar with dynamic color.
              Container(
                width: 8.0,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: sideBarColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
              ),
              /// Content of the card.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Consultation title.
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      /// Date and Time aligned horizontally.
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                            width: MediaQuery.of(context).size.width * 0.07,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("lib/icons/callender2.png"),
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                          Text(
                            date,
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                const Color.fromARGB(255, 99, 99, 99)),
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
                            time,
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                const Color.fromARGB(255, 99, 99, 99)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
