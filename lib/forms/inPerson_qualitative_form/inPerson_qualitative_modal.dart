// To parse this JSON data, do
//
//     final enrolmentCollectionModel = enrolmentCollectionModelFromJson(jsonString);

import 'dart:convert';

InPersonQualitativeRecords inPersonQualitativeRecordsFromJson(String str) => InPersonQualitativeRecords.fromJson(json.decode(str));

String inPersonQualitativeRecordsToJson(InPersonQualitativeRecords data) => json.encode(data.toJson());

class InPersonQualitativeRecords{
  int? id;
  String? tourId;
  String? school;
  String? udicevalue;
  String? correct_udice;
  String? imgPath;
  String? school_digiLab;
  String? school_library;
  String? school_playground;
  String? hm_interview;
  String? hm_reason;
  String? hmques1;
  String? hmques2;
  String? hmques3;
  String? hmques4;
  String? hmques5;
  String? hmques6;
  String? hmques6_1;
  String? hmques7;
  String? hmques8;
  String? hmques9;
  String? hmques10;
  String? steacher_interview;
  String? steacher_reason;
  String? stques1;
  String? stques2;
  String? stques3;
  String? stques4;
  String? stques5;
  String? stques6;
  String? stques6_1;
  String? stques7;
  String? stques7_1;
  String? stques8;
  String? stques8_1;
  String? stques9;
  String? student_interview;
  String? student_reason;
  String? stuques1;
  String? stuques2;
  String? stuques3;
  String? stuques4;
  String? stuques5;
  String? stuques6;
  String? stuques7;
  String? stuques8;
  String? stuques9;
  String? stuques10;
  String? stuques11;
  String? stuques11_1;
  String? stuques11_2;
  String? stuques11_3;
  String? stuques12;
  String? smc_interview;
  String? smc_reason;
  String? smcques1;
  String? smcques2;
  String? smcques3;
  String? smcques3_1;
  String? smcques3_2;
  String? smcques_4;
  String? smcques4_1;
  String? smcques_5;
  String? smcques_6;
  String? smcques_7;
  String? created_at;
  String? submitted_at;
  String? submitted_by;
  String? unique_id;






  InPersonQualitativeRecords({
    this.id,
    required this.tourId,
    required this.school,
    required this.udicevalue,
    required this.correct_udice,
    required this.imgPath,
    required this.school_digiLab,
    required this.school_library,
    required this.school_playground,
    required this.hm_interview,
    required this.hm_reason,
    required this.hmques1,
    required this.hmques2,
    required this.hmques3,
    required this.hmques4,
    required this.hmques5,
    required this.hmques6,
    required this.hmques6_1,
    required this.hmques7,
    required this.hmques8,
    required this.hmques9,
    required this.hmques10,
    required this.steacher_interview,
    required this.steacher_reason,
    required this.stques1,
    required this.stques2,
    required this.stques3,
    required this.stques4,
    required this.stques5,
    required this.stques6,
    required this.stques6_1,
    required this.stques7,
    required this.stques7_1,
    required this.stques8,
    required this.stques8_1,
    required this.stques9,
    required this.student_interview,
    required this.student_reason,
    required this.stuques1,
    required this.stuques2,
    required this.stuques3,
    required this.stuques4,
    required this.stuques5,
    required this.stuques6,
    required this.stuques7,
    required this.stuques8,
    required this.stuques9,
    required this.stuques10,
    required this.stuques11,
    required this.stuques11_1,
    required this.stuques11_2,
    required this.stuques11_3,
    required this.stuques12,
    required this.smc_interview,
    required this.smc_reason,
    required this.smcques1,
    required this.smcques2,
    required this.smcques3,
    required this.smcques3_1,
    required this.smcques3_2,
    required this.smcques_4,
    required this.smcques4_1,
    required this.smcques_5,
    required this.smcques_6,
    required this.smcques_7,
    required this.created_at,
    required this.submitted_at,
    required this.submitted_by,
    required this.unique_id,





  });

  factory InPersonQualitativeRecords.fromJson(Map<String, dynamic> json) => InPersonQualitativeRecords(
    id: json["id"],
    tourId: json["tourId"],
    school: json["school"],
    udicevalue: json["udicevalue"],
    correct_udice: json["correct_udice"],
    imgPath: json["imgPath"],
    school_digiLab: json["school_digiLab"],
    school_library: json["school_library"],
    school_playground: json["school_playground"],
    hm_interview: json["hm_interview"],
    hm_reason: json["hm_reason"],
    hmques1: json["hmques1"],
    hmques2: json["hmques2"],
    hmques3: json["hmques3"],
    hmques4: json["hmques4"],
    hmques5: json["hmques5"],
    hmques6: json["hmques6"],
    hmques6_1: json["hmques6_1"],
    hmques7: json["hmques7"],
    hmques8: json["hmques8"],
    hmques9: json["hmques9"],
    hmques10: json["hmques10"],
    steacher_interview: json["steacher_interview"],
    steacher_reason: json["steacher_reason"],
    stques1: json["stques1"],
    stques2: json["stques2"],
    stques3: json["stques3"],
    stques4: json["stques4"],
    stques5: json["stques5"],
    stques6: json["stques6"],
    stques6_1: json["stques6_1"],
    stques7: json["stques7"],
    stques7_1: json["stques7_1"],
    stques8: json["stques8"],
    stques8_1: json["stques8_1"],
    stques9: json["stques9"],
    student_interview: json["student_interview"],
    student_reason: json["student_reason"],
    stuques1: json["stuques1"],
    stuques2: json["stuques2"],
    stuques3: json["stuques3"],
    stuques4: json["stuques4"],
    stuques5: json["stuques5"],
    stuques6: json["stuques6"],
    stuques7: json["stuques7"],
    stuques8: json["stuques8"],
    stuques9: json["stuques9"],
    stuques10: json["stuques10"],
    stuques11: json["stuques11"],
    stuques11_1: json["stuques11_1"],
    stuques11_2: json["stuques11_2"],
    stuques11_3: json["stuques11_3"],
    stuques12: json["stuques12"],
    smc_interview: json["smc_interview"],
    smc_reason: json["smc_reason"],
    smcques1: json["smcques1"],
    smcques2: json["smcques2"],
    smcques3: json["smcques3"],
    smcques3_1: json["smcques3_1"],
    smcques3_2: json["smcques3_2"],
    smcques_4: json["smcques_4"],
    smcques4_1: json["smcques4_1"],
    smcques_5: json["smcques_5"],
    smcques_6: json["smcques_6"],
    smcques_7: json["smcques_7"],
    created_at: json["created_at"],
    submitted_at: json["submitted_at"],
    submitted_by: json["submitted_by"],
    unique_id: json["unique_id"],




  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tourId": tourId,
    "school": school,
    "udicevalue": udicevalue,
    "correct_udice": correct_udice,
    "imgPath": imgPath,
    "school_digiLab": school_digiLab,
    "school_library": school_library,
    "school_playground": school_playground,
    "hm_interview": hm_interview,
    "hm_reason": hm_reason,
    "hmques1": hmques1,
    "hmques2": hmques2,
    "hmques3": hmques3,
    "hmques4": hmques4,
    "hmques5": hmques5,
    "hmques6": hmques6,
    "hmques6_1": hmques6_1,
    "hmques7": hmques7,
    "hmques8": hmques8,
    "hmques9": hmques9,
    "hmques10": hmques10,
    "steacher_interview": steacher_interview,
    "steacher_reason": steacher_reason,
    "stques1": stques1,
    "stques2": stques2,
    "stques3": stques3,
    "stques4": stques4,
    "stques5": stques5,
    "stques6": stques6,
    "stques6_1": stques6_1,
    "stques7": stques7,
    "stques7_1": stques7_1,
    "stques8": stques8,
    "stques8_1": stques8_1,
    "stques9": stques9,
    "student_interview": student_interview,
    "student_reason": student_reason,
    "stuques1": stuques1,
    "stuques2": stuques2,
    "stuques3": stuques3,
    "stuques4": stuques4,
    "stuques5": stuques5,
    "stuques6": stuques6,
    "stuques7": stuques7,
    "stuques8": stuques8,
    "stuques9": stuques9,
    "stuques10": stuques10,
    "stuques11": stuques11,
    "stuques11_1": stuques11_1,
    "stuques11_2": stuques11_2,
    "stuques11_3": stuques11_3,
    "stuques12": stuques12,
    "smc_interview": smc_interview,
    "smc_reason": smc_reason,
    "smcques1": smcques1,
    "smcques2": smcques2,
    "smcques3": smcques3,
    "smcques3_1": smcques3_1,
    "smcques3_2": smcques3_2,
    "smcques_4": smcques_4,
    "smcques4_1": smcques4_1,
    "smcques_5": smcques_5,
    "smcques_6": smcques_6,
    "smcques_7": smcques_7,
    "created_at": created_at,
    "submitted_at": submitted_at,
    "submitted_by": submitted_by,
    "unique_id": unique_id,




  };
}
