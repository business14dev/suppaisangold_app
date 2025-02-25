// To parse this JSON data, do
//
//     final pointResponse = pointResponseFromJson(jsonString);

import 'dart:convert';

List<PointResponse> pointResponseFromJson(String str) => List<PointResponse>.from(json.decode(str).map((x) => PointResponse.fromJson(x)));

String pointResponseToJson(List<PointResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PointResponse {
  DateTime? pointDate;
  String? pointTime;
  String? custId;
  String? description;
  String? refNo;
  double? point;
  int? autoNo;
  String? empName;
  String? branchName;
  double? custRemainPoint;

  PointResponse({
    this.pointDate,
    this.pointTime,
    this.custId,
    this.description,
    this.refNo,
    this.point,
    this.autoNo,
    this.empName,
    this.branchName,
    this.custRemainPoint,
  });

  factory PointResponse.fromJson(Map<String, dynamic> json) => PointResponse(
    pointDate: json["pointDate"] == null ? null : DateTime.parse(json["pointDate"]),
    pointTime: json["pointTime"],
    custId: json["custId"],
    description: json["description"],
    refNo: json["refNo"],
    point: json["point"],
    autoNo: json["autoNo"],
    empName: json["empName"],
    branchName: json["branchName"],
    custRemainPoint: json["custRemainPoint"],
  );

  Map<String, dynamic> toJson() => {
    "pointDate": pointDate?.toIso8601String(),
    "pointTime": pointTime,
    "custId": custId,
    "description": description,
    "refNo": refNo,
    "point": point,
    "autoNo": autoNo,
    "empName": empName,
    "branchName": branchName,
    "custRemainPoint": custRemainPoint,
  };
}
