import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/ui/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const id = '/splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    _navigateToHomeScreenAfterThreeSeconds(context);
    super.didChangeDependencies();
  }

  void _navigateToHomeScreenAfterThreeSeconds(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      color: theme.backgroundColor,
      child:Image.network(
          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif')
    );
  }
}
