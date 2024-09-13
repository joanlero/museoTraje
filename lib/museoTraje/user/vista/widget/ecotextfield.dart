import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EcoTextFieldWeb extends StatefulWidget {
  String? hintText;
  TextEditingController? controller;
  String? Function(String?)? validate;
  Widget? icon;
  bool isPassowrd;
  bool check;
  int? maxLines;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;

  EcoTextFieldWeb({
    this.hintText,
    this.controller,
    this.validate,
    this.maxLines,
    this.icon,
    this.check = false,
    this.inputAction,
    this.focusNode,
    this.isPassowrd = false,
  });

  @override
  State<EcoTextFieldWeb> createState() => _EcoTextFieldState();
}

class _EcoTextFieldState extends State<EcoTextFieldWeb> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Fondo gris suave para el campo de texto
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          maxLines: widget.maxLines == 1 ? 1 : widget.maxLines,
          focusNode: widget.focusNode,
          textInputAction: widget.inputAction,
          controller: widget.controller,
          obscureText: widget.isPassowrd == false ? false : widget.isPassowrd,
          validator: widget.validate,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText ?? 'hint Text...',
            suffixIcon: widget.icon,
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
