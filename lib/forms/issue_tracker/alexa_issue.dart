import 'dart:convert';

List<AlexaIssue?>? alexaIssueFromJson(String str) =>
    str.isEmpty ? [] : List<AlexaIssue?>.from(json.decode(str).map((x) => AlexaIssue.fromJson(x)));
String alexaIssueToJson(List<AlexaIssue?>? data) =>
    json.encode(data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class AlexaIssue {
  AlexaIssue({
    this.id,
    this.issueExist,
    this.issueName,
    this.issueDescription,
    this.alexa_issue_img,
    this.issueReportOn,
    this.issueReportBy,
    this.issueStatus,
    this.issueResolvedOn,
    this.issueResolvedBy,
    this.uniqueId,
    this.other,
    this.missingDot,
    this.notConfiguredDot,
    this.notConnectingDot,
    this.notChargingDot,
  });

  int? id;
  String? issueExist;
  String? issueName;
  String? issueDescription;
  String? alexa_issue_img;
  String? issueReportOn;
  String? issueReportBy;
  String? issueStatus;
  String? issueResolvedOn;
  String? issueResolvedBy;
  String? uniqueId;
  String? other;
  String? missingDot;
  String? notConfiguredDot;
  String? notConnectingDot;
  String? notChargingDot;

  factory AlexaIssue.fromJson(Map<String, dynamic> json) => AlexaIssue(
    id: json["id"],
    issueExist: json['alexa_issue'],
    issueName: json['alexa_issueValue'],
    issueDescription: json['alexa_desc'],
    alexa_issue_img: json['alexa_issue_img'],
    issueReportOn: json['reported_date'],
    issueReportBy: json['reported_by'],
    issueStatus: json['issue_status'],
    issueResolvedOn: json['resolved_on'],
    issueResolvedBy: json['resolved_by'],
    uniqueId: json['unique_id'],
    other: json['other'],
    missingDot: json['missing_dot'],
    notConfiguredDot: json['notConfigured_dot'],
    notConnectingDot: json['notConnecting_dot'],
    notChargingDot: json['notCharging_dot'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    'alexa_issue': issueExist,
    'alexa_issueValue': issueName,
    'alexa_desc': issueDescription,
    'alexa_issue_img': alexa_issue_img, //
    'reported_date': issueReportOn,
    'reported_by': issueReportBy,
    'issue_status': issueStatus,
    'resolved_on': issueResolvedOn,
    'resolved_by': issueResolvedBy,
    'unique_id': uniqueId,
    'other': other,
    'missing_dot': missingDot,
    'notConfigured_dot': notConfiguredDot,
    'notConnecting_dot': notConnectingDot,
    'notCharging_dot': notChargingDot,
  };
}
