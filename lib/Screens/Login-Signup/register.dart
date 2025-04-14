import 'package:denti_plus/Screens/Widgets/auth_text_field_with_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:denti_plus/Screens/Login-Signup/login_signup.dart';
import 'package:denti_plus/Screens/Widgets/Auth_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:denti_plus/modals/patientModal.dart';
import 'package:denti_plus/providers/patient_provider.dart';

import '../../modals/enums.dart';
import '../../modals/patientCreateModal.dart';
import '../../modals/userModalRe.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isChecked = false; // State to manage checkbox value
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register(BuildContext context) async {
    final provider = Provider.of<PatientProvider>(context, listen: false);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || !_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs et accepter les conditions."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final creationData = PatientCreate(
        email: email,
        name: name,
        calories: 0,
        frequenceCardiaque: 0,
        poids: 0,
        password: password,
      );

      // Call the provider to create a new patient (which includes the nested user)
      await provider.createPatient(creationData);

      if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!), backgroundColor: Colors.red),
        );
      } else {
        showSuccessDialog(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, provider, _) {
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
                    Auth_text_field_with_controller(
                      text: "Entrez votre nom",
                      icon: "lib/icons/person.png",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 5),
                    Auth_text_field_with_controller(
                      text: "Entrez votre mail",
                      icon: "lib/icons/email.png",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 5),
                    Auth_text_field_with_controller(
                      text: "Entrez votre mot de passe",
                      icon: "lib/icons/lock.png",
                      isPassword: true,
                      controller: _passwordController,
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
                    if (provider.isLoading) const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: provider.isLoading ? null : () => _register(context),
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
      },
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