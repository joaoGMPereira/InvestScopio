import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottie/lottie.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              child: Text("Logar"),
              onPressed: () {
                Modular.to.pushReplacementNamed("/home/");
              })),
    );
  }
}

class LogoWidget extends StatefulWidget {
  @override
  _LogoWidgetState createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if (_controller.value > 0.61) {
        _controller.value = 0.61;
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lottie/logo.json',
        controller: _controller,
        width: 100,
        height: 100,
        fit: BoxFit.fill, onLoaded: (comp) {
      _controller
        ..duration = comp.duration
        ..forward();
    });
  }
}
