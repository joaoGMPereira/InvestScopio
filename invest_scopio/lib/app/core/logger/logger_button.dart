import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/core/logger/logger.dart';
import 'package:invest_scopio/app/core/logger/logger_store.dart';

class LoggerButton extends StatefulWidget {
  final LoggerStore store;

  LoggerButton(this.store);

  @override
  _LoggerButtonState createState() => _LoggerButtonState(store);
}

class _LoggerButtonState extends State<LoggerButton> {
  LoggerStore _store;
  double xPosition = 20;
  double yPosition = 50;

  _LoggerButtonState(this._store);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => _store.isEnabled
          ? Positioned(
        top: yPosition,
        left: xPosition,
        child: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(() {
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
            });
          },
          child: FloatingActionButton(
            child: Text(
              "Logs",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              Logger.showLogList(context, _store);
            },
          ),
        ),
      )
          : Container(),
    );
  }
}
