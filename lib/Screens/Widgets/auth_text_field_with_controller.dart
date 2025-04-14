import 'package:flutter/material.dart';

class Auth_text_field_with_controller extends StatefulWidget {
  final String text;
  final String icon;
  final bool isPassword;
  final TextEditingController? controller; // <-- New controller property

  Auth_text_field_with_controller({
    required this.text,
    required this.icon,
    this.isPassword = false,
    this.controller, // <-- Optional parameter
  });

  @override
  _Auth_text_fieldState createState() => _Auth_text_fieldState();
}

class _Auth_text_fieldState extends State<Auth_text_field_with_controller> {
  bool _obscureText = true; // For password visibility toggling

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          controller: widget.controller, // <-- Assign the passed controller
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.none,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: TextInputType.emailAddress,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusColor: Colors.black26,
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(widget.icon),
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
                    ? 'assets/EyeSlashON.png'
                    : 'assets/EyeSlash.png',
                height: 24,
                width: 24,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
      ),
    );
  }
}
