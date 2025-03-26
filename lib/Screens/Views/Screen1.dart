import 'dart:async';
import 'package:flutter/material.dart';
import 'package:denti_plus/Screens/On_Board/on_boarding.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return on_boarding();
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 77, 60),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures the column wraps content tightly
          children: [
            Image.asset(
              "assets/Vector.png",
              width: MediaQuery.of(context).size.width * 0.3,
              fit: BoxFit.cover,
            ),
            Image.asset(
              "assets/Content1.png",
              width: MediaQuery.of(context).size.width * 0.3,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
