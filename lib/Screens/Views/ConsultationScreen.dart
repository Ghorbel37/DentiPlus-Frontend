import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Views/shedule_tab1.dart';
import 'package:denti_plus/Screens/Views/shedule_tab2.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab1.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab2.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Widgets/consultationCard.dart';

class Consultationscreen extends StatefulWidget {
  const Consultationscreen({Key? key}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<Consultationscreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  // Liste de données pour les cartes de consultation
  final List<Map<String, String>> consultationData = [
    {'date': '26/06/2022', 'time': '10:30 AM', 'title': 'Consultation 3'},
    {'date': '27/06/2022', 'time': '11:00 AM', 'title': 'Consultation 4'},
    {'date': '28/06/2022', 'time': '12:00 PM', 'title': 'Consultation 5'},
    {'date': '28/06/2022', 'time': '12:00 PM', 'title': 'Consultation 5'},
    {'date': '28/06/2022', 'time': '12:00 PM', 'title': 'Consultation 5'},
  ];
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Liste des Consultations",
          style: GoogleFonts.poppins(color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp),
        ),
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("lib/icons/search.png"),
              )),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 00),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                width: double.infinity,
                                height: 50, // Fixer la hauteur pour éviter les bugs d'affichage
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(255, 3, 190, 150),
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25), // Éviter le débordement de l'indicateur
                                  child: TabBar(
                                    controller: tabController,
                                    indicator: BoxDecoration(
                                      color: const Color.fromARGB(255, 3, 190, 150),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab, // L’indicateur prend toute la taille de l’onglet
                                    labelPadding: EdgeInsets.zero, // Évite le décalage du texte
                                    unselectedLabelColor: Colors.black54,
                                    labelColor: Colors.white,
                                    labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                    tabs: const [
                                      Expanded(
                                        child: Tab(text: "Encore"),
                                      ),
                                      Expanded(
                                        child: Tab(text: "validé"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Utiliser une liste de widgets pour les cartes
                          ListView(
                            children: consultationData.map((data) {
                              return ConsultationCard(
                                date: data['date']!,
                                time: data['time']!,
                                title: data['title']!,
                              );
                            }).toList(),
                          ),
                          shedule_tab2(),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
