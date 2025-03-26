import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:denti_plus/Screens/Login-Signup/register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class login_signup extends StatelessWidget {
  const login_signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(
          height: 200,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/Vector (1).png",
                width: MediaQuery.of(context).size.width * 0.2,
                fit: BoxFit.cover,
              ),
              Image.asset(
                "assets/Content.png",
                width: MediaQuery.of(context).size.width * 0.2,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "C'est parti !",
              style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  color: const Color.fromARGB(211, 14, 13, 13),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Connectez-vous pour profiter des \nfonctionnalités que nous avons \nfournies et rester en bonne santé!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: const Color.fromARGB(211, 14, 13, 13),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade, // Adds smooth fade + slide effect
                    duration: const Duration(milliseconds: 800), // Adjust duration for smoothness
                    curve: Curves.easeInOut, // Smooth transition
                    child: const Login(),
                  )
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 190, 150),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Se connecter",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(30)),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade, // Adds smooth fade + slide effect
                      duration: const Duration(milliseconds: 800), // Adjust duration for smoothness
                      curve: Curves.easeInOut, // Smooth transition
                      child: const Register()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "S'inscrire",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: const Color.fromARGB(255, 3, 190, 150),
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
