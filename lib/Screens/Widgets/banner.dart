import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 17.h,
        width: 150.w,
        decoration: BoxDecoration(
          color: const Color(0xFFECE8E8), // Couleur plus visible
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // Contenu principal (Texte + Bouton)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Protégez-vous \net votre famille",
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF048A6D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                    ),
                    child: Text(
                      "Commencer une consultation",
                      style: GoogleFonts.poppins(
                        fontSize: 15.5.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Icône positionnée en haut à droite
            Positioned(
              right: -50,
              top: -70,
              child: Image.asset(
                "assets/Category.png",
                height: 30.h, // Taille ajustée
              ),
            ),
          ],
        ),
      ),
    );
  }
}
