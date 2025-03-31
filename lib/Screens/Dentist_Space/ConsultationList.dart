import 'package:denti_plus/Screens/Dentist_Space/Consultation_Card.dart';
import 'package:denti_plus/Screens/Dentist_Space/Listrecons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Views/shedule_tab1.dart';
import 'package:denti_plus/Screens/Views/shedule_tab2.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab1.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab2.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Views/doctor_details_screen.dart';
import 'Listvalide.dart';

class Consultationlist extends StatefulWidget {
  const Consultationlist({Key? key}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<Consultationlist>
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
          "Liste Des Consultations",
          style: GoogleFonts.poppins(
              color: Colors.black,
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
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/folderadd.png"),
                ),
              ),
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
                              height: 50,
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
                                borderRadius: BorderRadius.circular(25),
                                child: TabBar(
                                  controller: tabController,
                                  indicator: BoxDecoration(
                                    color:
                                    const Color.fromARGB(255, 3, 190, 150),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelPadding: EdgeInsets.zero,
                                  unselectedLabelColor: Colors.black54,
                                  labelColor: Colors.white,
                                  labelStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                  tabs: const [
                                    Expanded(
                                      child: Tab(text: "Encore"),
                                    ),
                                    Expanded(
                                      child: Tab(text: "Validée"),
                                    ),
                                    Expanded(
                                      child: Tab(text: "Re-Cons"),
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
                          ConsultationCard(),
                          ListView(
                            children: consultationData.map((data) {
                              return Listvalide(
                                date: data['date']!,
                                time: data['time']!,
                                title: data['title']!,
                              );
                            }).toList(),
                          ),
                          ListView(
                            children: consultationData.map((data) {
                              return Listrecons(
                                date: data['date']!,
                                time: data['time']!,
                                title: data['title']!,
                              );
                            }).toList(),
                          ),
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
