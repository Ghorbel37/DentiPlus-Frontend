import 'package:denti_plus/Screens/Views/shedule_tab3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Views/shedule_tab1.dart';
import 'package:denti_plus/Screens/Views/shedule_tab2.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab1.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab2.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../providers/appointment_provider.dart';
import '../Widgets/consultationCard.dart';
import 'chat_screen.dart';
import 'doctor_details_screen.dart';

class Rendezvous extends StatefulWidget {
  const Rendezvous({Key? key}) : super(key: key);

  @override
  _TabBarExampleState createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<Rendezvous> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<dynamic> _reconsultations = []; // Store reconsultations
  bool _loadingConsultations = true; // Track loading state

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _fetchReconsultations(); // Fetch reconsultations on initialization
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchReconsultations() async {
    try {
      final provider = context.read<AppointmentProvider>();
      final consultations = await provider.fetchConsultationsReconsultaion();
      // print('Fetched reconsultations: ${consultations.length} items');
      setState(() {
        _reconsultations = consultations;
        _loadingConsultations = false;
      });
    } catch (e) {
      setState(() => _loadingConsultations = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Calendrier",
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
                  image: AssetImage("assets/Notification.png"),
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
                                      child: Tab(text: "Prochain"),
                                    ),
                                    Expanded(
                                      child: Tab(text: "Complété"),
                                    ),
                                    Expanded(
                                      child: Tab(text: "Annulé"),
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
                            children: const [
                          ScheduleTab1(),
                          ScheduleTab2(),
                          ScheduleTab3(),
                        ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _loadingConsultations || _reconsultations.isEmpty
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DoctorDetails(), // Replace with your actual chat screen
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 254, 92, 92),
        child: const Icon(Icons.add_box, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}