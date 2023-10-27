import 'package:flutter/material.dart';
import 'package:map/src/provider/home_provider.dart';
import 'package:map/src/tools/input_decorations.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const TextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
          validator: (value) => validator(value!, context),
          controller: controller,
          cursorColor: Colors.green,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          decoration: InputDecorations.defaultInput(r"$GPRMC")),
    );
  }

  String? validator(String value, BuildContext context) {
    if (value.isEmpty) {
      return "El GPRMC no va vacio";
    }
    if (context.read<HomeProvider>().ubication(value) == null) {
      return "El valor ingresado no es GPRMC";
    }
    // if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) {
    //   return "Solo se aceptan numeros";
    // }
    return null;
  }
}
