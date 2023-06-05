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
        style: Theme.of(context).textTheme.labelSmall,
        keyboardType: inputType,
        readOnly: readonly!,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            label: Text(label!),
            labelStyle: Theme.of(context).textTheme.titleSmall,
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
            suffix: suffix,
            prefixIcon: prefixicon,
            prefixIconColor: kprimary,
            filled: true),
      ).px20().py12(),
    );
  }
}
