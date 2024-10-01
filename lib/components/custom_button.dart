// ignore_for_file: must_be_immutable

//Custom ButtonClass
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
class CustomButton extends StatefulWidget {
  double? height;
  double? width;
  Function onPressedButton;
  String? title;

  CustomButton(
      {super.key,
      this.height,
      this.width,
      this.title,
      required this.onPressedButton});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return SizedBox(
        height:
            responsive.responsiveValue(small: 50.0, medium: 60.0, large: 70.0),
        width: responsive.responsiveValue(
            small: 150.0, medium: 200.0, large: 250.0),
        child: Center(
          child: ElevatedButton(
            style: AppStyles.primaryButtonStyle(context, AppColors.primary),
            onPressed: () => widget.onPressedButton(),
            child: Text(
              widget.title!,
              style: AppStyles.buttonText(context, AppColors.onPrimary),
            ),
          ),
          // style:ElevatedButton.styleFrom(backgroundColor: AppColors.mainBackground,elevation: 3,), child: Text(title!),
        ));
  }
}

class CustomSmallButton extends StatefulWidget {
  double? height;
  double? width;
  Function onPressedButton;
  String? title;

  CustomSmallButton(
      {super.key,
      this.height,
      this.width,
      this.title,
      required this.onPressedButton});

  @override
  State<CustomSmallButton> createState() => _CustomSmallButtonState();
}

class _CustomSmallButtonState extends State<CustomSmallButton> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return SizedBox(
        height:
            responsive.responsiveValue(small: 55.0, medium: 50.0, large: 65.0),
        width: responsive.responsiveValue(
            small: 100.0, medium: 150.0, large: 200.0),
        child: Center(
          child: ElevatedButton(
            style: AppStyles.smallButtonStyle(context, AppColors.primary),
            onPressed: () => widget.onPressedButton(),
            child: Text(
              widget.title!,
              style: AppStyles.smallButtonText(context, AppColors.onPrimary),
            ),
          ),
          // style:ElevatedButton.styleFrom(backgroundColor: AppColors.mainBackground,elevation: 3,), child: Text(title!),
        ));
  }
}
