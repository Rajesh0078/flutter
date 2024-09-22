import 'package:flutter/material.dart';
import 'package:swype/routes/route_generate.dart';
import 'package:swype/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swype',
      initialRoute: '/',
      theme: CAppTheme.appTheme,
      onGenerateRoute: generateRoute,
    );
  }
}
