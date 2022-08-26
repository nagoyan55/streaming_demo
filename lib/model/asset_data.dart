import 'dart:convert';

import 'common/data.dart';

class AssetData {
  AssetData({
    required this.data,
  });

  List<Data> data;

  factory AssetData.fromRawJson(String str) =>
      AssetData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssetData.fromJson(Map<String, dynamic> json) => AssetData(
        data: json["data"] != null
            ? List<Data>.from((json["data"]).map((x) => Data.fromJson(x)))
            : <Data>[],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
