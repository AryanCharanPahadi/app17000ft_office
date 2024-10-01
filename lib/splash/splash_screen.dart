import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.onTertiary, AppColors.primary],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoSection(),
            SizedBox(
                height: responsive.responsiveValue(
                    small: 20, medium: 30, large: 40)),
            LoadingIndicator(responsive: responsive),
            SizedBox(
                height: responsive.responsiveValue(
                    small: 180, medium: 190, large: 200)),
            VersionText(responsive: responsive),
          ],
        ),
      ),
    );
  }
}

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Column(
      children: [
        SizedBox(
            height: responsive.responsiveValue(
                small: 120, medium: 160, large: 200)),
        Hero(
          tag: 'logo', // Make sure the tag is unique and meaningful
          child: Image.asset(
            "assets/logo.png",
            height: responsive.responsiveValue(
                small: 200.0, medium: 250.0, large: 300.0),
            width: responsive.responsiveValue(
                small: 200.0, medium: 250.0, large: 300.0),
          ),
        ),
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final Responsive responsive;

  const LoadingIndicator({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: responsive.responsiveValue(small: 20, medium: 30, large: 40),
      width: responsive.responsiveValue(small: 20, medium: 30, large: 40),
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1,
      ),
    );
  }
}

class VersionText extends StatelessWidget {
  final Responsive responsive;

  const VersionText({super.key, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version 1.0',
      style: TextStyle(
        color:AppColors.background,
        fontSize: responsive.responsiveTextSize(12, 14, 16),
      ),
    );
  }
}
