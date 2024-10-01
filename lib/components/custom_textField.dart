import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? textController;
  final IconData? prefixIcon;
  final String? hintText;
  final String? labelText;
  final IconButton? suffixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? textInputType;
  final int? maxlines;
  final TextAlign textAlign;
  final bool showCharacterCount;
  final TextCapitalization textCapitalization; // Add this


  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final FocusNode? focusNode;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    super.key,
    this.textController,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.obscureText,
    this.textInputType,
    this.maxlines,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onSaved,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.onChanged,
    this.showCharacterCount = false,
    this.textCapitalization = TextCapitalization.none, // Default value
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  int _characterCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTap: widget.onTap ?? () => {},
          controller: widget.textController!,
          obscureText: widget.obscureText ?? false,
          readOnly: widget.readOnly ?? false,
          focusNode: widget.focusNode,
          keyboardType: widget.textInputType,

          maxLines: widget.maxlines ?? 1,
          textAlign: widget.textAlign,
          onChanged: (value) {
            setState(() {
              _characterCount = value.length;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          validator: widget.validator,
          onSaved: widget.onSaved ?? (value) {},
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization, // Pass it to TextFormField
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null,
            suffixIcon: widget.suffixIcon,
            prefixIconColor: AppColors.outline,
            suffixIconColor: AppColors.outline,
            label: widget.labelText != null
                ? Text(
              widget.labelText!,
              style:
              AppStyles.captionText(context, AppColors.outline, 12),
            )
                : null,
            hintText: widget.hintText ?? '',
            floatingLabelStyle: const TextStyle(color: AppColors.primary),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: AppColors.onBackground,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: AppColors.outline),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1, color: AppColors.error),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2, color: AppColors.error),
            ),
          ),
        ),
        if (widget.showCharacterCount)
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$_characterCount characters',
                  style: TextStyle(color: AppColors.outline, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}