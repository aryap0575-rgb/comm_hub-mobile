import 'package:flutter/material.dart';

class CommonCard extends StatefulWidget {
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double radius;
  final Widget? child;

  const CommonCard(
      {Key? key,
      this.color,
      this.shadowColor,
      this.surfaceTintColor = Colors.white,
      this.radius = 16,
      this.child})
      : super(key: key);
  @override
  State<CommonCard> createState() => _CommonCardState();
}

class _CommonCardState extends State<CommonCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: widget.shadowColor,
      surfaceTintColor: widget.surfaceTintColor,
      elevation: 4,
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: widget.child,
    );
  }
}
