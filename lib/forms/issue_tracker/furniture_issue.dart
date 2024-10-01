
import 'dart:convert';

List<FurnitureIssue?>? furnitureIssueFromJson(String str) =>
    str.isEmpty ? [] : List<FurnitureIssue?>.from(json.decode(str).map((x) => FurnitureIssue.fromJson(x)));

String furnitureIssueToJson(List<FurnitureIssue?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class FurnitureIssue {
  String? issueExist;
  String? issueName;
  String? issueDescription;
  String? furn_issue_img;
  String? issueReportOn;
  String? issueReportBy;
  String? issueStatus;
  String? issueResolvedOn;
  String? issueResolvedBy;
  String? uniqueId;
  int? id;

  FurnitureIssue({
    this.issueExist,
    this.issueName,
    this.issueDescription,
    this.furn_issue_img,
    this.issueReportOn,
    this.issueReportBy,
    this.issueStatus,
    this.issueResolvedOn,
    this.issueResolvedBy,
    this.uniqueId,
    this.id,
  });

  factory FurnitureIssue.fromJson(Map<String, dynamic> json) => FurnitureIssue(
    issueExist: json['furniture_issue'],
    issueName: json['furniture_issue_value'],
    issueDescription: json['furniture_desc'],
    furn_issue_img: json['furn_issue_img'],
    issueReportOn: json['reported_on'],
    issueReportBy: json['reported_by'],
    issueStatus: json['issue_status'],
    issueResolvedOn: json['resolved_on'],
    issueResolvedBy: json['resolved_by'],
    uniqueId: json['unique_id'],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    'furniture_issue': issueExist,
    'furniture_issue_value': issueName,
    'furniture_desc': issueDescription,
    'furn_issue_img': furn_issue_img,
    'reported_on': issueReportOn,
    'reported_by': issueReportBy,
    'issue_status': issueStatus,
    'resolved_on': issueResolvedOn,
    'resolved_by': issueResolvedBy,
    'unique_id': uniqueId,
    "id": id,
  };
}
