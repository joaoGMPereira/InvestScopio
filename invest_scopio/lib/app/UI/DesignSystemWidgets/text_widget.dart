import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextWidgetType type;
  TextWidget({required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: type.style(context));
  }
}

enum TextWidgetType { Headline, Subheadline, Body, Caption }

extension TextWidgetTypeExtension on TextWidgetType {
  TextStyle? style(BuildContext context) {
    switch(this) {
      case TextWidgetType.Headline:
        return Theme.of(context).textTheme.headline5;
      case TextWidgetType.Subheadline:
        return Theme.of(context).textTheme.headline3;
      case TextWidgetType.Body:
        return Theme.of(context).textTheme.bodyText1;
      case TextWidgetType.Caption:
        return Theme.of(context).textTheme.caption;
    }
  }
}
