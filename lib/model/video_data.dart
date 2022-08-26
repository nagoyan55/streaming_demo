import 'dart:convert';

import 'common/data.dart';

class VideoData {
  VideoData({
    required this.data,
  });

  Data data;

  factory VideoData.fromRawJson(String str) =>
      VideoData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
        data: json["data"] != null ? Data.fromJson(json["data"]) : Data.empty(),
      );
  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}
