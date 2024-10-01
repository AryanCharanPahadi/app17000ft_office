// To parse this JSON data, do
//
//     final enrolmentCollectionModel = enrolmentCollectionModelFromJson(jsonString);

import 'dart:convert';

AlfaObservationModel alfaObservationModelFromJson(String str) => AlfaObservationModel.fromJson(json.decode(str));

String alfaObservationModellToJson(AlfaObservationModel data) => json.encode(data.toJson());

class AlfaObservationModel{
  int? id;
  String? tourId;
  String? school;
  String? udiseValue;
  String? correctUdise;
  String? noStaffTrained;
  String? imgNurTimeTable;
  String? imgLKGTimeTable;
  String? imgUKGTimeTable;
  String? bookletValue;
  String? moduleValue;
  String? numeracyBooklet;
  String? numeracyValue;
  String? pairValue;
  String? alfaActivityValue;
  String? alfaGradeReport;
  String? imgAlfa;
  String? refresherTrainingValue;
  String? noTrainedTeacher;
  String? imgTraining;
  String? readingValue;
  String? libGradeReport;
  String? imgLibrary;
  String? tlmKitValue;
  String? imgTlm;
  String? classObservation;
  String? createdAt;
  String? submittedAt;
  String? createdBy;


  AlfaObservationModel({
    this.id,
    required this.tourId,
    required this.school,
    required this.udiseValue,
    required this.correctUdise,
    required this.noStaffTrained,
    required this.imgNurTimeTable,
    required this.imgLKGTimeTable,
    required this.imgUKGTimeTable,
    required this.bookletValue,
    required this.moduleValue,
    required this.numeracyBooklet,
    required this.numeracyValue,
    required this.pairValue,
    required this.alfaActivityValue,
    required this.alfaGradeReport,
    required this.imgAlfa,
    required this.refresherTrainingValue,
    required this.noTrainedTeacher,
    required this.imgTraining,
    required this.readingValue,
    required this.libGradeReport,
    required this.imgLibrary,
    required this.tlmKitValue,
    required this.imgTlm,
    required this.classObservation,
    required this.createdAt,
    required this.submittedAt,
    required this.createdBy,

  });

  factory AlfaObservationModel.fromJson(Map<String, dynamic> json) => AlfaObservationModel(
    id: json["id"],
    tourId: json["tourId"],
    school: json["school"],
    udiseValue: json["udiseValue"],
    correctUdise: json["correctUdise"],
    noStaffTrained: json["noStaffTrained"],
    imgNurTimeTable: json["imgNurTimeTable"],
    imgLKGTimeTable: json["imgLKGTimeTable"],
    imgUKGTimeTable: json["imgUKGTimeTable"],
    bookletValue: json["bookletValue"],
    moduleValue: json["moduleValue"],
    numeracyBooklet: json["numeracyBooklet"],
    numeracyValue: json["numeracyValue"],
    pairValue: json["pairValue"],
    alfaActivityValue: json["alfaActivityValue"],
    alfaGradeReport: json["alfaGradeReport"],
    imgAlfa: json["imgAlfa"],
    refresherTrainingValue: json["refresherTrainingValue"],
    noTrainedTeacher: json["noTrainedTeacher"],
    imgTraining: json["imgTraining"],
    readingValue: json["readingValue"],
    libGradeReport: json["libGradeReport"],
    imgLibrary: json["imgLibrary"],
    tlmKitValue: json["tlmKitValue"],
    imgTlm: json["imgTlm"],
    classObservation: json["classObservation"],
    createdAt: json["createdAt"],
    submittedAt: json["submittedAt"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tourId": tourId,
    "school": school,
    "udiseValue": udiseValue,
    "correctUdise": correctUdise,
    "noStaffTrained": noStaffTrained,
    "imgNurTimeTable": imgNurTimeTable,
    "imgLKGTimeTable": imgLKGTimeTable,
    "imgUKGTimeTable": imgUKGTimeTable,
    "bookletValue": bookletValue,
    "moduleValue": moduleValue,
    "numeracyBooklet": numeracyBooklet,
    "numeracyValue": numeracyValue,
    "pairValue": pairValue,
    "alfaActivityValue": alfaActivityValue,
    "alfaGradeReport": alfaGradeReport,
    "imgAlfa": imgAlfa,
    "refresherTrainingValue": refresherTrainingValue,
    "noTrainedTeacher": noTrainedTeacher,
    "imgTraining": imgTraining,
    "readingValue": readingValue,
    "libGradeReport": libGradeReport,
    "imgLibrary": imgLibrary,
    "tlmKitValue": tlmKitValue,
    "imgTlm": imgTlm,
    "classObservation": classObservation,
    "createdAt": createdAt,
    "submittedAt": submittedAt,
    "createdBy": createdBy,
  };
}
