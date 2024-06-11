import 'package:flutter/material.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/views/login_checker_view.dart';
import 'dart:async';

/// This is the SplashScreenView class.
/// This class is a StatefulWidget that will be displayed when the app is launched.
class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  /// This method will be called when the state is initialized.
  @override
  void initState() {
    super.initState();

    /// Call the setAppView method
    setAppView();
  }

  /// This method will navigate to the LoginCheckerView after 3 seconds.
  void setAppView() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginCheckerView()));
    });
  }

  /// Build the SplashScreenView
  /// This is a simple presentation screen with the app name that will be displayed for 3 seconds.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'MDS FLUTTER APP',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
