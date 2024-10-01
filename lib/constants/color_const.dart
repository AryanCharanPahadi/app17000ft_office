import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
// Main color of the application
static const primary = Color.fromARGB(255, 141, 13, 21);
static const surfaceTint = Color(0xffa13d3a);
static const onPrimary = Color(0xffffffff);
static const primaryContainer = Color(0xff862928);
static const onPrimaryContainer = Color(0xffffdedb);
//Secondary color of the application
static const secondary = Color(0xff85504d);
static const onSecondary = Color(0xffffffff);
static const secondaryContainer = Color(0xffffc4bf);
static const onSecondaryContainer = Color(0xff5f312e);

//teritory color of the application
static const tertiary = Color(0xff745b00);
static const onTertiary = Color(0xffffffff);
static const tertiaryContainer = Color(0xffffdc77);
static const onTertiaryContainer = Color(0xff564400);
//Error colors
static const error = Color(0xffba1a1a);
static const onError = Color(0xffffffff);
static const errorContainer = Color(0xffffdad6);
static const onErrorContainer = Color(0xff410002);
//Background color of the application
static const background = Color(0xfffff8f7);
static const onBackground = Color(0xff231918);
//Surface color of the application
static const surface = Color(0xfffff8f7);
static const onSurface = Color(0xff231918);
static const surfaceVariant = Color(0xfffadcd9);
static const onSurfaceVariant = Color(0xff564240);

//outline color of the application
static const outline = Color(0xff89716f);
static const outlineVariant = Color(0xffddc0bd);

//shadow color of the application
static const shadow = Color(0xff000000);

 // Scrim color (used for modal barriers, dialogs)
static const scrim = Color(0xff000000);

 // Inverse colors
static const inverseSurface = Color(0xff392e2d);
static const inverseOnSurface = Color(0xffffedeb);
static const inversePrimary = Color(0xffffb3ae);

 // Fixed primary colors
static const primaryFixed = Color(0xffffdad7);
static const onPrimaryFixed = Color(0xff410004);
static const primaryFixedDim = Color(0xffffb3ae);
static const onPrimaryFixedVariant = Color(0xff822625);

// Fixed secondary colors
static const secondaryFixed = Color(0xffffdad7);
static const onSecondaryFixed = Color(0xff350f0e);
static const secondaryFixedDim = Color(0xfffab6b1);
static const onSecondaryFixedVariant = Color(0xff693936);

// Fixed Teritory colors
static const tertiaryFixed = Color(0xffffe089);
static const onTertiaryFixed = Color(0xff241a00);
static const tertiaryFixedDim = Color(0xffeac247);
static const onTertiaryFixedVariant = Color(0xff574400);

// Surface dim and bright colors
static const surfaceDim = Color(0xffe9d6d4);
static const surfaceBright = Color(0xfffff8f7);

  // Surface container colors
static const surfaceContainerLowest = Color(0xffffffff);
static const surfaceContainerLow = Color(0xfffff0ef);
static const surfaceContainer = Color(0xfffee9e7);
static const surfaceContainerHigh = Color(0xfff8e4e2);
static const surfaceContainerHighest = Color(0xfff2dedc);


// Highest-level container background color.
  static const String apiUrl = 'https://disha.vedvika.com/api/';

  // static TextStyle largeHeading = const TextStyle(
  //     color: AppColors.onPrimary,
  //     fontSize: 30,
  //     fontWeight: FontWeight.bold,
  //     letterSpacing: 2,
  //     height: 0);
}

class AppStyles {
  static double responsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth > 600 ? 1.5 : 1.0; // Adjust as needed
    return baseSize * scaleFactor;
  }

  static double responsivePadding(BuildContext context, double basePadding) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth > 600 ? 1.5 : 1.0; // Adjust as needed
    return basePadding * scaleFactor;
  }

  static TextStyle heading1(BuildContext context,Color textColor) {
    return GoogleFonts.openSans(
    textStyle: TextStyle(
      fontSize: responsiveFontSize(context, 24),
      fontWeight: FontWeight.bold,
      color: textColor ?? Colors.black,
    ),
  );
  }

  static TextStyle heading2(BuildContext context,Color textColor) {
    return GoogleFonts.openSans(
  textStyle:   TextStyle(
      fontSize: responsiveFontSize(context, 20),
      fontWeight: FontWeight.bold,
      color: textColor
    ));
  }

  static TextStyle heading3(BuildContext context,Color textColor,double? size) {
    return GoogleFonts.openSans(
   textStyle: TextStyle(
           fontSize: size == null ? responsiveFontSize(context, 18) :responsiveFontSize(context, size),

      fontWeight: FontWeight.bold,
      color: textColor,
    ));
  }

  // Body Text Styles
  static TextStyle bodyText(BuildContext context,Color textColor) {
    return GoogleFonts.openSans(
   textStyle: TextStyle(
      fontSize: responsiveFontSize(context, 16),
      color: Colors.black87,
    ));
  }

  static TextStyle captionText(BuildContext context,Color textColor,double? size) {
      return GoogleFonts.openSans(
textStyle:    TextStyle(
          fontSize: size == null ? responsiveFontSize(context, 14) :responsiveFontSize(context, size),

      color: textColor,
      fontWeight: FontWeight.bold,
    ));
  }

  static TextStyle smallButtonText(BuildContext context,Color textColor) {
      return GoogleFonts.openSans(
textStyle:    TextStyle(
      fontSize: responsiveFontSize(context, 10),
      color: textColor,
      fontWeight: FontWeight.bold,
    ));
  }

  

  // Button Styles
  static TextStyle buttonText(BuildContext context,Color textColor) {
       return GoogleFonts.openSans(
   textStyle:TextStyle(
      fontSize: responsiveFontSize(context, 16),
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ));
  }

  static ButtonStyle primaryButtonStyle(BuildContext context,Color textColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: textColor,
      padding: EdgeInsets.symmetric(
        horizontal: responsivePadding(context, 40),
        vertical: responsivePadding(context, 7),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsivePadding(context, 9)),
      ),
    );
  }

  static ButtonStyle secondaryButtonStyle(BuildContext context,Color textColor) {
    return ElevatedButton.styleFrom(
      backgroundColor:textColor,
      padding: EdgeInsets.symmetric(
        horizontal: responsivePadding(context, 20),
        vertical: responsivePadding(context, 12),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsivePadding(context, 2)),
      ),
    );
  }

   static ButtonStyle smallButtonStyle(BuildContext context,Color textColor) {
    return ElevatedButton.styleFrom(
      backgroundColor:textColor,
      padding: EdgeInsets.symmetric(
        horizontal: responsivePadding(context, 10),
        vertical: responsivePadding(context, 2),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsivePadding(context, 2)),
      ),
    );
  }

  // Form Input Styles
  static TextStyle inputLabel(BuildContext context,Color textColor,double? size) {
    return GoogleFonts.openSans(
   textStyle: TextStyle(
      fontSize: size == null ? responsiveFontSize(context, 18) :responsiveFontSize(context, size),
      color: textColor ?? AppColors.onBackground,
      fontWeight: FontWeight.bold,
    ));
  }

  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsivePadding(context, 16),
        vertical: responsivePadding(context, 12),
      ),
    );
  }

  // Card Styles
  static BoxDecoration cardDecoration(BuildContext context,) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(responsivePadding(context, 8)),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: const Offset(0, 2),
          blurRadius: responsivePadding(context, 4),
        ),
      ],
    );
  }

  // App Bar Styles
  static TextStyle appBarTitle(BuildContext context,Color textColor) {
    return TextStyle(
      fontSize: responsiveFontSize(context, 20),
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  //static Color get appBarBackgroundColor => Colors.blue;

  // Navigation Styles
  static TextStyle navBarItem(BuildContext context,Color textColor) {
    return TextStyle(
      fontSize: responsiveFontSize(context, 16),
      color: Colors.black,
    );
  }
}
