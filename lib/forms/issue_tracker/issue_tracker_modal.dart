import 'dart:convert';



List<IssueTrackerRecords?>? issueTrackerRecordsFromJson(String str) =>
    str.isEmpty ? [] : List<IssueTrackerRecords?>.from(json.decode(str).map((x) => IssueTrackerRecords.fromJson(x)));
String issueTrackerRecordsToJson(List<IssueTrackerRecords?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));
class IssueTrackerRecords {
  // Existing fields
  String? tourId;
  String? school;
  String? udiseCode;
  String? correctUdise;
  String? uniqueId;
  String? office;
  String? createdAt;
  String? created_by;
  int? id;

   // Add this field for LibIssue list
  // List<LibIssue?>? libIssueList;

  IssueTrackerRecords({
    this.tourId,
    this.school,
    this.udiseCode,
    this.correctUdise,
    this.createdAt,
    this.created_by,
    this.office,
    this.uniqueId,
    this.id,

  });

  // Update the fromJson and toJson methods to include libIssueList
  factory IssueTrackerRecords.fromJson(Map<String, dynamic> json) => IssueTrackerRecords(
    tourId: json["tourId"],
    school: json["school"],
    udiseCode: json["udiseCode"],
    correctUdise: json["correctUdise"],
    createdAt: json["created_at"],
    created_by: json["created_by"],
    uniqueId: json["uniqueId"],
    office: json["office"],
    id: json["id"],

  );

  Map<String, dynamic> toJson() => {
    "tourId": tourId,
    "school": school,
    "udiseCode": udiseCode,
    "correctUdise": correctUdise,
    "created_at": createdAt,
    "created_by": created_by,
    "uniqueId": uniqueId,
    "office": office,
    "id": id,

  };
}

