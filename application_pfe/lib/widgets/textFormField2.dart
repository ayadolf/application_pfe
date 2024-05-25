import 'package:flutter/material.dart';

Widget textFormField2(BuildContext context, String content, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: false,
    keyboardType: TextInputType.text,
    cursorHeight: 30,
    decoration: InputDecoration(
      // Assuming password visibility toggle
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF034277),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.all(10),
      labelText: content,
      labelStyle: const TextStyle(
        color: Color(0xFF034277),
        fontFamily: 'PoppinsRegular',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );
}
