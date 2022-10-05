import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key? key, this.onPressed, required this.child})
      : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: child);
  }
}
