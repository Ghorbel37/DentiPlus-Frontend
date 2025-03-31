import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Widgets/shedule_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'cons_card.dart';

class ConsultationCard extends StatelessWidget {
  const ConsultationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(
          height: 30,
        ),
        ConsCard(
          mainText: "Mahdi Ghorbel",
          subText: "Patient",
          date: "26/06/2022",
          time: "10:30 AM",
        ),
        SizedBox(
          height: 20,
        ),
        ConsCard(
          mainText: "Mayssa BS",
          subText: "Patient",
          date: "26/06/2022",
          time: "2:00 PM",
        )
      ]),
    );
  }
}
