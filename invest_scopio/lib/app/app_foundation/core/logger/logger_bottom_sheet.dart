import 'package:flutter/material.dart';

class LoggerBottomSheet {
  static _show(BuildContext parentContext, Widget child,
      {double? height, Function? onDismissed}) {
    showModalBottomSheet(
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: parentContext,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(parentContext).padding.top),
          child: height != null
              ? Container(
                  height: height,
                  child: child,
                )
              : child,
        );
      },
    ).whenComplete(() {
      if (onDismissed != null) onDismissed();
    });
  }

  static showDraggable(BuildContext parentContext, Widget child,
      {double? height, Function? onDismissed}) {
    _show(
        parentContext,
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: const Radius.circular(
                8,
              ),
              topLeft: const Radius.circular(
                8,
              )),
          child: Container(
              width: MediaQuery.of(parentContext).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 4,
                    width: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Flexible(child: child),
                ],
              )),
        ),
        height: height,
        onDismissed: onDismissed);
  }

  static showView(BuildContext parentContext, Widget child,
      {double? height, Function? onDismissed}) {
    _show(
        parentContext,
        ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: const Radius.circular(
                8,
              ),
              topLeft: const Radius.circular(
                8,
              )),
          child: Container(
              width: MediaQuery.of(parentContext).size.width,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Flexible(child: child)],
              )),
        ),
        height: height,
        onDismissed: onDismissed);
  }
}
