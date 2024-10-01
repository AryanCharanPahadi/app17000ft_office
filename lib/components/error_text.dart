
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final bool isVisible;
  final String message;

  const ErrorText({
    super.key,
    required this.isVisible,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                message,
                style: const TextStyle(color: AppColors.error,fontSize: 12),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}