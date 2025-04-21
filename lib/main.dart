import 'package:denti_plus/Screens/Widgets/RootWrapper.dart';
import 'package:denti_plus/providers/appointment_provider.dart';
import 'package:denti_plus/providers/chat_provider.dart';
import 'package:denti_plus/providers/conversation_provider.dart';
import 'package:denti_plus/providers/doctor_consultations_provider.dart';
import 'package:denti_plus/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


// Screens
import 'package:denti_plus/Screens/Views/Screen1.dart';

// Providers
import 'package:denti_plus/providers/auth_provider.dart';
// Later, you’ll add others like:
// import 'package:denti_plus/providers/doctor_provider.dart';
// import 'package:denti_plus/providers/patient_provider.dart';

// lib/main.dart
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
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => DoctorConsultationsProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr'), // French locale
            ],
            home: FutureBuilder(
              future: _initializeApp(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const RootWrapper();
                }
                return const SplashScreen();
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _initializeApp(BuildContext context) async {
    // Initialize auth state
    await Provider.of<AuthProvider>(context, listen: false).initAuth();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}