import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

import '../../providers/doctor_consultations_provider.dart';
import 'cons_card.dart';

class ConsultationCard extends StatefulWidget {
  const ConsultationCard({super.key});

  @override
  _ConsultationsCardState createState() => _ConsultationsCardState();
}

class _ConsultationsCardState extends State<ConsultationCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Fetch consultations on screen init.
      final provider = Provider.of<DoctorConsultationsProvider>(context, listen: false);
      provider.fetchConsultations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<DoctorConsultationsProvider>(
          builder: (context, provider, _) {
            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: GoogleFonts.openSans(color: Colors.red),
                ),
              );
            }

            final encoreList = provider.encoreConsultations;
            if (encoreList.isEmpty) {
              return Center(
                child: Text(
                  'Aucune consultation trouvé',
                  style: GoogleFonts.openSans(fontSize: 20.sp),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.px),
              itemCount: encoreList.length,
              separatorBuilder: (_, __) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final cons = encoreList[index];
                // Assuming Consultation has fields patientName and dateTime
                final patient = provider.getPatient(cons.patientId!);
                final patientName = patient?.name ?? 'Patient';
                final dateTime = cons.date ?? DateTime.now();
                return ConsCard(
                  mainText: patientName,
                  subText: 'Patient',
                  date: DateFormat('dd/MM/yyyy').format(dateTime),
                  time: DateFormat('hh:mm a').format(dateTime),
                  idCons: cons.id!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
