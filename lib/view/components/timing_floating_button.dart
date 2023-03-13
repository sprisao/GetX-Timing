import 'package:flutter/material.dart';

import '../../style/theme.dart';

class CustomFloatingButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const CustomFloatingButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: FloatingActionButton(
        backgroundColor: ColorTheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
