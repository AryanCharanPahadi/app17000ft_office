// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  String? side;
  double? value;
  CustomSizedBox({
    super.key,
    this.side,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return side == 'height'
        ? SizedBox(
            height: value,
          )
        : SizedBox(width: value);
  }
}
