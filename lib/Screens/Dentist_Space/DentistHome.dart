import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:denti_plus/Screens/Views/HomePageDenti.dart';
import 'package:denti_plus/Screens/Views/rendezVous.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:denti_plus/Screens/Login-Signup/Profile_screen.dart';
import 'package:denti_plus/Screens/Login-Signup/shedule_screen.dart';
import 'package:denti_plus/Screens/Views/Dashboard_screen.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/message_tab_all.dart';

import 'ConsultationList.dart';


class Dentisthome extends StatefulWidget {
  @override
  State<Dentisthome> createState() => _HomepageState();
}

class _HomepageState extends State<Dentisthome> {
  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.user,
  ];

  int page = 0;

  List<Widget> pages = [
    Consultationlist(),
    Profile_screen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[page], // Display the selected page
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: icons,
        iconSize: 20,
        activeIndex: page,
        height: 80,
        splashSpeedInMilliseconds: 300,
        gapLocation: GapLocation.none,
        activeColor: const Color.fromARGB(255, 0, 190, 165),
        inactiveColor: const Color.fromARGB(255, 223, 219, 219),
        onTap: (int tappedIndex) {
          setState(() {
            page = tappedIndex; // Update the selected page
          });
        },
      ),
    );
  }
}
