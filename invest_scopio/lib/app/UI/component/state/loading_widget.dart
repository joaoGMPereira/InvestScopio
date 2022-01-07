import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final Alignment align;

  const LoadingWidget(
      {this.align = Alignment.center,
      this.width = 100.00,
      this.height = 100.00,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: CircularProgressIndicator(strokeWidth: 2),
      alignment: align,
    );
  }
}
