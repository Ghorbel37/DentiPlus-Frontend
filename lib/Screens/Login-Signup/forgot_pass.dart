import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab1.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab2.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SizedBox(
            height: 30,
            width: 30,
            child: Image.asset("lib/icons/back2.png"),
          ),
          onPressed: () {
            Navigator.pop(context); // Retourner à l’écran précédent
          },
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              "Mot de passe oublié?",
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Entrez votre email ou votre téléphone, \npour recevoir un code de confirmation",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                height: 50, // Fixer la hauteur pour éviter les bugs d'affichage
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromARGB(255, 3, 190, 150),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25), // Éviter le débordement de l'indicateur
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: const Color.fromARGB(255, 3, 190, 150),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab, // L’indicateur prend toute la taille de l’onglet
                    labelPadding: EdgeInsets.zero, // Évite le décalage du texte
                    unselectedLabelColor: Colors.black54,
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    tabs: const [
                      Expanded(
                        child: Tab(text: "Email"),
                      ),
                      Expanded(
                        child: Tab(text: "Téléphone"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [tab1(), tab2()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
