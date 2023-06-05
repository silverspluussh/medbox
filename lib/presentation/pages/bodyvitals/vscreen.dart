import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';

// ignore: must_be_immutable
class VitalBox extends StatelessWidget {
  VitalBox(
      {super.key,
      this.leading,
      this.action,
      this.title,
      this.subtitle,
      this.unit,
      this.suffix});

  String? leading;
  String? title;
  String? subtitle;
  String? unit;
  Widget? suffix;
  VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: action,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.all(10),
      leading: ImageIcon(
        AssetImage(leading!),
        size: 25,
        color: kprimary,
      ),
      title: Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle:
          Text('$subtitle $unit', style: Theme.of(context).textTheme.bodySmall),
      trailing: suffix,
    ).py12();
  }
}
