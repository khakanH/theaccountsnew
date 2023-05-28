// To parse this JSON data, do
//
//     final transferRollover = transferRolloverFromJson(jsonString);

import 'dart:convert';

TransferRollover transferRolloverFromJson(String str) =>
    TransferRollover.fromJson(json.decode(str));

String transferRolloverToJson(TransferRollover data) =>
    json.encode(data.toJson());

class TransferRollover {
  TransferRollover({
    this.data,
    this.message,
    this.errorList,
  });

  Data? data;
  dynamic message;
  List<String>? errorList;

  factory TransferRollover.fromJson(Map<String, dynamic> json) =>
      TransferRollover(
        data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
        message: json["Message"],
        errorList: json["ErrorList"] == null
            ? null
            : List<String>.from(json["ErrorList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Data": data == null ? null : data?.toJson(),
        "Message": message,
        "ErrorList": errorList == null
            ? null
            : List<dynamic>.from(errorList!.map((x) => x)),
      };
}

class Data {
  Data({
    this.status,
    this.closingPayment,
    this.transferRolloverRequest,
  });

  bool? status;
  num? closingPayment;
  TransferRolloverRequest? transferRolloverRequest;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["Status"] == null ? null : json["Status"],
        closingPayment:
            json["ClosingPayment"] == null ? null : json["ClosingPayment"],
        transferRolloverRequest: json["TransferRolloverRequest"] == null
            ? null
            : TransferRolloverRequest.fromJson(json["TransferRolloverRequest"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status == null ? null : status,
        "ClosingPayment": closingPayment == null ? null : closingPayment,
        "TransferRolloverRequest": transferRolloverRequest == null
            ? null
            : transferRolloverRequest?.toJson(),
      };
}

class TransferRolloverRequest {
  TransferRolloverRequest({
    this.closingPayment,
    this.transfer,
    this.rollover,
    this.requestDate,
    this.status,
  });

  num? closingPayment;
  num? transfer;
  num? rollover;
  DateTime? requestDate;
  String? status;

  factory TransferRolloverRequest.fromJson(Map<String, dynamic> json) =>
      TransferRolloverRequest(
        closingPayment:
            json["ClosingPayment"] == null ? null : json["ClosingPayment"],
        transfer: json["Transfer"] == null ? null : json["Transfer"],
        rollover: json["Rollover"] == null ? null : json["Rollover"],
        requestDate: json["RequestDate"] == null
            ? null
            : DateTime.parse(json["RequestDate"]),
        status: json["Status"] == null ? null : json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "ClosingPayment": closingPayment == null ? null : closingPayment,
        "Transfer": transfer == null ? null : transfer,
        "Rollover": rollover == null ? null : rollover,
        "RequestDate":
            requestDate == null ? null : requestDate?.toIso8601String(),
        "Status": status == null ? null : status,
      };
}
