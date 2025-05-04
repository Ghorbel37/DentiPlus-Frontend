import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class date_Select extends StatelessWidget {
  final DateTime date;
  final String maintext;
  final Function(DateTime) onSelect;
  final bool isSelected;

  const date_Select({
    required this.date,
    required this.maintext,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(date),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.02,
          width: MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 2, 179, 149)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  maintext,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                ),
                Text(
                  DateFormat('d').format(date),
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    color: isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 27, 27, 27),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}