import 'package:MedBox/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

// ignore: must_be_immutable
class FormfieldX extends StatelessWidget {
  FormfieldX(
      {super.key,
      this.suffix,
      this.prefixicon,
      this.validator,
      this.readonly,
      this.hinttext,
      this.label,
      this.inputType,
      this.controller});

  TextEditingController? controller;
  FormFieldValidator? validator;
  bool? readonly;
  Widget? suffix;
  Icon? prefixicon;
  String? hinttext;
  String? label;
  TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: inputType,
        readOnly: readonly!,
        decoration: InputDecoration(
            label: Text(label!),
            hintText: hinttext,
            labelStyle: Theme.of(context).textTheme.labelMedium,
            fillColor: Colors.white,
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 0, color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 0, color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 0, color: Colors.white)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 0, color: Colors.white)),
            contentPadding: const EdgeInsets.all(10),
            suffixIcon: suffix,
            prefixIcon: prefixicon,
            prefixIconColor: kprimary,
            errorStyle:
                const TextStyle(fontFamily: 'Pop', fontSize: 8, color: kred),
            filled: true),
      ).px20().py8(),
    );
  }
}
