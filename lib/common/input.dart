import 'package:flutter/material.dart';
import 'package:mds_flutter_app/main.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  const Input({super.key, required this.controller, required this.hintText, required this.isPassword, this.onChanged, this.focusNode});
  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: !isPasswordVisible && widget.isPassword,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword && !isPasswordVisible
            ? IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  setState(() => isPasswordVisible = !isPasswordVisible);
                },
              )
            : widget.isPassword && isPasswordVisible
                ? IconButton(
                    icon: const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() => isPasswordVisible = !isPasswordVisible);
                    },
                  )
                : null,
        hintText: widget.hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 222, 222, 222)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        fillColor: lightGrey,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 196, 196, 196)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
