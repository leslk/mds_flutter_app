import 'package:flutter/material.dart';
import 'package:mds_flutter_app/main.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  const Button({super.key, required this.onPressed, required this.text, this.color = primaryColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(color),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
