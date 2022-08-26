import 'dart:convert';

class Track {
  Track({
    required this.maxWidth,
    required this.type,
    required this.id,
    required this.duration,
    required this.maxFrameRate,
    required this.maxHeight,
    required this.maxChannelLayout,
    required this.maxChannels,
  });

  int maxWidth;
  int maxHeight;
  String type;
  String id;
  double duration;
  double maxFrameRate;
  String maxChannelLayout;
  int maxChannels;

  factory Track.fromRawJson(String str) => Track.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        maxWidth: int.parse(json["max_width"] ?? "0"),
        maxHeight: int.parse(json["max_height"] ?? "0"),
        type: json["type"] ?? "null",
        id: json["id"] ?? "null",
        duration: double.parse(json["duration"] ?? "0"),
        maxFrameRate: double.parse(json["max_frame_rate"] ?? "0"),
        maxChannelLayout: json["max_channel_layout"] ?? "null",
        maxChannels: int.parse(json["max_channels"] ?? "0"),
      );

  Map<String, dynamic> toJson() => {
        "max_width": maxWidth,
        "type": type,
        "id": id,
        "duration": duration,
        "max_frame_rate": maxFrameRate,
        "max_height": maxHeight,
        "max_channel_layout": maxChannelLayout,
        "max_channels": maxChannels,
      };
}
