// ignore_for_file: must_be_immutable

import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  String? label;
  bool? astrick;
  Color? textColor;
  LabelText({
    super.key,
    this.label,
    this.astrick,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: RichText(
          softWrap: true,
          text: TextSpan(
              text: '',
              style: AppStyles.inputLabel(context,textColor == null ? AppColors.onBackground : textColor!,12),
              children: [
                TextSpan(
                    text: label,
                    style: AppStyles.inputLabel(context, textColor == null ? AppColors.onBackground : textColor!,12),),
                if (astrick == true)
                   TextSpan(
                      text: ' *',
                      style:AppStyles.captionText(context, AppColors.error,14)),
              ])),
    );
  }
}
