import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:denti_plus/Screens/Views/Homepage.dart';
import 'package:denti_plus/Screens/Widgets/chat_doctor.dart';
import 'package:denti_plus/Screens/Widgets/chat_info.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildChatMessages()),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  // AppBar with navigation and icons
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 100,
      leading: IconButton(
        onPressed: () => Navigator.pop(
          context
        ),
        icon: Image.asset("lib/icons/back1.png", height: 24, width: 24),
      ),
      title: Text(
        "Dr. Marcus Horizon",
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
        ),
      ),
      actions: [
        _buildAppBarIcon("lib/icons/video_call.png"),
        _buildAppBarIcon("lib/icons/call.png"),
        _buildAppBarIcon("lib/icons/more.png"),
      ],
    );
  }

  // Function to create AppBar icons
  Widget _buildAppBarIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Image.asset(assetPath, height: 24, width: 24),
    );
  }

  // Chat Messages ListView
  Widget _buildChatMessages() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const chat_info(),
        const SizedBox(height: 20),
        const chat_doctor(),
        const SizedBox(height: 15),
        _buildChatBubble("Hello. How can I help you?", false),
        const SizedBox(height: 15),
        _buildChatBubble(
          "I have been suffering from headache and cold for 3 days. I took 2 tablets of Dolo, but still in pain.",
          true,
        ),
      ],
    );
  }

  // Chat Bubble UI
  Widget _buildChatBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 70.w),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 0, 131, 113) : const Color(0xFFECE8E8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 10 : 0),
            topRight: Radius.circular(isUser ? 0 : 10),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
          ),
        ),
        child: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Message Input Field
  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type message ...",
                filled: true,
                fillColor: const Color.fromARGB(255, 247, 247, 247),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset("lib/icons/pin.png", height: 24, width: 24),
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
            icon: Icon(FontAwesomeIcons.telegram , color: Colors.teal, size: 40),
            onPressed: () {
              // Implement send message function
            },
          ),
        ],
      ),
    );
  }
}
