import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:denti_plus/Screens/Login-Signup/login_signup.dart';
import 'package:denti_plus/Screens/Widgets/Auth_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade, // Adds smooth fade + slide effect
                  duration: const Duration(milliseconds: 800), // Adjust duration for smoothness
                  curve: Curves.easeInOut,
                  child: const Login(),
                ),
              );
            },
          ),
          title: Text(
            "S’inscrire",
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
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.none,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        focusColor: Colors.black26,
                        fillColor: const Color.fromARGB(255, 247, 247, 247),
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            child: Image.asset("lib/icons/person.png"),
                          ),
                        ),
                        prefixIconColor: const Color.fromARGB(255, 3, 190, 150),
                        label: Text(
                          "Entrez votre nom",
                          style: GoogleFonts.poppins(fontSize: 15.sp),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Auth_text_field(
                  text: "Entrez votre mail",
                  icon: "lib/icons/email.png",
                ),
                const SizedBox(height: 5),
                Auth_text_field(
                  text: "Entrez votre mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isChecked, // Use the state variable
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false; // Update the state
                        });
                      },
                    ),
                    Text(
                      "J'accepte les conditions d'utilisation \net la politique de confidentialité de Denti+.",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
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
                      "S'inscrire",
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
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Avez-vous un compte? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop, // Adds smooth fade + slide effect
                            duration: const Duration(milliseconds: 500), // Adjust duration for smoothness
                            curve: Curves.easeInOut,
                            child: const Login(),
                          ),
                        );
                      },
                      child: Text(
                        "Se connecter",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 3, 190, 150),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
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
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Icône de succès (ajoute ton image ici)
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Fond clair circulaire
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/done_24px.png', // Remplace par ton chemin
                  width: 60, // Ajuste la taille
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Titre
              const Text(
                "Succès",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Message
              Text(
                "Votre compte a été enregistré avec succès",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Bouton (ajoute ta couleur)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme la popup
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: Login(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03BE96), // Remplace par ta couleur
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  child: Text(
                    "Se connecter",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}