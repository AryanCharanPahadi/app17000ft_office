// ignore_for_file: file_names

import 'dart:convert';

List<CabMeterTracingRecords> cabMeterTracingRecordsFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<CabMeterTracingRecords>.from(
        json.decode(str).map((x) => CabMeterTracingRecords.fromJson(x)));

String cabMeterTracingRecordsToJson(List<CabMeterTracingRecords> data) =>
    json.encode(
        List<dynamic>.from(data.map((x) => x.toJson())));

class CabMeterTracingRecords {
  CabMeterTracingRecords({
    this.id,
    this.status,
    this.place_visit,
    this.remarks,
    this.vehicle_num,
    this.driver_name,
    this.meter_reading,
    this.image,
    this.user_id,
    this.created_at,
    this.office,
    this.version,
    this.uniqueId,
    this.tour_id,
  });

  int? id;
  String? status;
  String? place_visit;
  String? remarks;
  String? vehicle_num;
  String? driver_name;
  String? meter_reading;
  String? image;
  String? user_id;
  String? created_at;
  String? office;
  String? version;
  String? uniqueId;
  String? tour_id;
  factory CabMeterTracingRecords.fromJson(Map<String, dynamic> json) =>
      CabMeterTracingRecords(
        id: json["id"],
        status: json["status"],
        place_visit: json["place_visit"],
        remarks: json["remarks"],
        vehicle_num: json["vehicle_num"],
        driver_name: json["driver_name"],
        meter_reading: json["meter_reading"],
        image: json["image"],
        user_id: json["user_id"],
        created_at: json["created_at"],
        office: json["office"],
        version: json["version"],
        uniqueId: json["uniqueId"],
        tour_id: json["tour_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "place_visit": place_visit,
    "remarks": remarks,
    "vehicle_num": vehicle_num,
    "driver_name": driver_name,
    "meter_reading": meter_reading,
    "image": image,
    "user_id": user_id,
    "created_at": created_at,
    "office": office,
    "version": version,
    "uniqueId": uniqueId,
    "tour_id": tour_id,
  };
}
