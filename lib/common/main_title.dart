import 'package:flutter/material.dart';

class MainTitle extends StatelessWidget {
  final String text;
  const MainTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center);
  }
}
