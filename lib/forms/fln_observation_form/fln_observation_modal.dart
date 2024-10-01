// To parse this JSON data, do
//
//     final enrolmentCollectionModel = enrolmentCollectionModelFromJson(jsonString);

import 'dart:convert';

FlnObservationModel flnObservationModelFromJson(String str) => FlnObservationModel.fromJson(json.decode(str));

String flnObservationModelToJson(FlnObservationModel data) => json.encode(data.toJson());

class FlnObservationModel{
  int? id;
  String? tourId;
  String? school;
  String? udiseValue;
  String? correctUdise;
  String? noStaffTrained;
  String? imgNurTimeTable;
  String? imgLKGTimeTable;
  String? imgUKGTimeTable;
  String? lessonPlanValue;
  String? activityValue;
  String? imgActivity;
  String? imgTLM;
  String? baselineValue;
  String? baselineGradeReport;
  String? flnConductValue;
  String? flnGradeReport;
  String? imgFLN;
  String? refresherValue;
  String? numTrainedTeacher;
  String? imgTraining;
  String? readingValue;
  String? libGradeReport;
  String? imgLib;
  String? methodologyValue;
  String? imgClass;
  String? observation;
  String? created_by;
  String? createdAt;
  String? submittedAt;


  FlnObservationModel({
    this.id,
    required this.tourId,
    required this.school,
    required this.udiseValue,
    required this.correctUdise,
    required this.noStaffTrained,
    required this.imgNurTimeTable,
    required this.imgLKGTimeTable,
    required this.imgUKGTimeTable,
    required this.lessonPlanValue,
    required this.activityValue,
    required this.imgActivity,
    required this.imgTLM,
    required this.baselineValue,
    required this.baselineGradeReport,
    required this.flnConductValue,
    required this.flnGradeReport,
    required this.imgFLN,
    required this.refresherValue,
    required this.numTrainedTeacher,
    required this.imgTraining,
    required this.readingValue,
    required this.libGradeReport,
    required this.imgLib,
    required this.methodologyValue,
    required this.imgClass,
    required this.observation,
    required this.created_by,
    required this.createdAt,
    required this.submittedAt,

  });

  factory FlnObservationModel.fromJson(Map<String, dynamic> json) => FlnObservationModel(
    id: json["id"],
    tourId: json["tourId"],
    school: json["school"],
    udiseValue: json["udiseValue"],
    correctUdise: json["correctUdise"],
    noStaffTrained: json["noStaffTrained"],
    imgNurTimeTable: json["imgNurTimeTable"],
    imgLKGTimeTable: json["imgLKGTimeTable"],
    imgUKGTimeTable: json["imgUKGTimeTable"],
    lessonPlanValue: json["lessonPlanValue"],
    activityValue: json["activityValue"],
    imgActivity: json["imgActivity"],
    imgTLM: json["imgTLM"],
    baselineValue: json["baselineValue"],
    baselineGradeReport: json["baselineGradeReport"],
    flnConductValue: json["flnConductValue"],
    flnGradeReport: json["flnGradeReport"],
    imgFLN: json["imgFLN"],
    refresherValue: json["refresherValue"],
    numTrainedTeacher: json["numTrainedTeacher"],
    imgTraining: json["imgTraining"],
    readingValue: json["readingValue"],
    libGradeReport: json["libGradeReport"],
    imgLib: json["imgLib"],
    methodologyValue: json["methodologyValue"],
    imgClass: json["imgClass"],
    observation: json["observation"],
    created_by: json["created_by"],
    createdAt: json["createdAt"],
    submittedAt: json["submittedAt"],

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
    "lessonPlanValue": lessonPlanValue,
    "activityValue": activityValue,
    "imgActivity": imgActivity,
    "imgTLM": imgTLM,
    "baselineValue": baselineValue,
    "baselineGradeReport": baselineGradeReport,
    "flnConductValue": flnConductValue,
    "flnGradeReport": flnGradeReport,
    "imgFLN": imgFLN,
    "refresherValue": refresherValue,
    "numTrainedTeacher": numTrainedTeacher,
    "imgTraining": imgTraining,
    "readingValue": readingValue,
    "libGradeReport": libGradeReport,
    "imglib": imgLib,
    "methodologyValue": methodologyValue,
    "imgClass": imgClass,
    "observation": observation,
    "created_by": created_by,
    "createdAt": createdAt,
    "submittedAt": submittedAt,

  };
}
