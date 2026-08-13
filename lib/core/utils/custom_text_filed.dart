import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? label;
  final IconData prefixIcon;
  final Color iconColor;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;

  final String? hinText;
  final IconData? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    required this.focusNode,
    required this.prefixIcon,
    this.iconColor = Colors.grey,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.hinText,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      obscuringCharacter: "*",
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscure : false,
      decoration: InputDecoration(
        hintText: widget.hinText ?? "",
        prefixIcon: Icon(widget.prefixIcon),
        iconColor: widget.iconColor,
        label: Text(widget.label ?? "", style: TextStyle(color: Colors.grey)),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: widget.iconColor,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : Icon(widget.suffixIcon),
      ),
    );
  }
}