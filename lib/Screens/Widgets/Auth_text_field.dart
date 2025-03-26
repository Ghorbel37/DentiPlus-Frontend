import 'package:flutter/material.dart';

class Auth_text_field extends StatefulWidget {
  final String text;
  final String icon;
  final bool isPassword; // Add this property to differentiate password fields

  Auth_text_field({
    required this.text,
    required this.icon,
    this.isPassword = false, // Default to false (not a password field)
  });

  @override
  _Auth_text_fieldState createState() => _Auth_text_fieldState();
}

class _Auth_text_fieldState extends State<Auth_text_field> {
  bool _obscureText = true; // State for password visibility

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.none,
          obscureText: widget.isPassword ? _obscureText : false,
          // Apply obscureText based on isPassword
          keyboardType: TextInputType.emailAddress,
          // Keep email keyboard for consistency
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusColor: Colors.black26,
            fillColor: Color.fromARGB(255, 247, 247, 247),
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                child: Image.asset(widget.icon),
              ),
            ),
            prefixIconColor: const Color.fromARGB(255, 3, 190, 150),
            label: Text(widget.text),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Image.asset(
                      _obscureText
                          ? 'assets/Eye SlashON.png' // Use your icon image
                          : 'assets/Eye Slash.png',
                      // Use another icon for "off" state
                      height: 24, // Adjust size as needed
                      width: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null, // No suffix icon for non-password fields
          ),
        ),
      ),
    );
  }
}
