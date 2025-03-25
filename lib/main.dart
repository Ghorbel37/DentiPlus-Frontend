import 'package:flutter/material.dart';
import 'package:denti_plus/Screens/Login-Signup/Profile_screen.dart';
import 'package:denti_plus/Screens/Views/Dashboard_screen.dart';
import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:denti_plus/Screens/Views/Screen1.dart';
import 'package:denti_plus/Screens/Views/appointment.dart';
import 'package:denti_plus/Screens/Views/chat_screen.dart';
import 'package:denti_plus/Screens/Views/doctor_search.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/message_tab_all.dart';
import 'package:denti_plus/Screens/Widgets/TabbarPages/tab1.dart';
import 'package:denti_plus/Screens/Widgets/article.dart';
import 'package:denti_plus/Screens/Login-Signup/forgot_pass.dart';
import 'package:denti_plus/Screens/Login-Signup/login.dart';
import 'package:denti_plus/Screens/Login-Signup/login_signup.dart';
import 'package:denti_plus/Screens/On_Board/on_boarding.dart';
import 'package:denti_plus/Screens/Login-Signup/register.dart';
import 'package:denti_plus/Screens/Login-Signup/verification_code.dart';
import 'package:denti_plus/Screens/Views/articlePage.dart';
import 'package:denti_plus/Screens/Widgets/doctorList.dart';
import 'package:denti_plus/Screens/Login-Signup/shedule_screen.dart';
import 'package:denti_plus/Screens/Views/message_Screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:denti_plus/Screens/Views/find_doctor.dart';
import 'package:denti_plus/Screens/Views/doctor_details_screen.dart';

void main() {
  runApp(const DentiPlus());
}

class DentiPlus extends StatelessWidget {
  const DentiPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Screen1(),
      );
    });
  }
}
