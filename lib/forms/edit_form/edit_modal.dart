import 'dart:convert';

class FormDataModel {
  final String school;
  final String tourId;
  final String formLabel;
  final Map<String, dynamic> data;

  FormDataModel(
      {required this.school,
      required this.tourId,
      required this.formLabel,
      required this.data});

  Map<String, dynamic> toMap() {
    return {
      'school': school,
      'tourId': tourId,
      'formLabel': formLabel,
      'data': jsonEncode(data), // Convert to JSON string
    };
  }

  factory FormDataModel.fromMap(Map<String, dynamic> map) {
    return FormDataModel(
      school: map['school'],
      tourId: map['tourId'],
      formLabel: map['formLabel'],
      data: jsonDecode(map['data']), // Convert back to Map
    );
  }
}
