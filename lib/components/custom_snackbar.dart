
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

 customSnackbar(String? title, String? subtitle, Color? bgColor,
    Color? textColor, IconData? logoIcon) {
  Get.snackbar(
    title!,
    subtitle!,
    
    snackPosition: SnackPosition.TOP,
    colorText: textColor,
    backgroundColor: bgColor,
    icon: Icon(logoIcon, color:AppColors.onPrimary),
  );
}