// Import necessary packages
import 'package:flutter/material.dart';

// Define a large button widget
class LargeButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;

  // Constructor
  const LargeButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build the elevated button with the specified onPressed function and child widget
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 72,
              width: 72,
              child: FittedBox(child: child),
            ),
          ),
        ],
      ),
    );
  }
}
