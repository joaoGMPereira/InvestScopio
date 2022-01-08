import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/state/view_state_widget.dart';
import 'package:invest_scopio/app/UI/component/text_widget.dart';
import 'package:invest_scopio/app/UI/component/ui/bound_widget.dart';

import '../../login_view_model.dart';
import '../login_flow.dart';

class LoginErrorWidget extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginErrorWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  _LoginErrorWidgetState createState() => _LoginErrorWidgetState();
}

class _LoginErrorWidgetState extends State<LoginErrorWidget>
    implements BaseSateWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => ViewStateWidget(
              content: content(),
              onBackPressed: _onBackPressed,
              state: widget.viewModel.state,
              onPressed: () {},
            ));
  }

  Future<bool> _onBackPressed() async {
    widget.viewModel.flow =
        widget.viewModel.status?.next ?? LoginWidgetFlow.init;
    return false;
  }

  @override
  Widget content() {
    return Column(
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
                onPressed: widget.viewModel.retry,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
