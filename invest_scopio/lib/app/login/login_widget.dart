import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:invest_scopio/app/UI/DesignSystemWidgets/ripple_card.dart';
import 'package:invest_scopio/app/core/core_theme.dart';
import 'package:invest_scopio/app/login/login_controller.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWidget extends GetView<LoginController> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("InvestScopio",
                    style: CoreTheme.titleWhite, textAlign: TextAlign.center),
                LogoWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SignInButton(
                    Buttons.Apple,
                    onPressed: () async {
                      try {
                        final credential =
                        await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );
                        _handleSignIn();
                        print(credential);
                      } catch (error) {}
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SignInButton(
                    Buttons.GoogleDark,
                    onPressed: () {
                      _handleSignIn();
                    },
                  ),
                ),
              ])),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
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
      print(_controller.value);
      //  if the full duration of the animation is 8 secs then 0.5 is 4 secs
      if (_controller.value > 0.61) {
// When it gets there hold it there.
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
        fit: BoxFit.fill,
        onLoaded: (comp) {
          _controller
            ..duration = comp.duration
            ..forward();
        });
  }
}
