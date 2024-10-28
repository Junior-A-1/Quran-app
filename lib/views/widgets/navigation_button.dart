import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;

  NavigationButtons({
    required this.onNextPressed,
    required this.onPreviousPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onPreviousPressed,
          child: Text('Previous'),
        ),
        ElevatedButton(
          onPressed: onNextPressed,
          child: Text('Next'),
        ),
      ],
    );
  }
}
