import 'package:flutter/material.dart';

class TextsField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isPasswordFields;
  final bool readOnly;
  final String? labelText;
  final String obscuringCharacter;
  final TextInputAction? textInputAction;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final Widget? suffixIcon;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const TextsField({
    super.key,
    required this.controller,
    this.focusNode,
    this.isPasswordFields = false,
    this.readOnly = false,
    this.obscuringCharacter = '*',
    this.labelText,
    this.textInputAction,
    this.labelStyle,
    this.style,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
  });

  @override
  State<TextsField> createState() => _TextsFieldState();
}

class _TextsFieldState extends State<TextsField> {
  bool _obscureText = false;

  @override
  void initState() {
    if (widget.isPasswordFields) {
      _toggleObscureText(toggle: true);
    }

    super.initState();
  }

  void _toggleObscureText({bool? toggle}) {
    setState(() {
      _obscureText = toggle ?? !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: widget.isPasswordFields
            ? IconButton(
                onPressed: _toggleObscureText,
                focusNode: FocusNode(skipTraversal: true),
                color: Colors.white,
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.grey[400],
                ),
              )
            : widget.suffixIcon,
      ),
      textInputAction: widget.textInputAction ?? TextInputAction.done,
    );
  }
}
