import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/widgets.dart';

class CurvedContainer extends StatelessWidget {
  const CurvedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    //Get the screen size;
    final Size screenSize = MediaQuery.of(context).size;

    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: screenSize.height * 0.3,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              tileMode: TileMode.mirror,
              colors: [
               
                AppColors.onTertiary,
                 AppColors.primary,
              ]),
        ),

        //color: const Color.fromARGB(255, 7, 54, 79),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.8); // Start from the bottom-left
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2,
        size.height); // Curve control point
    path.quadraticBezierTo(3 * size.width / 4, size.height, size.width,
        size.height * 0.8); // Curve control point
    path.lineTo(size.width, 0); // Line to top-right
    path.lineTo(0, 0); // Line to top-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
