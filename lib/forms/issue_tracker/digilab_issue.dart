
import 'dart:convert';

List<DigiLabIssue?>? digiLabIssueFromJson(String str) =>
    str.isEmpty ? [] : List<DigiLabIssue?>.from(json.decode(str).map((x) => DigiLabIssue.fromJson(x)));

String digiLabIssueToJson(List<DigiLabIssue?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class DigiLabIssue {
  String? issueExist;
  String? issueName;
  String? issueDescription;
  String? dig_issue_img;
  String? issueReportOn;
  String? issueReportBy;
  String? issueStatus;
  String? issueResolvedOn;
  String? issueResolvedBy;
  String? uniqueId;
  String? tabletNumber;
  int? id;

  DigiLabIssue({
    this.issueExist,
    this.issueName,
    this.issueDescription,
    this.dig_issue_img,
    this.issueReportOn,
    this.issueReportBy,
    this.issueStatus,
    this.issueResolvedOn,
    this.issueResolvedBy,
    this.uniqueId,
    this.tabletNumber,
    this.id,
  });

  factory DigiLabIssue.fromJson(Map<String, dynamic> json) => DigiLabIssue(
    issueExist: json['digi_issue'],
    issueName: json['digi_issueValue'],
    issueDescription: json['digi_desc'],
    dig_issue_img: json['dig_issue_img'],
    issueReportOn: json['reported_on'],
    issueReportBy: json['reported_by'],
    issueStatus: json['issue_status'],
    issueResolvedOn: json['resolved_on'],
    issueResolvedBy: json['resolved_by'],
    uniqueId: json['unique_id'],
    tabletNumber: json['tablet_number'],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    'digi_issue': issueExist,
    'digi_issueValue': issueName,
    'digi_desc': issueDescription,
    'dig_issue_img': dig_issue_img,
    'reported_on': issueReportOn,
    'reported_by': issueReportBy,
    'issue_status': issueStatus,
    'resolved_on': issueResolvedOn,
    'resolved_by': issueResolvedBy,
    'unique_id': uniqueId,
    'tablet_number': tabletNumber,
    "id": id,
  };
}
