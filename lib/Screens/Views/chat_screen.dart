import 'package:denti_plus/modals/chat_messageModal.dart';
import 'package:denti_plus/modals/patientCreateModal.dart';
import 'package:denti_plus/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

import '../../modals/consultationModal.dart';
import '../../modals/enums.dart';
import '../../providers/appointment_provider.dart';
import '../Widgets/chat_info.dart';

class ChatScreen extends StatefulWidget {
  final Consultation consultation;

  const ChatScreen({Key? key, required this.consultation}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late ChatProvider _chatProvider;
  late Future<PatientCreate?> _doctorFuture;
  late ScrollController _scrollController;
  bool _showScrollToBottomButton = false;
  int _lastMessageCount = 0;

  bool get isConsultationClosed {
    return widget.consultation.etat == EtatConsultation.VALIDE ||
        widget.consultation.etat == EtatConsultation.RECONSULTATION ||
        widget.consultation.etat == EtatConsultation.EN_ATTENTE;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _chatProvider.fetchChatHistory(widget.consultation.id!);
    _doctorFuture = _fetchDoctor();

    // Listen to scroll position to show/hide FAB
    _scrollController.addListener(() {
      final isAtBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent - 10;
      if (_showScrollToBottomButton != !isAtBottom) {
        setState(() {
          _showScrollToBottomButton = !isAtBottom;
        });
      }
    });
  }

  Future<PatientCreate?> _fetchDoctor() async {
    try {
      return Provider.of<AppointmentProvider>(context, listen: false)
          .fetchDoctorById(widget.consultation.doctorId!);
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle finishing the conversation with API call and UI feedback.
  Future<void> _handleFinishConversation() async {
    final success =
    await _chatProvider.finishConsultation(widget.consultation.id!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Consultation finished successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _chatProvider.errorMessage ?? "Failed to finish consultation")),
      );
    }
  }

  /// Scroll to the bottom of the chat.
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 100,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Image.asset("lib/icons/back1.png", height: 24, width: 24),
    ),
    title: FutureBuilder<PatientCreate?>(
      future: _doctorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading...",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Text(
            "Dr. Unknown",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
            ),
          );
        }
        final doctor = snapshot.data!;
        return Text(
          'Dr.${doctor.name!}',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 17.sp,
          ),
        );
      },
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Consumer<ChatProvider>(
          builder: (context, prov, _) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 131, 113),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
            ),
            onPressed: (prov.chatHistory.isEmpty ||
                isConsultationClosed ||
                prov.isFinishing)
                ? null
                : _handleFinishConversation,
            child: prov.isFinishing
                ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
                : Text(
              "Finir",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _appBarIcon(String path) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Image.asset(path, height: 24, width: 24),
  );

  Widget _buildChatBubble(ChatMessage msg) {
    final isUser = msg.senderType == MessageSenderType.USER;
    final isDoctor = msg.senderType == MessageSenderType.DOCTOR;

    return Align(
      alignment: isDoctor
          ? Alignment.center // Center doctor messages
          : isUser
          ? Alignment.centerRight // Right-align user messages
          : Alignment.centerLeft, // Left-align other messages
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 70.w),
        margin: isDoctor
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8) // Extra margin for centered messages
            : const EdgeInsets.symmetric(vertical: 8), // Standard margin
        decoration: BoxDecoration(
          color: isDoctor
              ? Colors.blue.shade700 // Distinct color for diagnosis
              : isUser
              ? const Color.fromARGB(255, 0, 131, 113)
              : const Color(0xFFECE8E8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser || isDoctor ? 10 : 0),
            topRight: Radius.circular(isUser ? 0 : 10),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
          ),
        ),
        child: isDoctor
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Réponse docteur:",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white70, // Lighter color for prefix
              ),
            ),
            const SizedBox(height: 4), // Space between prefix and content
            Text(
              msg.content ?? '',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Center text for consistency
            ),
          ],
        )
            : Text(
          msg.content ?? '',
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildClosedConsultationMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        widget.consultation.etat == EtatConsultation.VALIDE
            ? "Cette consultation est validée. Aucun nouveau message ne peut être envoyé."
            : widget.consultation.etat == EtatConsultation.RECONSULTATION
            ? "Cette consultation nécessite un suivi. Veuillez prendre rendez-vous pour une nouvelle consultation."
            : "Cette consultation est en attente. Veuillez attendre la confirmation du médecin.",
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
          fontSize: 14.sp,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          if (isConsultationClosed) _buildClosedConsultationMessage(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !isConsultationClosed,
                  decoration: InputDecoration(
                    hintText: "Type message ...",
                    filled: true,
                    fillColor: isConsultationClosed
                        ? Colors.grey[200]
                        : const Color.fromARGB(255, 247, 247, 247),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset("lib/icons/pin.png",
                          height: 24, width: 24),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(FontAwesomeIcons.telegram,
                    color: isConsultationClosed ? Colors.grey : Colors.teal,
                    size: 40),
                onPressed: isConsultationClosed || _chatProvider.isSending
                    ? null
                    : () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;
                  print('Sending message: $text');
                  _chatProvider.sendMessage(widget.consultation.id!, text);
                  _controller.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Consumer<ChatProvider>(
        builder: (context, prov, child) {
          // Auto-scroll to bottom when new messages are added
          if (prov.chatHistory.length > _lastMessageCount) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            _lastMessageCount = prov.chatHistory.length;
          }

          if (prov.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.errorMessage != null) {
            return Center(
              child: Text(prov.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(18),
                  itemCount: prov.chatHistory.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return chat_info(
                          name: "Consultation ${widget.consultation.id}");
                    }
                    final msg = prov.chatHistory[i - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _buildChatBubble(msg),
                    );
                  },
                ),
              ),
              _buildMessageInputField(),
            ],
          );
        },
      ),
      floatingActionButton: _showScrollToBottomButton
          ? FloatingActionButton(
        onPressed: _scrollToBottom,
        backgroundColor: Colors.teal,
        child: const Icon(FontAwesomeIcons.arrowDown, color: Colors.white),
        mini: true,
      )
          : null,
      floatingActionButtonLocation: _CustomFabLocation(),
    );
  }
}

/// Custom FAB location to position the button higher.
class _CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Default end-bottom alignment
    final double fabX = scaffoldGeometry.scaffoldSize.width - 16 - 40; // FAB width ~40
    // Move up by 80 pixels to avoid overlap with send button
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        16 -
        80; // Adjusted upward
    return Offset(fabX, fabY);
  }

  @override
  String toString() => '_CustomFabLocation';
}