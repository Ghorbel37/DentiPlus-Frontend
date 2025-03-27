import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Widgets/profile_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Widgets/banner.dart';

class Homepagedenti extends StatelessWidget {
  const Homepagedenti({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // ✅ Makes status bar transparent
      statusBarIconBrightness: Brightness.dark, // ✅ Use dark icons for visibility
    ));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imageBack.png"),
                // 🔹 Change le chemin selon ton image
                fit: BoxFit.cover, // 🔹 Couvre tout l'écran
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 500,
                ),
                Container(
                  height: 340,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const BannerWidget(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.0900,
                            width: MediaQuery.of(context).size.width * 0.2500,
                            child: Column(children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.0400,
                                width:
                                    MediaQuery.of(context).size.width * 0.1500,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/Fire.png"),
                                      filterQuality: FilterQuality.high),
                                ),
                              ),
                              Text(
                                "Calories",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 4, 138, 109)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "756cal",
                                style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 4, 138, 109)),
                              )
                            ]),
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: Color.fromARGB(255, 4, 138, 109),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.0900,
                            width: MediaQuery.of(context).size.width * 0.2500,
                            child: Column(children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.0400,
                                width:
                                    MediaQuery.of(context).size.width * 0.1500,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/Barbell.png"),
                                      filterQuality: FilterQuality.high),
                                ),
                              ),
                              Text(
                                "Poids",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 4, 138, 109)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "103lbs",
                                style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 4, 138, 109)),
                              )
                            ]),
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: Color.fromARGB(255, 4, 138, 109),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.0900,
                            width: MediaQuery.of(context).size.width * 0.2500,
                            child: Column(children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.0400,
                                width:
                                    MediaQuery.of(context).size.width * 0.1500,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/Heartbeat.png"),
                                      filterQuality: FilterQuality.high),
                                ),
                              ),
                              Text(
                                "F cardiaque",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 4, 138, 109)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "215bpm",
                                style: GoogleFonts.poppins(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 4, 138, 109)),
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
