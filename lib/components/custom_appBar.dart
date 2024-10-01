

import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: AppStyles.appBarTitle(context, AppColors.onPrimary)),
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(
        color: AppColors.onPrimary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
