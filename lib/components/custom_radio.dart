import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';
class DynamicRadio extends FormField<String> {
  final List<String> options;
  final FocusNode focusNode;
  final int? gridcount;

  DynamicRadio({
    super.key,
    required String? selectedOption,
    this.gridcount,
    required this.options,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    required this.focusNode,
  }) : super(
          initialValue: selectedOption,
          onSaved: onChanged,
          validator: (value) {
            final result = validator?.call(value);
            if (result != null && result.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Scrollable.ensureVisible(
                  focusNode.context!,
                  alignment: 0.5, // Adjust alignment as needed
                  duration: const Duration(milliseconds: 500), // Scroll animation duration
                );
              });
            }
            return result;
          },
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Focus(
                  focusNode: focusNode,
                  child: GridView.count(
                    crossAxisCount: gridcount ?? 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: MediaQuery.of(field.context).size.width /
                        (MediaQuery.of(field.context).size.height / 16),
                    children: options.map((String option) {
                      return RadioListTile<String>(
                        title: Text(option, style: const TextStyle(fontSize: 13)),
                        value: option,
                        groupValue: field.value,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          field.didChange(value);
                          onChanged(value);
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (field.hasError)
                  Text(
                    field.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}

