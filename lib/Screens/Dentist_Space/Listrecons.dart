import 'package:denti_plus/modals/diagModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../Views/chat_screen.dart';
import 'ConsDetails.dart'; // Assurez-vous d'importer votre écran de chat

class Listrecons extends StatefulWidget {
  final String date;
  final String time;
  final String title;
  final int idCons;

  const Listrecons(
      {super.key,
      required this.date,
      required this.time,
      required this.title,
      required this.idCons});

  @override
  _ListreconsState createState() => _ListreconsState();
}

class _ListreconsState extends State<Listrecons> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child:
                  Consdetails(showBottomAppBar: false, idCons: widget.idCons),
            ),
          );
        },
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
              /// ✅ **Barre latérale verte**
              Container(
                width: 8.0,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: const Color.fromARGB(255, 254, 92, 92),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
              ),

              /// ✅ **Contenu de la carte**
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ✅ Centrage vertical du texte
                    children: [
                      /// ✅ **Titre de la consultation**
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      /// ✅ **Date et Heure alignées horizontalement**
                      Row(children: [
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
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
