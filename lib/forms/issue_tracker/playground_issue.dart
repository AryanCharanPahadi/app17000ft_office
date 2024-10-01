
import 'dart:convert';

List<PlaygroundIssue?>? playgroundIssueFromJson(String str) =>
    str.isEmpty ? [] : List<PlaygroundIssue?>.from(json.decode(str).map((x) => PlaygroundIssue.fromJson(x)));

String playgroundIssueToJson(List<PlaygroundIssue?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class PlaygroundIssue {
  String? issueExist;
  String? issueName;
  String? issueDescription;
  String? play_issue_img;
  String? issueReportOn;
  String? issueReportBy;
  String? issueStatus;
  String? issueResolvedOn;
  String? issueResolvedBy;
  String? uniqueId;
  int? id;

  PlaygroundIssue({
    this.issueExist,
    this.issueName,
    this.issueDescription,
    this.play_issue_img,
    this.issueReportOn,
    this.issueReportBy,
    this.issueStatus,
    this.issueResolvedOn,
    this.issueResolvedBy,
    this.uniqueId,
    this.id,
  });

  factory PlaygroundIssue.fromJson(Map<String, dynamic> json) => PlaygroundIssue(
    issueExist: json['play_issue'],
    issueName: json['play_issue_value'],
    issueDescription: json['play_desc'],
    play_issue_img: json['play_issue_img'],
    issueReportOn: json['reported_on'],
    issueReportBy: json['reported_by'],
    issueStatus: json['issue_status'],
    issueResolvedOn: json['resolved_on'],
    issueResolvedBy: json['resolved_by'],
    uniqueId: json['unique_id'],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    'play_issue': issueExist,
    'play_issue_value': issueName,
    'play_desc': issueDescription,
    'play_issue_img': play_issue_img,
    'reported_on': issueReportOn,
    'reported_by': issueReportBy,
    'issue_status': issueStatus,
    'resolved_on': issueResolvedOn,
    'resolved_by': issueResolvedBy,
    'unique_id': uniqueId,
    "id": id,
  };
}
