import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Widgets/profile_list.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:denti_plus/Screens/Login-Signup/register.dart';
import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:denti_plus/Screens/Login-Signup/SettingsPage.dart';
import 'package:denti_plus/Screens/Widgets/auth_social_login.dart';
import 'package:page_transition/page_transition.dart';

import '../../providers/auth_provider.dart';

class Profile_screen extends StatelessWidget {
  const Profile_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 185, 155),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Center(
              child: Stack(
                children: [
                  const SizedBox(height: 100),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1))
                        ],
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage("lib/icons/avatar.png"),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.white),
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage("lib/icons/camra.png"))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Amelia Renata",
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 30),

            /// 📌 Section avec les infos (Calories, Poids, F cardiaque)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildProfileStat(
                      "lib/icons/callories.png", "Calories", "103lbs"),
                  Container(height: 50, width: 1, color: Colors.white),
                  buildProfileStat("lib/icons/weight.png", "Poids", "756cal"),
                  Container(height: 50, width: 1, color: Colors.white),
                  buildProfileStat(
                      "lib/icons/heart.png", "F cardiaque", "215bpm"),
                ],
              ),
            ),

            const SizedBox(height: 180),

            /// 📌 Section avec les options (Paramètres, Déconnexion)
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  /// 🔹 **Paramètres (Redirection vers une autre page)**
                  profile_list(
                    image: "lib/icons/pay.png",
                    title: "Paramètres",
                    color: Colors.black87,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()), // Remplace par ta page
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Divider(),
                  ),

                  /// 🔹 **Déconnexion (Affiche une boîte de dialogue)**
                  profile_list(
                    image: "lib/icons/logout.png",
                    title: "Déconnexion",
                    color: Colors.red,
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Widget pour afficher les statistiques (Calories, Poids, etc.)
  Widget buildProfileStat(String iconPath, String label, String value) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(iconPath), filterQuality: FilterQuality.high),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ],
    );
  }
}

/// 📌 Fonction pour afficher la boîte de dialogue de déconnexion
void showLogoutDialog(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with circular effect
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Light background
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/Group_135.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                "Êtes-vous sûr de vouloir\nvous déconnecter ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              Text(
                "Vous pouvez vous reconnecter à tout moment avec vos identifiants Denti+.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Call logout from the provider
                    await Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: Login(),
                      ),
                          (Route<dynamic> route) => false, // Remove all previous screens
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03BE96), // Green color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text(
                    "Se déconnecter",
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



