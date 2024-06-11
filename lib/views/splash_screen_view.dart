import 'package:flutter/material.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/views/login_checker_view.dart';
import 'dart:async';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();

    isLogin();
  }

  void isLogin() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginCheckerView()));
    });
  }

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
