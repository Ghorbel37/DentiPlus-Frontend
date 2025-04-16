import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Login-Signup/ChangePass.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../providers/auth_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isUpdating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    // Initialize the controllers with stored user values
    _nameController = TextEditingController(text: auth.fetchedUser?.name ?? "");
    _emailController = TextEditingController(text: auth.fetchedUser?.email ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// This function calls the provider to update the user info.
  Future<void> _updateProfile() async {
    setState(() {
      _isUpdating = true;
      _errorMessage = null;
    });

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();

    // Simple validation
    if (newName.isEmpty || newEmail.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs";
        _isUpdating = false;
      });
      return;
    }

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.updateUser(newName, newEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mise à jour réussie!")),
      );
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
        FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
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
            "Paramètres",
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
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Display error message if any
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              // Name TextField with controller attached
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      focusColor: Colors.black26,
                      fillColor: const Color.fromARGB(255, 247, 247, 247),
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset("lib/icons/person.png"),
                      ),
                      labelText: "My name",
                      labelStyle: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
              // Email TextField with controller attached
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _emailController,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      focusColor: Colors.black26,
                      fillColor: const Color.fromARGB(255, 247, 247, 247),
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset("lib/icons/email.png"),
                      ),
                      labelText: "My mail",
                      labelStyle: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Change Password button
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        child: const Changepass(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 161, 168, 176),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    "Changer mot de passe",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Validate ("Valider") button
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    await _updateProfile();
                    if (_errorMessage == null) {
                      showSuccessDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 190, 150),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
              // Bottom decorative images
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
    );
  }
}

/// A simple success dialog that shows upon successful update.
void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
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
