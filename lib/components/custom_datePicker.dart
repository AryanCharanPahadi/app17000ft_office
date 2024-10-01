//custom date picker

// ignore_for_file: must_be_immutable

import 'package:app17000ft_new/components/custom_textField.dart';
import 'package:flutter/material.dart';

class MyDatePickerWidget extends StatefulWidget {
  TextEditingController? dateController;
  MyDatePickerWidget({super.key, this.dateController});

  @override
  _MyDatePickerWidgetState createState() => _MyDatePickerWidgetState();
}

class _MyDatePickerWidgetState extends State<MyDatePickerWidget> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize selectedDate to the current date
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date = DateTime.parse(selectedDate.toString());
        var formattedDate = "${date.year}-${date.month}-${date.day}";
        widget.dateController!.text = formattedDate.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomTextFormField(
          textController: widget.dateController!,
          textInputType: TextInputType.text,
          readOnly: true,
          onTap: () => _selectDate(context) ,
          prefixIcon: Icons.abc,
          suffixIcon: IconButton(
            onPressed: () => {_selectDate(context)},
            icon: const Icon(Icons.calendar_month),
          ),
          obscureText: false,
          labelText: 'Date of Payment ',
          hintText: 'Date of Payment',
        ),
      ],
    );
  }
}
