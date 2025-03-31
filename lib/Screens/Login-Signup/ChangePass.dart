import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:denti_plus/Screens/Login-Signup/login_signup.dart';
import 'package:denti_plus/Screens/Widgets/Auth_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Profile_screen.dart';

class Changepass extends StatefulWidget {
  const Changepass({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Changepass> {
  bool _isChecked = false; // State to manage checkbox value
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("lib/icons/back2.png"),
            ),
            onPressed: () {
              Navigator.pop(
                  context
              );
            },
          ),
          title: Text(
            "Changer MDP",
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          toolbarHeight: 110,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView( // Added SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Auth_text_field(
                  text: "Ancien mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                const SizedBox(height: 5),
                Auth_text_field(
                  text: "nouveau mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                const SizedBox(height: 5),
                Auth_text_field(
                  text: "confirmer mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                const SizedBox(height: 50),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform verification or other actions here
                      showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 190, 150),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Valider",
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

                const SizedBox(height: 80),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/Vector1.png",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop(); // Ferme le dialog
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: Homepage(), // Remplace par ta page cible
          ),
        );
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Icône de succès
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Fond clair circulaire
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/done_24px.png', // Remplace par ton chemin
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Titre centré
              const Center(
                child: Text(
                  "Données \nmises à jour",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
