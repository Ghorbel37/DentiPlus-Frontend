import 'package:denti_plus/Screens/Dentist_Space/Consultation_Card.dart';
import 'package:denti_plus/Screens/Dentist_Space/Listrecons.dart';
import 'package:denti_plus/Screens/Views/shedule_tab2.dart';
import 'package:denti_plus/providers/doctor_consultations_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


import 'ConsDetails.dart';
import 'Listvalide.dart';

class Consultationlist extends StatefulWidget {
  const Consultationlist({Key? key}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<Consultationlist>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

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
      body: Consumer<DoctorConsultationsProvider>(
          builder: (context, provider, child) {
        if (provider.errorMessage != null) {
          return const Center(
              child: shedule_tab2());
        }
        return Column(
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
                            color: const Color.fromARGB(255, 3, 190, 150),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelPadding: EdgeInsets.zero,
                          unselectedLabelColor: Colors.black54,
                          labelColor: Colors.white,
                          labelStyle: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
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
                  // First tab (Encore) - Keep existing ConsultationCard
                  ConsultationCard(),

                  // Second tab (Validée)
                  Consumer<DoctorConsultationsProvider>(
                    builder: (context, provider, _) {
                      if (provider.valideConsultations.isEmpty) {
                        return shedule_tab2();
                      }
                      return ListView.builder(
                        itemCount: provider.valideConsultations.length,
                        itemBuilder: (context, index) {
                          final consultation = provider.valideConsultations[index];
                          final dt = consultation.date!;
                          final formattedDate = DateFormat('dd/MM/yyyy').format(dt);
                          final formattedTime = DateFormat('hh:mm a').format(dt);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Consdetails(
                                    showBottomAppBar: true,
                                    idCons: consultation.id!,
                                  ),
                                ),
                              ).then((_) => provider.fetchConsultations());
                            },
                            child: Listvalide(
                              idCons: consultation.id!,
                              date: formattedDate,
                              time: formattedTime,
                              title: "Consultation ${consultation.id!}",
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // Third tab (Re-Cons)
                  Consumer<DoctorConsultationsProvider>(
                    builder: (context, provider, _) {
                      if (provider.reConsultations.isEmpty) {
                        return shedule_tab2();
                      }
                      return ListView.builder(
                        itemCount: provider.reConsultations.length,
                        itemBuilder: (context, index) {
                          final consultation = provider.reConsultations[index];
                          final dt = consultation.date!;
                          final formattedDate = DateFormat('dd/MM/yyyy').format(dt);
                          final formattedTime = DateFormat('hh:mm a').format(dt);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Consdetails(
                                    showBottomAppBar: true,
                                    idCons: consultation.id!,
                                  ),
                                ),
                              ).then((_) => provider.fetchConsultations());
                            },
                            child: Listrecons(
                              idCons: consultation.id!,
                              date: formattedDate,
                              time: formattedTime,
                              title: "Consultation ${consultation.id!}",
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
