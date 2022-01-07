import 'package:flutter/material.dart'
;
class RippleCard extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final BorderSide side;
  final BorderRadius borderRadius;
  final double? elevation;
  final GestureTapCallback? onTap;

  RippleCard(
      {@required this.child,
        this.onTap,
        this.elevation = 1,
        this.color = Colors.transparent,
        this.side = BorderSide.none,
        this.borderRadius = const BorderRadius.all(Radius.circular(8))});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          side: side,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
            borderRadius: borderRadius,
            child: InkWell(
                borderRadius: borderRadius,
                child: Ink(
                    decoration:
                    BoxDecoration(color: color, borderRadius: borderRadius),
                    child: child),
                onTap: onTap)));
  }
}
