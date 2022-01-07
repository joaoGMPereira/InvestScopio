import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/text_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginOtpQRWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginOtpQRWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginOtpQRWidgetState createState() => _LoginOtpQRWidgetState();
}

class _LoginOtpQRWidgetState extends State<LoginOtpQRWidget>
    implements BaseSateWidget {
  var isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => ViewStateWidget(
              content: content(),
              onBackPressed: _onBackPressed,
              state: widget.viewModel.state,
            ));
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow = LoginWidgetFlow.init;
    return false;
  }

  @override
  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextWidget(text: "Scaneie o QR", style: Style.description),
        const BoundWidget(BoundType.small),
        QrImage(
          data: widget.viewModel.otpQR ?? '',
          version: QrVersions.auto,
          size: 200.0,
        ),
        Observer(builder: (_) {
          return Container();
        }),
      ],
    );
  }
}
