import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Views/appointment.dart';
import 'package:denti_plus/Screens/Views/find_doctor.dart';
import 'package:denti_plus/Screens/Widgets/date_select.dart';
import 'package:denti_plus/Screens/Widgets/doctorList.dart';
import 'package:denti_plus/Screens/Widgets/list_doctor1.dart';
import 'package:denti_plus/Screens/Widgets/time_select.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Homepage.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool showExtendedText = false;
  String? selectedDate;
  String? selectedTime;

  void toggleTextVisibility() {
    setState(() {
      showExtendedText = !showExtendedText;
    });
  }
  void onDateSelected(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  void onTimeSelected(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/icons/back1.png"),
              ),
            ),
          ),
        ),
        title: Text(
          "Trouver RDV",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
      ),

      // Body with scrollable content
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              doctorList(
                distance: "loin 800m",
                image: "lib/icons/male-doctor.png",
                maintext: "Dr. Marcus Horizon",
                numRating: "4.7",
                subtext: "Dentiste",
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: toggleTextVisibility,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A propos",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      showExtendedText
                          ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod elipss this is just a dummy text..."
                          : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod elipss this is just a dummy text ...",
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 37, 37, 37),
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      showExtendedText ? "Lire moins" : "Lire plus",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 1, 128, 111),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.11,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    date_Select(date: "21", maintext: "Lun", onSelect: onDateSelected),
                    date_Select(date: "22", maintext: "Mar", onSelect: onDateSelected),
                    date_Select(date: "23", maintext: "Mer", onSelect: onDateSelected),
                    date_Select(date: "24", maintext: "Jeu", onSelect: onDateSelected),
                    date_Select(date: "25", maintext: "Ven", onSelect: onDateSelected),
                    date_Select(date: "26", maintext: "Sam", onSelect: onDateSelected),
                    date_Select(date: "27", maintext: "Dim", onSelect: onDateSelected),
                    date_Select(date: "28", maintext: "Lun", onSelect: onDateSelected),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.black12, thickness: 1),
              const SizedBox(height: 20),

              // Time selection grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      time_select(mainText: "09:00 AM", onSelect: onTimeSelected),
                      time_select(mainText: "01:00 PM", onSelect: onTimeSelected),
                      time_select(mainText: "04:00 PM", onSelect: onTimeSelected),
                      time_select(mainText: "07:00 PM", onSelect: onTimeSelected),
                    ],
                  ),
                  Column(
                    children: [
                      time_select(mainText: "10:00 AM", onSelect: onTimeSelected),
                      time_select(mainText: "02:00 PM", onSelect: onTimeSelected),
                      time_select(mainText: "05:00 PM", onSelect: onTimeSelected),
                      time_select(mainText: "08:00 PM", onSelect: onTimeSelected),
                    ],
                  ),
                  Column(
                    children: [
                      time_select(mainText: "11:00 AM", onSelect: onTimeSelected),
                      time_select(mainText: "03:00 PM", onSelect: onTimeSelected),
                      time_select(mainText: "06:00 PM", onSelect: onTimeSelected),
                      time_select(mainText: "09:00 PM", onSelect: onTimeSelected),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 247, 247, 247),
                  borderRadius: BorderRadius.circular(18),
                  image: const DecorationImage(
                    image: AssetImage("lib/icons/Chat.png"),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: appointment(
                        selectedDate: selectedDate!,
                        selectedTime: selectedTime!, // Pass the selected time
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 2, 179, 149),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Payer Rendez-Vous",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
