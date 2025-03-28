import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:denti_plus/Screens/Widgets/doctorList.dart';
import 'package:denti_plus/Screens/Views/doctor_details_screen.dart';

class appointment extends StatefulWidget {
  final String selectedDate;
  final String selectedTime;

  const appointment({super.key, required this.selectedDate, required this.selectedTime});

  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  String _selectedPaymentMethod = "Visa"; // Default selected value
  final List<String> _paymentMethods = ["Visa", "Mastercard", "D17", "PayPal"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageTransition(type: PageTransitionType.fade, child: DoctorDetails()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("lib/icons/back1.png", height: 24, width: 24),
          ),
        ),
        title: Text(
          "Top Doctors",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  doctorList(
                    distance: "800m away",
                    image: "lib/icons/male-doctor.png",
                    maintext: "Dr. Marcus Horizon",
                    numRating: "4.7",
                    subtext: "Cardiologist",
                  ),
                  SizedBox(height: 15),

                  // ** Date & Time Selection **
                  buildSectionTitle("Date"),
                  buildDetailRow("lib/icons/callender.png", "${widget.selectedDate} | ${widget.selectedTime}"),

                  // ** Reason Selection **
                  SizedBox(height: 15),
                  buildSectionTitle("Reason"),
                  buildDetailRow("lib/icons/pencil.png", "Chest pain"),

                  // ** Payment Details **
                  SizedBox(height: 20),
                  buildSectionTitle("Payment Details"),
                  buildPaymentRow("Consultation", "\$60"),
                  buildPaymentRow("Admin Fee", "\$1.00"),
                  buildPaymentRow("Additional Discount", "-"),
                  Divider(color: Colors.black12, thickness: 1),
                  buildPaymentRow("Total", "\$61.00", isTotal: true),

                  // ** Payment Method Selection with Dropdown **
                  SizedBox(height: 20),
                  Text("Payment Method", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPaymentMethod,
                        isExpanded: true,
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 10), // Fix icon misalignment
                          child: Icon(Icons.credit_card, color: Colors.black54),
                        ),
                        items: _paymentMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method, style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black87)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPaymentMethod = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ** Fixed Booking Button at Bottom **
          SafeArea(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 2, 179, 149),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  "Book Appointment",
                  style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Function for Titles
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  // Helper Function for Date/Reason Rows
  Widget buildDetailRow(String iconPath, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 247, 247, 247),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Image.asset(iconPath, height: 24, width: 24)), // Fixed icon alignment
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Function for Payment Details
  Widget buildPaymentRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 15.sp, color: isTotal ? Colors.black87 : Colors.black54, fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(fontSize: 16.sp, color: isTotal ? Color.fromARGB(255, 4, 92, 58) : Colors.black87, fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
