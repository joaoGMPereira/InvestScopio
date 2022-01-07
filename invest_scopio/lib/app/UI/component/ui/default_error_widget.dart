import 'package:flutter/material.dart';
import '../text_widget.dart';
import 'bound_widget.dart';

class DefaulErrorWidget extends StatefulWidget {
  const DefaulErrorWidget({Key? key}) : super(key: key);

  @override
  _DefaulErrorWidgetState createState() => _DefaulErrorWidgetState();
}

class _DefaulErrorWidgetState extends State<DefaulErrorWidget> {
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
                      color: Colors.white,
                      onPressed: () {},
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
