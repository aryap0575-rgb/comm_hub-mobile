import 'package:dpad/dpad.dart';
import 'package:com.example.fincome_mobile_mobile/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CommonTextFieldView extends StatefulWidget {
  final FocusNode focusNode;
  final String? titleText;
  final TextStyle? titleStyle;
  final String hintText;
  final String? errorText;
  final bool isObscureText, isAllowTopTitleView;
  final EdgeInsetsGeometry padding;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const CommonTextFieldView({
    Key? key,
    required this.focusNode,
    this.hintText = '',
    this.titleStyle,
    this.isObscureText = false,
    this.padding = const EdgeInsets.only(),
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isAllowTopTitleView = true,
    this.errorText,
    this.titleText = '',
    this.controller,
  }) : super(key: key);

  @override
  State<CommonTextFieldView> createState() => _CommonTextFieldViewState();
}

class _CommonTextFieldViewState extends State<CommonTextFieldView> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isAllowTopTitleView && widget.titleText != '')
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
              child: Text(
                widget.titleText ?? "",
                style: widget.titleStyle ??
                    TextStyles(context).getDescriptionStyle(),
              ),
            ),
          Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.black12.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.2,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                height: 48,
                child: Center(
                  child: DpadFocusable(
                    onSelect: () {
                      widget.focusNode.requestFocus();
                    },
                    builder: FocusEffects.border(
                        focusColor: const Color.fromARGB(255, 0, 109, 68)),
                    child: TextField(
                      focusNode: widget.focusNode,
                      controller: widget.controller,
                      maxLines: 1,
                      onChanged: widget.onChanged,
                      style: TextStyles(context).getRegularStyle(),
                      obscureText: widget.isObscureText ? _visible : false,
                      cursorColor: Colors.black,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      decoration: InputDecoration(
                        errorText: null,
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 15),
                        suffixIcon: widget.isObscureText
                            ? IconButton(
                                icon: Icon(
                                  _visible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                },
                              )
                            : null,
                      ),
                      keyboardType: widget.keyboardType,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.errorText != null && widget.errorText != '')
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
              child: Text(
                widget.errorText ?? "",
                style: TextStyles(context).getDescriptionStyle().copyWith(
                      color: Colors.red,
                    ),
              ),
            )
        ],
      ),
    );
  }
}
