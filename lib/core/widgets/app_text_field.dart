import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final int? maxLength;
  final double? height;
  final String? hint;
  final String? hintText;
  final Widget? suffixIcon;
  final Color? textColor;
  final List<TextInputFormatter>? inputFormatters;
  final TapRegionCallback? onTapOutside;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.fillColor,
    this.onTapOutside,
    this.floatingLabelBehavior,
    this.maxLength,
    this.inputFormatters,
    this.height,
    this.hint,
    this.hintText,
    this.suffixIcon,
    this.textColor,
    this.enabledBorder,
    this.focusedBorder,
    this.validator,
    this.onFieldSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        autofocus: autofocus,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? Colors.black,
        ),
        onTapOutside:
            onTapOutside ?? (event) => FocusScope.of(context).unfocus(),
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          fillColor: fillColor,
          filled: fillColor != null ? true : false,
          counterText: '',
          hintText: hintText,
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          label: Text(
            hint ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }

  InputBorder border(BuildContext context) {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.blueAccent,
        width: 1,
      ),
      gapPadding: 8,
      borderRadius: BorderRadius.circular(height == null ? 10 : 15),
    );
  }
}
