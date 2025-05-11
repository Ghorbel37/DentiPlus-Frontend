import 'package:denti_plus/modals/appointmentModal.dart';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:denti_plus/Screens/Views/appointment.dart';
import 'package:denti_plus/Screens/Views/find_doctor.dart';
import 'package:denti_plus/Screens/Widgets/date_select.dart';
import 'package:denti_plus/Screens/Widgets/doctorList.dart';
import 'package:denti_plus/Screens/Widgets/list_doctor1.dart';
import 'package:denti_plus/Screens/Widgets/time_select.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../providers/appointment_provider.dart';
import '../../services/api_service.dart';
import 'Homepage.dart';

class DoctorDetails extends StatefulWidget {
  final bool isUpdateMode;
  final Appointment? appointment;

  const DoctorDetails({
    super.key,
    this.isUpdateMode = false,
    this.appointment,
  });

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  late Future<PatientCreate?> _doctorFuture;
  final ApiService _apiService = ApiService();
  bool showExtendedText = false;
  String? selectedDate;
  String? selectedTime;
  late List<DateTime> weekDates;
  DateTime _selectedDateTime = DateTime.now();
  List<TimeOfDay> _timeSlots = [];
  final List<String> _timeStrings = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
    '09:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    _initializeTimeSlots();
    _doctorFuture = _fetchDoctor();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AppointmentProvider>()
          .fetchUnavailableTimes(_selectedDateTime);
    });
  }

  void _initializeTimeSlots() {
    _timeSlots = _timeStrings.map((str) {
      final timeParts = str.split(' ');
      final numbers = timeParts[0].split(':');
      int hour = int.parse(numbers[0]);
      final minute = int.parse(numbers[1]);
      if (timeParts[1] == 'PM' && hour != 12) hour += 12;
      return TimeOfDay(hour: hour, minute: minute);
    }).toList();
  }

  void toggleTextVisibility() {
    setState(() {
      showExtendedText = !showExtendedText;
    });
  }

  // Updated to accept DateTime directly and reset selectedTime
  void onDateSelected(DateTime selectedDay) {
    setState(() {
      _selectedDateTime = selectedDay;
      selectedDate =
          DateFormat('yyyy-MM-dd').format(selectedDay); // Format full date
          selectedTime = null; // Reset selected time when date changes
    });

    context.read<AppointmentProvider>().fetchUnavailableTimes(selectedDay);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AppointmentProvider>()
          .fetchUnavailableTimes(_selectedDateTime);
    });
  }

  void onTimeSelected(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  List<DateTime> getNextWeekDates(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final int firstDayOfWeekIndex =
        MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final int targetWeekday =
        firstDayOfWeekIndex == 0 ? 7 : firstDayOfWeekIndex;
    final int currentWeekday = currentDate.weekday;

    int daysToAdd = (targetWeekday - currentWeekday + 7) % 7;
    DateTime startOfNextWeek = currentDate.add(Duration(days: daysToAdd));

    return List.generate(
        7, (index) => startOfNextWeek.add(Duration(days: index)));
  }

  Widget _buildTimeGridConditional() {
    if (selectedDate == null) {
      return Opacity(
        opacity: 0.3,
        child: IgnorePointer(child: _buildTimeGrid()),
      );
    } else {
      return _buildTimeGrid();
    }
  }

  Widget _buildTimeGrid() {
    final unavailableTimes =
        context.watch<AppointmentProvider>().unavailableTimes;

    return Column(
      children: [
        const Divider(color: Colors.black12, thickness: 1),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _timeSlots.map((time) {
            final timeStr = _formatTime(time);
            final slotDateTime = DateTime(
              _selectedDateTime.year,
              _selectedDateTime.month,
              _selectedDateTime.day,
              time.hour,
              time.minute,
            );

            final isUnavailable = unavailableTimes
                .any((slot) => slot.startTime.isAtSameMomentAs(slotDateTime));

            return time_select(
              mainText: timeStr,
              onSelect: isUnavailable ? null : onTimeSelected,
              isAvailable: !isUnavailable,
              isSelected: selectedTime == timeStr, // Pass selection state
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _handleUpdateAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Veuillez sélectionner une date et une heure")),
      );
      return;
    }

    try {
      final formattedDate = _parseSelectedDateTime();
      await context.read<AppointmentProvider>().changeAppointmentTime(
        widget.appointment!.id!,
        {'dateAppointment': formattedDate.toIso8601String()},
      );
      showSuccessDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  DateTime _parseSelectedDateTime() {
    final dateParts = selectedDate!.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    final timeParts = selectedTime!.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    final localDateTime = DateTime(year, month, day, hour, minute);

    // Convert to UTC before sending to backend
    return localDateTime;
  }

  void _handleNewAppointment() async{
    final doctor = await _doctorFuture;
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: appointment(
          selectedDate: selectedDate!,
          selectedTime: selectedTime!,
          doctor: doctor,
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () async {
          await context.read<AppointmentProvider>().fetchPatientAppointments();
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Return to previous screen
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/done_24px.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Rendez-vous\nmis à jour",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<PatientCreate?> _fetchDoctor() async {
    try {
    if (!widget.isUpdateMode || widget.appointment == null) {
      return await Provider.of<AppointmentProvider>(context, listen: false)
        .fetchDoctor();
    }

      final consultation = await _apiService.getConsultation(widget.appointment!.consultationId!);
      if (consultation.doctorId == null) return null;

      final doctor = await Provider.of<AppointmentProvider>(context, listen: false)
          .fetchDoctorById(consultation.doctorId!);
      return doctor;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    weekDates = getNextWeekDates(context);
    return FutureBuilder<PatientCreate?>(
        future: _doctorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final doctor = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/icons/back1.png"),
                    ),
                  ),
                ),
              ),
              title: Text(
                "Trouver RDV",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 100,
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    doctorList(
                      distance: "loin 800m",
                      image:doctor.profilePhoto ??"lib/icons/male-doctor.png",
                      maintext: 'Dr.${doctor.name}' ?? "Dr. Unknown",
                      numRating: "4.7",
                      subtext: "Dentiste",
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: toggleTextVisibility,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "A propos",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            showExtendedText
                                ? "Dentiste à l'écoute et empathique, je crois en l'importance d'une relation de confiance avec mes patients.\nExpert en dentisterie moderne, je maîtrise les techniques les plus avancées et les technologies de pointe pour diagnostiquer et traiter efficacement diverses affections bucco-dentaires. Mon objectif est de fournir des soins personnalisés et confortables."
                                : "Dentiste à l'écoute et empathique, je crois en l'importance d'une relation de confiance avec mes patients.",
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 37, 37, 37),
                              fontSize: 14.sp,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            showExtendedText ? "Lire moins" : "Lire plus",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 1, 128, 111),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.11,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: weekDates.length,
                        itemBuilder: (context, index) {
                          DateTime date = weekDates[index];
                          String dayAbbreviation =
                              DateFormat('E', 'fr').format(date);
                          // Normalize date for comparison
                          final normalizedDate = DateTime(date.year, date.month, date.day);
                          final normalizedSelectedDate = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day);
                          return date_Select(
                            date: normalizedDate, // Pass full DateTime
                            maintext: dayAbbreviation,
                            onSelect: onDateSelected,
                            isSelected: normalizedDate == normalizedSelectedDate, // Pass selection state
                          );
                        },
                      ),
                    ),
                    //const SizedBox(height: 20),

                    // Time selection grid
                    _buildTimeGridConditional(),
                    const SizedBox(height: 10), // Space for bottom bar
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 247, 247, 247),
                        borderRadius: BorderRadius.circular(18),
                        image: const DecorationImage(
                          image: AssetImage("lib/icons/Chat.png"),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (selectedDate != null && selectedTime != null)
                          ? () {
                        if (widget.isUpdateMode) {
                          _handleUpdateAppointment();
                        } else {
                          _handleNewAppointment();
                        }
                      }
                          : null,
                      child: Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          color: (selectedDate != null && selectedTime != null)
                              ? const Color.fromARGB(255, 2, 179, 149)
                              : const Color.fromARGB(50, 2, 179, 149),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            widget.isUpdateMode
                                ? "Mettre à jour RDV"
                                : "Payer Rendez-Vous",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}