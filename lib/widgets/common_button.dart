import 'package:dpad/dpad.dart';
import 'package:fincome_mobile_mobile/widgets/tap_effect.dart';

import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? buttonText;
  final Widget? buttonTextWidget;
  final Color? textColor, backgroundColor;
  final bool? isClickable;
  final bool isHeighDynamic;
  final double heightRasio;
  final double radius;
  final double? fontSize;
  const CommonButton({
    Key? key,
    this.fontSize,
    this.onTap,
    this.buttonText,
    this.buttonTextWidget,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.padding,
    this.isClickable = true,
    this.isHeighDynamic = false,
    this.heightRasio = 10,
    this.radius = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(),
      child: DpadFocusable(
        onSelect: onTap ?? () {},
        builder: FocusEffects.glow(
          glowColor: const Color.fromARGB(255, 0, 109, 68),
        ),
        child: TapEffect(
          isClickable: isClickable!,
          onClick: onTap ?? () {},
          child: SizedBox(
            height: isHeighDynamic
                ? MediaQuery.of(context).size.height / heightRasio < 48
                    ? 48
                    : MediaQuery.of(context).size.height / heightRasio
                : 48,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              color: const Color.fromARGB(255, 0, 109, 68),
              shadowColor: Colors.black12.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.2,
              ),
              child: Center(
                child: buttonTextWidget ??
                    Text(
                      buttonText ?? "",
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
