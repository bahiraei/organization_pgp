import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final int? maxLength;
  final String? hintText;
  final Widget? label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final bool showClearButton;
  final TextStyle? hintStyle;
  final bool? filled;
  final Color? fillColor;
  final GestureTapCallback? onTap;
  final bool? enabled;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffix;
  final int? maxLines;
  final InputBorder? border;

  const CustomTextFormField({
    super.key,
    this.validator,
    this.controller,
    this.label,
    this.hintText,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.focusNode,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.onFieldSubmitted,
    this.onChanged,
    this.contentPadding,
    this.showClearButton = false,
    this.hintStyle,
    this.filled,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.enabled = true,
    this.readOnly = false,
    this.suffix,
    this.border,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.obscureText,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          fontSize: 12,
        ),
        alignLabelWithHint: true,
        hintText: widget.hintText,
        label: widget.label,
        hintStyle: widget.hintStyle,
        fillColor: widget.fillColor,
        filled: widget.filled,
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(),
            ),
        contentPadding: widget.contentPadding,
        suffix: widget.suffix,
        suffixIcon: (widget.showClearButton)
            ? Visibility(
                visible: widget.showClearButton &&
                    (widget.controller?.text.isNotEmpty ?? false),
                child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.xmark_circle,
                  ),
                  color: Colors.white38,
                  onPressed: () {
                    widget.controller?.clear();
                    FocusScope.of(context).requestFocus(widget.focusNode);
                    setState(() {});
                  },
                ),
              )
            : widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
      ),
      textAlignVertical: TextAlignVertical.center,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      textInputAction: widget.textInputAction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters ?? [],
      onFieldSubmitted: widget.onFieldSubmitted,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      enabled: widget.enabled,
      readOnly: widget.readOnly ?? false,
      onChanged: (value) {
        setState(() {});

        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
