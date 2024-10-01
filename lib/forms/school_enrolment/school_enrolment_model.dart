// To parse this JSON data, do
//
//     final enrolmentCollectionModel = enrolmentCollectionModelFromJson(jsonString);

import 'dart:convert';

EnrolmentCollectionModel enrolmentCollectionModelFromJson(String str) => EnrolmentCollectionModel.fromJson(json.decode(str));

String enrolmentCollectionModelToJson(EnrolmentCollectionModel data) => json.encode(data.toJson());
class EnrolmentCollectionModel {
    int? id;
    String? tourId;
    String? school;
    String? registerImage;
    String? enrolmentData;
    String? remarks;
    String? createdAt;
    String? submittedBy;
    String? submittedAt;

    EnrolmentCollectionModel({
        this.id,
         this.tourId,
         this.school,
         this.registerImage,
         this.enrolmentData,
         this.remarks,
         this.createdAt,
         this.submittedBy,
         this.submittedAt,
    });

    factory EnrolmentCollectionModel.fromJson(Map<String, dynamic> json) => EnrolmentCollectionModel(
        id: json["id"],
        tourId: json["tourId"],
        school: json["school"],
        registerImage: json["registerImage"],
        enrolmentData: json["enrolmentData"],
        remarks: json["remarks"],
        createdAt: json["createdAt"],
        submittedBy: json["submittedBy"],
        submittedAt: json["submittedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tourId": tourId,
        "school": school,
        "registerImage": registerImage,
        "enrolmentData": enrolmentData,
        "remarks": remarks,
        "createdAt": createdAt,
        "submittedBy": submittedBy,
        "submittedAt": submittedAt,
    };
}
