import 'package:flutter/material.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/routes/app_routes.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        body: const Center(
          child: Text("Chat Screen"),
        ),
        bottomNavigationBar: customBottomBar(context, AppRoutes.chat),
      ),
    );
  }
}
