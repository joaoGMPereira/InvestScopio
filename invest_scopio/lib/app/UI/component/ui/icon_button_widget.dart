import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const IconButtonWidget({required this.icon, this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return normal(context);
  }

  Widget normal(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}