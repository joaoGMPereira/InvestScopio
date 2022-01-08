import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/text_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/button_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginStatusWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginStatusWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginStatusWidgetState createState() => _LoginStatusWidgetState();
}

class _LoginStatusWidgetState extends State<LoginStatusWidget>
    implements BaseSateWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => ViewStateWidget(
            content: content(),
            state: widget.viewModel.state,
            onBackPressed: _onBackPressed,
            onPressed: () {}));
  }

  Widget content() {
    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
                text: widget.viewModel.status?.message ?? '',
                style: Style.description),
            const BoundWidget(BoundType.medium),
            ButtonWidget(
              ButtonType.normal,
              () {
                widget.viewModel.flow =
                    widget.viewModel.status?.next ?? LoginWidgetFlow.init;
              },
              label: widget.viewModel.status?.action ?? '',
            )
          ],
        ),
      );
    });
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow = LoginWidgetFlow.init;
    return false;
  }
}
