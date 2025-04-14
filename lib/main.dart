import 'package:denti_plus/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Screens
import 'package:denti_plus/Screens/Views/Screen1.dart';

// Providers
import 'package:denti_plus/providers/auth_provider.dart';
// Later, you’ll add others like:
// import 'package:denti_plus/providers/doctor_provider.dart';
// import 'package:denti_plus/providers/patient_provider.dart';

void main() {
  runApp(const DentiPlus());
}

class DentiPlus extends StatelessWidget {
  const DentiPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        // Add more providers here as you build them:
        // ChangeNotifierProvider(create: (_) => DoctorProvider()),
        // ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Screen1(), // You can replace with Login if needed
          );
        },
      ),
    );
  }
}
