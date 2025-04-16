// lib/Screens/Widgets/RootWrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:denti_plus/providers/auth_provider.dart';
import 'package:denti_plus/Screens/Views/Homepage.dart';      // Patient home screen
import 'package:denti_plus/Screens/Dentist_Space/Dentisthome.dart'; // Doctor home screen
import 'package:denti_plus/Screens/Views/Screen1.dart';

// lib/Screens/Widgets/RootWrapper.dart
class RootWrapper extends StatelessWidget {
  const RootWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Show loading until auth initializes

    // User is logged in
    if (auth.userDetect != null && auth.userDetect!.role != null) {
      switch (auth.userDetect!.role!.toUpperCase()) {
        case "PATIENT":
          return Homepage();
        case "DOCTOR":
          return Dentisthome();
        default:
          return const Screen1();
      }
    }

    // No valid session - show onboarding
    return const Screen1();
  }
}