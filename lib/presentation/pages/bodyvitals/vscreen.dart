import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/colors.dart';

class VitalBox extends StatelessWidget {
  VitalBox(
      {Key key,
      this.leading,
      this.action,
      this.title,
      this.subtitle,
      this.unit,
      this.suffix})
      : super(key: key);

  String leading;
  String title;
  String subtitle;
  String unit;
  Widget suffix;
  VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: action,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.all(10),
      leading: ImageIcon(
        AssetImage(leading),
        size: 30,
        color: AppColors.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Pop',
          color: AppColors.primaryColor.withOpacity(0.3),
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
      ),
      subtitle: Text(
        subtitle + unit,
        style: TextStyle(
          fontFamily: 'Pop',
          color: AppColors.primaryColor.withOpacity(0.7),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      trailing: suffix,
    ).py12();
  }
}
