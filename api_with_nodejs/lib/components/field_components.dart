import 'package:flutter/material.dart';

class FieldComponents extends StatelessWidget {
  final String? hintText;
  final IconData? iconData;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  const FieldComponents({
    super.key,
    this.hintText,
    this.iconData,
    this.validator,
    this.onSaved,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.white),
          fillColor: Colors.grey.withOpacity(0.4),
          filled: true,
          contentPadding: const EdgeInsets.all(10.0),
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
