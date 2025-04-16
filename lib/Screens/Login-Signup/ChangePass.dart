import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:denti_plus/Screens/Widgets/auth_text_field_with_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:denti_plus/Screens/Widgets/Auth_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../Widgets/RootWrapper.dart';

class Changepass extends StatefulWidget {
  const Changepass({super.key});

  @override
  _ChangepassState createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  // Controllers for each password field.
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isUpdating = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates the fields and calls the provider to update the password.
  Future<void> _updatePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Basic field validation.
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs";
      });
      return;
    }

    // Check if new password and confirmation match.
    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = "Les nouveaux mots de passe ne correspondent pas";
      });
      return;
    }

    setState(() {
      _isUpdating = true;
      _errorMessage = null;
    });

    try {
      // Call the provider's updatePassword method.
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updatePassword(currentPassword, newPassword);

      // If no exception is thrown, show a success dialog.
      showSuccessDialog(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard on tap.
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
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Changer MDP",
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
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
                const SizedBox(height: 40),
                // Display error message if any.
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                // Text field for current (old) password.
                Auth_text_field_with_controller(
                  controller: _currentPasswordController,
                  text: "Ancien mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                const SizedBox(height: 5),
                // Text field for new password.
                Auth_text_field_with_controller(
                  controller: _newPasswordController,
                  text: "Nouveau mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                const SizedBox(height: 5),
                // Text field for confirming new password.
                Auth_text_field_with_controller(
                  controller: _confirmPasswordController,
                  text: "Confirmer mot de passe",
                  icon: "lib/icons/lock.png",
                  isPassword: true,
                ),
                const SizedBox(height: 50),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: _isUpdating ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 190, 150),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isUpdating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Valider",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                // Bottom decorative images.
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

/// Displays a success dialog once the password is updated.
void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog.
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: RootWrapper(), // Navigate to your homepage.
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
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/done_24px.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
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
