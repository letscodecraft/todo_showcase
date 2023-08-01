import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String? value)? validator;
  final  Function(String? value)? onSaved;
  final double? cursorHeight;
  final int? maxLines;

  const PrimaryTextField({
    Key? key,
    required this.hintText,
    this.validator,
    this.onSaved,
    this.cursorHeight,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: cursorHeight,
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onFieldSubmitted: (value) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (value) {},
    );
  }
}
