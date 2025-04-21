import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:denti_plus/Screens/Views/shedule_tab1.dart';
import 'package:denti_plus/Screens/Views/shedule_tab2.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab1.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab2.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../modals/consultationModal.dart';
import '../../providers/conversation_provider.dart';
import '../../services/api_service.dart';
import '../Widgets/consultationCard.dart';
import 'chat_screen.dart';

class Consultationscreen extends StatefulWidget {
  const Consultationscreen({Key? key}) : super(key: key);

  @override
  _ConsultationscreenState createState() => _ConsultationscreenState();
}

class _ConsultationscreenState extends State<Consultationscreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // Fetch consultations on screen init.
    Provider.of<ConversationProvider>(context, listen: false)
        .fetchConsultations();
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
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/icons/search.png"),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Consumer<ConversationProvider>(
          builder: (context, consultationProvider, child) {
        if (consultationProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (consultationProvider.errorMessage != null) {
          return const shedule_tab2();
        }
        return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromARGB(255, 3, 190, 150),
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
                                      color: const Color.fromARGB(
                                          255, 3, 190, 150),
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
                                        child: Tab(text: "Vérifié"),
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
                            // First tab: "ENCORE" consultations.
                            // Inside your TabBarView’s first ListView.builder (Encore):
                            ListView.builder(
                              itemCount: consultationProvider
                                  .encoreConsultations.length,
                              itemBuilder: (context, index) {
                                final consultation = consultationProvider
                                    .encoreConsultations[index];
                                final dt = consultation.date!;
                                final formattedDate =
                                    DateFormat('dd/MM/yyyy').format(dt);
                                final formattedTime =
                                    DateFormat('hh:mm a').format(dt);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                            consultation: consultation),
                                      ),
                                    ).then((_) {
                                      consultationProvider.fetchConsultations();
                                    });
                                  },
                                  child: ConsultationCard(
                                    date: formattedDate,
                                    time: formattedTime,
                                    title: "Consultation ${consultation.id!}",
                                    etat: consultation.etat?.toString(),
                                  ),
                                );
                              },
                            ),

                            // Second tab: "VALIDÉ" consultations.
                            // And likewise for the Validé tab:
                            ListView.builder(
                              itemCount: consultationProvider
                                  .valideConsultations.length,
                              itemBuilder: (context, index) {
                                final consultation = consultationProvider
                                    .valideConsultations[index];
                                final dt = consultation.date!;
                                final formattedDate =
                                    DateFormat('dd/MM/yyyy').format(dt);
                                final formattedTime =
                                    DateFormat('hh:mm a').format(dt);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                            consultation: consultation),
                                      ),
                                    ).then((_) {
                                      consultationProvider.fetchConsultations();
                                    });
                                  },
                                  child: ConsultationCard(
                                    date: formattedDate,
                                    time: formattedTime,
                                    title: "Consultation ${consultation.id!}",
                                    etat: consultation.etat?.toString(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Create a new consultation via the provider.
            final consultationProvider =
                Provider.of<ConversationProvider>(context, listen: false);
            Consultation newConsultation =
                await consultationProvider.createNewConsultation();

            // Once created, navigate to the ChatScreen.
            // You can pass the new consultation object (or its id) to the ChatScreen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(consultation: newConsultation),
              ),
            ).then((_) {
              consultationProvider.fetchConsultations();
            });
          } catch (e) {
            // Optionally show an error message if creation fails.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 3, 190, 150),
        child: Container(
          height: 20,
          width: 20,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Chat.png"),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
