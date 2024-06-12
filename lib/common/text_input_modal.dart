import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/main.dart';

class TextInputModal extends StatefulWidget {
  final String value;
  final String hintText;
  final String buttonText;
  final Function(String)? onConfirm;
  const TextInputModal({super.key, required this.value, this.onConfirm, required this.hintText, required this.buttonText});

  @override
  State<TextInputModal> createState() => _TextInputModalState();
}

class _TextInputModalState extends State<TextInputModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Input(
              controller: _controller,
              hintText: widget.hintText,
              isPassword: false,
              onChanged: (String value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Button(
              color: _controller.text.isEmpty ? Colors.grey : primaryColor,
              text: widget.buttonText,
              onPressed: () async {
                Navigator.pop(context);
                if (widget.onConfirm != null) {
                  await widget.onConfirm!(_controller.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
