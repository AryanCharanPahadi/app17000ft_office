
import 'dart:convert';

List<LibIssue?>? libIssueFromJson(String str) =>
    str.isEmpty ? [] : List<LibIssue?>.from(json.decode(str).map((x) => LibIssue.fromJson(x)));

String libIssueToJson(List<LibIssue?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class LibIssue {
  String? issueExist;
  String? issueName;
  String? issueDescription;
  String? lib_issue_img;
  String? issueReportOn;
  String? issueReportBy;
  String? issueStatus;
  String? issueResolvedOn;
  String? issueResolvedBy;
  String? uniqueId;
  int? id;

  LibIssue({
    this.issueExist,
    this.issueName,
    this.issueDescription,
    this.lib_issue_img,
    this.issueReportOn,
    this.issueReportBy,
    this.issueStatus,
    this.issueResolvedOn,
    this.issueResolvedBy,
    this.uniqueId,
    this.id,
  });

  factory LibIssue.fromJson(Map<String, dynamic> json) => LibIssue(
    issueExist: json["lib_issue"],
    issueName: json["lib_issue_value"],
    issueDescription: json["lib_desc"],
    lib_issue_img: json["lib_issue_img"],
    issueReportOn: json["reported_on"],
    issueReportBy: json["reported_by"],
    issueStatus: json["issue_status"],
    issueResolvedOn: json["resolved_on"],
    issueResolvedBy: json["resolved_by"],
    uniqueId: json["unique_id"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    'lib_issue': issueExist,
    'lib_issue_value': issueName,
    'lib_desc': issueDescription,
    'lib_issue_img': lib_issue_img,
    'reported_on': issueReportOn,
    'reported_by': issueReportBy,
    'issue_status': issueStatus,
    'resolved_on': issueResolvedOn,
    'resolved_by': issueResolvedBy,
    'unique_id': uniqueId,
    "id": id,
  };
}
