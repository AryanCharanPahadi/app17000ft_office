import 'dart:convert';

List<InPersonQuantitativeRecords?>? inPersonQuantitativeRecordsFromJson(String str) =>
    str.isEmpty ? [] : List<InPersonQuantitativeRecords?>.from(json.decode(str).map((x) => InPersonQuantitativeRecords.fromJson(x)));
String inPersonQuantitativeRecordsToJson(List<InPersonQuantitativeRecords?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));
class InPersonQuantitativeRecords {
  InPersonQuantitativeRecords({

    this.id,
    this.tourId,
    this.school,
    this.udicevalue,
    this.correct_udice,
    this.imgpath,
    required this.no_enrolled,
    this.timetable_available,
    this.class_scheduled,

    this.remarks_scheduling,
    this.admin_appointed,
    this.admin_trained,
    this.admin_name,
    this.admin_phone,
    this.sub_teacher_trained,
    this.teacher_ids,

    this.no_staff,
    this.training_pic,
    this.specifyOtherTopics,
    this.practical_demo,
    this.reason_demo,
    this.comments_capacity,
    this.children_comfortable,
    this.children_understand,
    this.post_test,
    this.resolved_doubts,
    this.logs_filled,
    this.filled_correctly,
    this.send_report,
    this.app_installed,
    this.data_synced,
    this.last_syncedDate,
    this.lib_timetable,
    this.timetable_followed,
    this.registered_updated,
    this.observation_comment,
    this.topicsCoveredInTraining,
    this.participant_name,
    this.major_issue,
    this.created_at,
    this.submitted_by,
    this.unique_id,
  });

  int? id;
  String? tourId;
  String? school;
  String? udicevalue;
  String? correct_udice;
  String? imgpath;
  String no_enrolled;
  String? timetable_available;
  String? class_scheduled;

  String? remarks_scheduling;
  String? admin_appointed;
  String? admin_trained;
  String? admin_name;
  String? admin_phone;
  String? sub_teacher_trained;
  String? teacher_ids;

  String? no_staff;
  String? training_pic;
  String? specifyOtherTopics;
  String? practical_demo;
  String? reason_demo;

  String? comments_capacity;
  String? children_comfortable;
  String? children_understand;
  String? post_test;
  String? resolved_doubts;
  String? logs_filled;
  String? filled_correctly;
  String? send_report;
  String? app_installed;
  String? data_synced;
  String? last_syncedDate;
  String? lib_timetable;
  String? timetable_followed;
  String? registered_updated;
  String? observation_comment;
  String? topicsCoveredInTraining;
  String? participant_name;
  String? major_issue;

  String? created_at;
  String? submitted_by;

  String? unique_id;

  factory InPersonQuantitativeRecords.fromJson(Map<String, dynamic> json) => InPersonQuantitativeRecords(
    id: json["id"],
    tourId: json["tourId"],
    school: json["school"],
    udicevalue: json["udicevalue"],
    correct_udice: json["correct_udice"],
    imgpath: json["imgpath"],
    no_enrolled: json["no_enrolled"],
    timetable_available: json["timetable_available"],
    class_scheduled: json["class_scheduled"],

    remarks_scheduling: json["remarks_scheduling"],
    admin_appointed: json["admin_appointed"],
    admin_trained: json["admin_trained"],
    admin_name: json["admin_name"],
    admin_phone: json["admin_phone"],
    sub_teacher_trained: json["sub_teacher_trained"],
    teacher_ids: json["teacher_ids"],

    no_staff: json["no_staff"],
    training_pic: json["training_pic"],
    specifyOtherTopics: json["specifyOtherTopics"],
    practical_demo: json["practical_demo"],
    reason_demo: json["reason_demo"],
    comments_capacity: json["comments_capacity"],
    children_comfortable: json["children_comfortable"],
    children_understand: json["children_understand"],
    post_test: json["post_test"],
    resolved_doubts: json["resolved_doubts"],
    logs_filled: json["logs_filled"],
    filled_correctly: json["filled_correctly"],
    send_report: json["send_report"],
    app_installed: json["app_installed"],
    data_synced: json["data_synced"],
    last_syncedDate: json["last_syncedDate"],
    lib_timetable: json["lib_timetable"],
    timetable_followed: json["timetable_followed"],
    registered_updated: json["registered_updated"],
    observation_comment: json["observation_comment"],
    topicsCoveredInTraining: json["topicsCoveredInTraining"],
    participant_name: json["participant_name"],
    major_issue: json["major_issue"],

    created_at: json["created_at"],
    submitted_by: json["submitted_by"],

    unique_id: json["unique_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tourId": tourId,
    "school": school,
    "udicevalue": udicevalue,
    "correct_udice": correct_udice,
    "imgpath": imgpath,
    "no_enrolled": no_enrolled,
    "timetable_available": timetable_available,
    "class_scheduled": class_scheduled,

    "remarks_scheduling": remarks_scheduling,
    "admin_appointed": admin_appointed,
    "admin_trained": admin_trained,
    "admin_name": admin_name,
    "admin_phone": admin_phone,
    "sub_teacher_trained": sub_teacher_trained,
    "teacher_ids": teacher_ids,

    "no_staff": no_staff,
    "training_pic": training_pic,
    "specifyOtherTopics": specifyOtherTopics,
    "practical_demo": practical_demo,
    "reason_demo": reason_demo,
    "comments_capacity": comments_capacity,
    "children_comfortable": children_comfortable,
    "children_understand": children_understand,
    "post_test": post_test,
    "resolved_doubts": resolved_doubts,
    "logs_filled": logs_filled,
    "filled_correctly": filled_correctly,
    "send_report": send_report,
    "app_installed": app_installed,
    "data_synced": data_synced,
    "last_syncedDate": last_syncedDate,
    "lib_timetable": lib_timetable,
    "timetable_followed": timetable_followed,
    "registered_updated": registered_updated,
    "observation_comment": observation_comment,
    "topicsCoveredInTraining": topicsCoveredInTraining,
    "participant_name": participant_name,
    "major_issue": major_issue,

    "created_at": created_at,
    "submitted_by": submitted_by,

    "unique_id": unique_id,
  };
}
