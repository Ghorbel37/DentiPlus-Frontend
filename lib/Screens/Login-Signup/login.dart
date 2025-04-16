import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/forgot_pass.dart';
import 'package:denti_plus/Screens/Login-Signup/login_signup.dart';
import 'package:denti_plus/Screens/Login-Signup/register.dart';
import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:denti_plus/Screens/Widgets/Auth_text_field.dart';
import 'package:denti_plus/Screens/Widgets/auth_social_login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Dentist_Space/DentistHome.dart';
import '../Widgets/auth_text_field_with_controller.dart';
import 'package:denti_plus/providers/auth_provider.dart'; // ✅ Import
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.login(_emailController.text, _passwordController.text);

    if (auth.user != null) {
      // Login successful ✅
      showSuccessDialog(context);
    } else if (auth.errorMessage != null) {
      // Show error message ❌
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mail ou mot de passe non validé"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context,auth,_) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
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
                      child: const login_signup(),
                    ),
                  );
                },
              ),
              centerTitle: true,
              title: Text(
                "Connection",
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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Auth_text_field_with_controller(
                      text: "Entrez votre email",
                      icon: "lib/icons/email.png",
                      controller: _emailController, // ✅ capture email
                    ),
                    const SizedBox(height: 5),
                    Auth_text_field_with_controller(
                      text: "Entrez votre mot de passe",
                      icon: "lib/icons/lock.png",
                      isPassword: true,
                      controller: _passwordController, // ✅ capture password
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade, // Adds smooth fade + slide effect
                                duration: const Duration(milliseconds: 800), // Adjust duration for smoothness
                                curve: Curves.easeInOut,
                                child: const ForgotPass(),
                              ),
                            );
                          },
                          child: Text(
                            "Mot de passe oublié ?",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: const Color.fromARGB(255, 3, 190, 150),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (auth.isLoading)
                      const CircularProgressIndicator(), // 🔄 loading indicator
                    const SizedBox(height: 15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () => _login(context), // ✅ handle login
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 190, 150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Vérifier",
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas de compte? ",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade, // Adds smooth fade + slide effect
                                duration: const Duration(milliseconds: 800), // Adjust duration for smoothness
                                curve: Curves.easeInOut,
                                child: const Register(),
                              ),
                            );
                          },
                          child: Text(
                            "Inscrivez-vous",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: const Color.fromARGB(255, 3, 190, 150),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Ou",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 30),
                    auth_social_logins(
                      logo: "images/google.png",
                      text: "Sign in with Google",
                    ),
                    const SizedBox(height: 20),
                    auth_social_logins(
                      logo: "images/apple.png",
                      text: "Sign in Apple",
                    ),
                    const SizedBox(height: 20),
                    auth_social_logins(
                      logo: "images/facebook.png",
                      text: "Sign in facebook",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void showSuccessDialog(BuildContext context) {
  final auth = Provider.of<AuthProvider>(context, listen: false); // Access the user role
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
                "Ouais ! Bon retour !",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Message
              Text(
                "Vous êtes à nouveau connecté à l'application Denti+",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Bouton (ajoute ta couleur)
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Ferme la popup
                  // Navigate based on user role
                  final prefs = await SharedPreferences.getInstance();
                  final role = prefs.getString('role') ?? '';
                  if (role == "PATIENT") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Homepage(),
                      ),
                          (route) => false,
                    );
                  } else if (role == "DOCTOR") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Dentisthome(),
                      ),
                          (route) => false,
                    );
                  } else {
                    // fallback: if role is unknown
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Rôle inconnu. Contactez l'administrateur.")),
                    );
                  }
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
                    "Entrer",
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
