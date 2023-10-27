import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration defaultInput(String fieldName) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      contentPadding: EdgeInsets.zero,
      prefixIcon: const Padding(
        padding: EdgeInsets.all(5),
        child: Icon(
          Icons.location_on_outlined,
          color: Colors.green,
        ),
      ),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold),
      hintText: fieldName,
    );
  }
}
