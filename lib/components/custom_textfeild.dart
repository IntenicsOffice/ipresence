import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obsecureText;
  final Icon prefixIcon;

  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.obsecureText,
      required this.prefixIcon,
      required this.controller,
      requiredm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: hintText,
            prefixIcon: prefixIcon,
            // prefixIconColor: Colors.grey[900],
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade500,
              ),
            ),
            fillColor: Colors.grey.shade300,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[700], fontSize: 14)
            // border: const OutlineInputBorder(),
            ),
      ),
    );
  }
}
