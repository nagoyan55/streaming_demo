import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:streaming_demo/model/asset_data.dart';
import 'package:streaming_demo/model/video_data.dart';
import 'package:streaming_demo/res/string.dart';
import 'package:streaming_demo/utils/mux_client.dart';

main() {
  late Dio dio;
  group('MUX API mock tests', () {
    late DioAdapter dioAdapter;
    late MUXClient muxClient;

    setUpAll(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      muxClient = MUXClient();
      muxClient.initializeDio();
    });

    test('GET videos', () async {
      const path = '$muxServerUrl/assets';

      String testJsonResponse =
          '{"data":[{"id":"00x9MR241hEFbnZcvOEWJeLLf2ODzeU7pX9vVkrKukA00","status":"ready","playback_ids":[{"policy":"public","id":"24zgMDnLDfr6KqmprWCFhkAIF01RZUBBzy2J4dl2jj2k"}],"created_at":"1661402660","duration":10.143467,"max_stored_resolution":"HD","max_stored_frame_rate":29.97,"aspect_ratio":"16:9"},{"id":"Ko4xfsDGE8OoALyizmsS02YeHpI5Mr63TqpWgyM1fMQE","status":"ready","playback_ids":[{"policy":"public","id":"UhD00Z7sSB9scugiInAclP9SNeo01xXIrdd001J9f4qTdI"}],"created_at":"1661400731","duration":10.143467,"max_stored_resolution":"HD","max_stored_frame_rate":29.97,"aspect_ratio":"16:9"}]}';
      dio.httpClientAdapter = dioAdapter;
      dioAdapter.onGet(path, (server) => server.reply(200, testJsonResponse));

      final onGetResponse = await dio.get(path);

      expect(await muxClient.getAssetList(), isA<AssetData>());
      expect(onGetResponse.data, testJsonResponse);
    });

    test('GET status', () async {
      const String videoId = 'ljInU8GAdmZq002FRaXZunA02doynkkNzs02GtlTlTLsrA';
      const path = '/asset';

      String testJsonResponse =
          '{"data":{"id":"Ko4xfsDGE8OoALyizmsS02YeHpI5Mr63TqpWgyM1fMQE","status":"ready","playback_ids":[{"policy":"public","id":"UhD00Z7sSB9scugiInAclP9SNeo01xXIrdd001J9f4qTdI"}],"created_at":"1661400731","duration":10.143467,"max_stored_resolution":"HD","max_stored_frame_rate":29.97,"aspect_ratio":"16:9"}}';
      dio.httpClientAdapter = dioAdapter;
      dioAdapter.onGet(path, (server) => server.reply(200, testJsonResponse));

      final onGetresopnse =
          await dio.get(path, queryParameters: {'videoId': videoId});

      expect(
          await muxClient.checkPostStatus(videoId: videoId), isA<VideoData>());
      expect(onGetresopnse.data, testJsonResponse);
    });

    test('POST a video', () async {
      const path = '$muxServerUrl/assets';
      String testJsonResponse =
          '{"data":{"id":"Ko4xfsDGE8OoALyizmsS02YeHpI5Mr63TqpWgyM1fMQE","status":"ready","playback_ids":[{"policy":"public","id":"UhD00Z7sSB9scugiInAclP9SNeo01xXIrdd001J9f4qTdI"}],"created_at":"1661400731","duration":10.143467,"max_stored_resolution":"HD","max_stored_frame_rate":29.97,"aspect_ratio":"16:9"}}';
      dio.httpClientAdapter = dioAdapter;
      dioAdapter
          .onPost(path, (server) => server.reply(200, testJsonResponse), data: {
        "input": demoVideoUrl,
        "playback_policy": playbackPolicy,
      });

      final onPostResponse = await dio.post(path, data: {
        "input": demoVideoUrl,
        "playback_policy": playbackPolicy,
      });

      expect(
          await muxClient.storeVideo(videoUrl: demoVideoUrl), isA<VideoData>());
      expect(onPostResponse.data, testJsonResponse);
    });
  });
}
