import 'package:flutter/material.dart';

class time_select extends StatelessWidget {
  final String mainText;
  final Function(String)? onSelect;
  final bool isAvailable;
  final bool isSelected;

  const time_select({
    required this.mainText,
    this.onSelect,
    this.isAvailable = true,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? () => onSelect?.call(mainText) : null,
      child: Opacity(
        opacity: isAvailable ? 1 : 0.5,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.2700,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 2, 179, 149)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isAvailable ? Colors.black12 : Colors.red,
            ),
          ),
          child: Center(
            child: Text(
              mainText,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color.fromARGB(255, 85, 85, 85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}