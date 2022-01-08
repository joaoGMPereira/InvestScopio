import 'package:flutter/cupertino.dart';
import 'package:invest_scopio/app/UI/Core/view_state.dart';
import 'package:invest_scopio/app/UI/component/ui/default_error_widget.dart';

import 'loading_widget.dart';

class ViewStateWidget extends StatelessWidget {
  final Widget content;
  final ViewState state;
  final VoidCallback onPressed;
  final WillPopCallback onBackPressed;

  const ViewStateWidget(
      {required this.content,
      required this.state,
      required this.onBackPressed,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ViewState.loading:
        return const LoadingWidget();
      default:
        return _scope(content);
    }
  }

  Widget _scope(Widget content) {
    return WillPopScope(child: content, onWillPop: onBackPressed);
  }
}
