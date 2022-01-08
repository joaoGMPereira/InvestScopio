import 'package:flutter/material.dart';
import '../text_widget.dart';
import 'bound_widget.dart';

class DefaultErrorWidget extends StatefulWidget {
  final VoidCallback onPressed;

  const DefaultErrorWidget({required this.onPressed, Key? key})
      : super(key: key);

  @override
  _DefaultErrorWidgetState createState() => _DefaultErrorWidgetState();
}

class _DefaultErrorWidgetState extends State<DefaultErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextWidget(text: "Tente Novamente", style: Style.subtitle),
              const BoundWidget(BoundType.medium),
              Material(
                color: Colors.transparent,
                child: Center(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: widget.onPressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    return false;
  }
}
