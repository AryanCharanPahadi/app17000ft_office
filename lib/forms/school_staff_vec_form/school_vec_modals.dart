import 'dart:convert';

List<SchoolStaffVecRecords?>? schoolStaffVecRecordsFromJson(String str) =>
    str.isEmpty ? [] : List<SchoolStaffVecRecords?>.from(json.decode(str).map((x) => SchoolStaffVecRecords.fromJson(x)));

String schoolStaffVecRecordsToJson(List<SchoolStaffVecRecords?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class SchoolStaffVecRecords {
  SchoolStaffVecRecords({
    this.id,
    this.tourId,
    this.school,
    this.udiseValue,
    this.correctUdise,
    this.headName,
    this.headGender,
    this.headMobile,
    this.headEmail,
    this.headDesignation,
    this.totalTeachingStaff,
    this.totalNonTeachingStaff,
    this.totalStaff,
    this.SmcVecName,
    this.genderVec,
    this.vecMobile,
    this.vecEmail,
    this.vecQualification,
    this.vecTotal,
    this.meetingDuration,
    this.createdBy,
    this.createdAt,
    this.other,
    this.otherQual,


  });


  int? id;
  String? tourId;
  String? school;
  String? udiseValue;  // Updated from udiseCode
  String? correctUdise;
  String? headName;    // Updated from nameOfHoi
  String? headGender;  // Updated from genderofHoi
  String? headMobile;  // Updated from mobileOfHoi
  String? headEmail;   // Updated from emailOfHoi
  String? headDesignation;  // Updated from desgnationOfHoi
  String? totalTeachingStaff;
  String? totalNonTeachingStaff;
  String? totalStaff;
  String? SmcVecName;  // Updated from nameOfSmc
  String? genderVec;   // Updated from genderOfSmc
  String? vecMobile;   // Updated from mobileOfSmc
  String? vecEmail;    // Updated from emailOfSmc
  String? vecQualification;  // Updated from qualificationOfSmc
  String? vecTotal;    // Updated from totalSmcStaff
  String? meetingDuration;  // Updated from SmcStaffMeeting
  String? createdBy;   // Updated from submittedBy
  String? createdAt;
  String? other;       // Added field
  String? otherQual;   // Added field




  // Factory method to create an instance from JSON
  factory SchoolStaffVecRecords.fromJson(Map<String, dynamic> json) => SchoolStaffVecRecords(

    id: json["id"],
    tourId: json["tourId"],  // Updated to match field name
    school: json["school"],
    udiseValue: json["udiseValue"],  // Updated to match field name
    correctUdise: json["correctUdise"],
    headName: json["headName"],  // Updated to match field name
    headGender: json["headGender"],  // Updated to match field name
    headMobile: json["headMobile"],  // Updated to match field name
    headEmail: json["headEmail"],  // Updated to match field name
    headDesignation: json["headDesignation"],  // Updated to match field name
    totalTeachingStaff: json["totalTeachingStaff"],
    totalNonTeachingStaff: json["totalTeachingStaff"],
    totalStaff: json["totalStaff"],
    SmcVecName: json["SmcVecName"],  // Updated to match field name
    genderVec: json["genderVec"],  // Updated to match field name
    vecMobile: json["vecMobile"],  // Updated to match field name
    vecEmail: json["vecEmail"],  // Updated to match field name
    vecQualification: json["vecQualification"],  // Updated to match field name
    vecTotal: json["vecTotal"],  // Updated to match field name
    meetingDuration: json["meetingDuration"],  // Updated to match field name
    createdBy: json["createdBy"],  // Updated to match field name
    createdAt: json["createdAt"],
    other: json["other"],  // Added field
    otherQual: json["otherQual"],  // Added field


  );

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => {

    "id": id,
    "tourId": tourId,
    "school": school,
    "udiseValue": udiseValue,
    "correctUdise": correctUdise,
    "headName": headName,
    "headGender": headGender,
    "headMobile": headMobile,
    "headEmail": headEmail,
    "headDesignation": headDesignation,
    "totalTeachingStaff": totalTeachingStaff,
    "totalNonTeachingStaff": totalNonTeachingStaff,
    "totalStaff": totalStaff,
    "SmcVecName": SmcVecName,
    "genderVec": genderVec,
    "vecMobile": vecMobile,
    "vecEmail": vecEmail,
    "vecQualification": vecQualification,
    "vecTotal": vecTotal,
    "meetingDuration": meetingDuration,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "other": other,
    "otherQual": otherQual,



  };
}
