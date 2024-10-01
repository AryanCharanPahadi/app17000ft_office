import 'package:app17000ft_new/components/custom_dropdown.dart';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:app17000ft_new/components/custom_sizedBox.dart';
import 'package:flutter/material.dart';
class CustomFieldWithDropDown extends StatefulWidget {
  String? labelText;
  String? sizedBox;
  String? selectedString;
  double? sizedBoxValue;
  List<String>? optionsList;
  String? hintTextDropDown;
  bool? requiredFields;
  final ValueChanged<String?>? onChanged;

  CustomFieldWithDropDown({
    super.key,
    this.labelText,
    this.sizedBox,
    this.selectedString,
    this.sizedBoxValue,
    this.optionsList,
    this.requiredFields,
    this.hintTextDropDown,
    this.onChanged,
  });

  @override
  State<CustomFieldWithDropDown> createState() =>
      _CustomFieldWithDropDownState();
}

class _CustomFieldWithDropDownState extends State<CustomFieldWithDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelText(
          label: widget.labelText ?? '',
          astrick: widget.requiredFields,
        ),
        CustomSizedBox(
          side: widget.sizedBox ?? '',
          value: widget.sizedBoxValue ?? 15,
        ),
        CustomDropdownFormField(
            options: widget.optionsList!,
            selectedOption: widget.selectedString,
            onChanged: widget.onChanged,
            labelText: widget.hintTextDropDown ?? ''),
      ],
    );
  }
}
