import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  // Get screen width
  double screenWidth() {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  // Determine if the device is a small, medium, or large screen
  bool isSmallScreen() {
    return screenWidth() < 600;
  }

  bool isMediumScreen() {
    return screenWidth() >= 600 && screenWidth() < 1200;
  }

  bool isLargeScreen() {
    return screenWidth() >= 1200;
  }

  // Get responsive value based on screen size
  T responsiveValue<T>({required T small, required T medium, required T large}) {
    if (isSmallScreen()) {
      return small;
    } else if (isMediumScreen()) {
      return medium;
    } else {
      return large;
    }
  }

  // Get responsive text size
  double responsiveTextSize(double small, double medium, double large) {
    return responsiveValue(small: small, medium: medium, large: large);
  }

  // Get responsive padding
  EdgeInsets responsivePadding(double small, double medium, double large) {
    return EdgeInsets.all(responsiveValue(small: small, medium: medium, large: large));
  }

  // Get responsive margin
  EdgeInsets responsiveMargin(double small, double medium, double large) {
    return EdgeInsets.all(responsiveValue(small: small, medium: medium, large: large));
  }
}
