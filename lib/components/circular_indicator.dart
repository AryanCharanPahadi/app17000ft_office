import 'package:flutter/material.dart';

class TextWithCircularProgress extends StatelessWidget {
  final String text;
  final Color indicatorColor;
  final double fontsize;
  final double strokeSize;

  const TextWithCircularProgress({
    Key? key,
    required this.text,
    required this.indicatorColor,
    required this.fontsize,
    required this.strokeSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: indicatorColor,
              strokeWidth: strokeSize,
            )), // Circular progress indicator
        //const SizedBox(height: 6), // Spacing between CircularProgressIndicator and Text
        Text(
          text,
          style: TextStyle(fontSize: fontsize, color: indicatorColor),
        ),
      ],
    );
  }
}