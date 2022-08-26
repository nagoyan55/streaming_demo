import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streaming_demo/res/string.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_web/video_player_web.dart';

import '../model/common/data.dart';
import '../res/custom_colors.dart';
import '../widgets/info_tile.dart';

class PreviewPage extends StatefulWidget {
  final Data assetData;
  const PreviewPage({super.key, required this.assetData});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late final VideoPlayerController _controller;
  late final Data assetData;
  late final String dateTimeString;

  @override
  void initState() {
    super.initState();
    assetData = widget.assetData;
    String playbackId = assetData.playbackIds[0].id;
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
        int.parse(assetData.createdAt) * 1000);
    DateFormat formatter = DateFormat.yMd().add_jm();
    dateTimeString = formatter.format(dateTime);
    try {
      String path = '$muxStreamBaseUrl/$playbackId.$videoExtension';
      _controller = VideoPlayerController.network(path)
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
      _controller.play();
    } catch (e) {
      print('controller initialization error: $e');
      throw ('Preview Page init failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Video preview'),
        backgroundColor: CustomColors.muxPink,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    width: double.maxFinite,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.muxPink,
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          width: double.maxFinite,
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColors.muxPink,
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile(
                    name: 'AssetID',
                    data: assetData.id,
                  ),
                  InfoTile(
                    name: 'Created',
                    data: dateTimeString,
                  ),
                  InfoTile(
                    name: 'Status',
                    data: assetData.status,
                  ),
                  InfoTile(
                    name: 'Duration',
                    data: '${assetData.duration.toStringAsFixed(2)} seconds',
                  ),
                  InfoTile(
                    name: 'Max Resolution',
                    data: assetData.maxStoredResolution,
                  ),
                  InfoTile(
                    name: 'Max Frame Rate',
                    data: assetData.maxStoredFrameRate.toString(),
                  ),
                  InfoTile(
                    name: 'AsectRatio',
                    data: assetData.aspectRatio,
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
