import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class Confirmation extends StatefulWidget {
  final String? desc;
  final String? title;
  final bool? settle;
  final Callback? onPressed;
  final String? yes;
  final String? no;
  final IconData? iconname;

  const Confirmation({
    super.key,
    required this.desc,
    required this.title,
    this.settle,
    required this.onPressed,
    required this.yes,
    this.no,
    required this.iconname,
  });

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 160, // Fixed width for consistency
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: AppColors.primary,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10), // Use SizedBox for spacing
                    Icon(
                      widget.iconname,
                      color: Colors.white,
                      size: 40, // Fixed icon size
                    ),
                    SizedBox(height: 10), // Use SizedBox for spacing
                    Text(
                      widget.title.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 10), // Use SizedBox for spacing
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10), // Use SizedBox for spacing
                    Text(
                      widget.desc ?? "",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: widget.no != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      child: Text(
                        widget.yes!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        widget.onPressed!();
                        Navigator.of(context).pop();
                      },
                    ),
                    if (widget.no != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          widget.no!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
