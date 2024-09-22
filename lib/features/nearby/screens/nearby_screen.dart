import 'package:flutter/material.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/routes/app_routes.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        body: const Center(
          child: Text("Nearby Screen"),
        ),
        bottomNavigationBar: customBottomBar(context, AppRoutes.nearby),
      ),
    );
  }
}
