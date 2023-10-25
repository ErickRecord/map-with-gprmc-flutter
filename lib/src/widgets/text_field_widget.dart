import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextInputAction textInputAction;
  final String fieldName;
  final TextEditingController controller;
  const TextFieldWidget(
      {super.key,
      required this.controller,
      required this.fieldName,
      required this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        validator: (value) => validator(value!, fieldName),
        controller: controller,
        cursorColor: Colors.green,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          contentPadding: EdgeInsets.zero,
          prefixIcon: const Padding(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.location_on_outlined, color: Colors.green,),
          ),
          
          errorStyle: const TextStyle(fontWeight: FontWeight.bold),
          hintText: fieldName,
        ),
      ),
    );
  }

  String? validator(String value, String fieldName) {
    if (value.isEmpty) {
      return "La $fieldName no va vacia";
    }
    if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) {
      return "Solo se aceptan numeros";
    }
    return null;
  }
}
