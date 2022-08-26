import 'dart:convert';

import 'package:streaming_demo/model/common/playback_id.dart';
import 'package:streaming_demo/model/common/track.dart';

class Data {
  Data(
      {required this.test,
      required this.maxStoredFrameRate,
      required this.status,
      required this.tracks,
      required this.id,
      required this.maxStoredResolution,
      required this.masterAccess,
      required this.playbackIds,
      required this.createdAt,
      required this.duration,
      required this.mp4Support,
      required this.aspectRatio});

  bool test;
  double maxStoredFrameRate;
  String status;
  List<Track> tracks;
  String id;
  String maxStoredResolution;
  String masterAccess;
  List<PlaybackId> playbackIds;
  String createdAt;
  double duration;
  String mp4Support;
  String aspectRatio;

  factory Data.empty() => Data(
        test: false,
        maxStoredFrameRate: 0,
        status: "null",
        tracks: <Track>[],
        id: "null",
        maxStoredResolution: "null",
        masterAccess: "null",
        playbackIds: <PlaybackId>[],
        createdAt: "null",
        duration: 0,
        mp4Support: "null",
        aspectRatio: "null",
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson);

  factory Data.fromJson(Map<String, dynamic> json) {
    try {
      return Data(
        test: json["test"] == "true",
        maxStoredFrameRate: json["max_stored_frame_rate"] ?? 0,
        status: json["status"] ?? "null",
        tracks: json["tracks"] != null
            ? List<Track>.from((json["tracks"]).map((x) => Track.fromJson(x)))
            : <Track>[],
        id: json["id"] ?? "null",
        maxStoredResolution: json["max_stored_resolution"] ?? "null",
        masterAccess: json["master_access"] ?? "null",
        playbackIds: json["playback_ids"] != null
            ? List<PlaybackId>.from(
                (json["playback_ids"]).map((x) => PlaybackId.fromJson(x)))
            : <PlaybackId>[],
        createdAt: json["created_at"] ?? "2000-0101T0000:00.000000Z",
        duration: json["duration"] ?? 0,
        mp4Support: json["mp4_support"] ?? "null",
        aspectRatio: json["aspect_ratio"] ?? "null",
      );
    } catch (e) {
      print('data construction error is occured: $e');
      throw Exception('Failed to data construction');
    }
  }

  Map<String, dynamic> toJson() => {
        "test": test,
        "max_stored_frame_rate": maxStoredFrameRate,
        "status": status,
        "tracks": List<dynamic>.from(tracks.map((x) => x.toJson())),
        "id": id,
        "max_stored_resolution": maxStoredResolution,
        "master_access": masterAccess,
        "playback_ids": List<dynamic>.from(playbackIds.map((x) => x.toJson())),
        "created_at": createdAt,
        "duration": duration,
        "mp4_support": mp4Support,
        "aspect_ratio": aspectRatio,
      };
}
