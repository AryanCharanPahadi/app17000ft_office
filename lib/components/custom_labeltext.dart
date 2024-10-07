import 'package:flutter/material.dart';
import 'package:app17000ft_new/constants/color_const.dart';

class LabelText extends StatelessWidget {
  final String? label;
  final bool? astrick;
  final Color? textColor;

  LabelText({
    super.key,
    this.label,
    this.astrick,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Getting screen width to determine the responsive font size
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize;

    // Set font size based on the screen width
    if (screenWidth < 600) {
      fontSize = 16; // Mobile
    } else if (screenWidth < 900) {
      fontSize = 14; // Tablet
    } else {
      fontSize = 16; // Larger screens
    }

    return Align(
      alignment: Alignment.topLeft,
      child: RichText(
        softWrap: true,
        text: TextSpan(
          text: '',
          style: AppStyles.inputLabel(
            context,
            textColor ?? AppColors.onBackground,
            fontSize,
          ),
          children: [
            TextSpan(
              text: label,
              style: AppStyles.inputLabel(
                context,
                textColor ?? AppColors.onBackground,
                fontSize,
              ),
            ),
            if (astrick == true)
              TextSpan(
                text: ' *',
                style: AppStyles.captionText(context, AppColors.error, 14),
              ),
          ],
        ),
      ),
    );
  }
}
