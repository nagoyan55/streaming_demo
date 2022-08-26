import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streaming_demo/res/string.dart';
import 'package:streaming_demo/utils/mux_client.dart';

import '../model/asset_data.dart';
import '../res/custom_colors.dart';
import '../widgets/video_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isProcessing = false;
  final MUXClient _muxClient = MUXClient();

  late TextEditingController _textControllerVideoURL;
  late FocusNode _textFocusNodeVideoURL;
  @override
  void initState() {
    super.initState();
    _muxClient.initializeDio();
    _textControllerVideoURL = TextEditingController(text: demoVideoUrl);
    _textFocusNodeVideoURL = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _textFocusNodeVideoURL.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text('Mux stream'),
          backgroundColor: CustomColors.muxPink,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              color: CustomColors.muxPink.withOpacity(0.06),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'UPLOAD',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
                      ),
                    ),
                    TextField(
                      focusNode: _textFocusNodeVideoURL,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        color: CustomColors.muxGray,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                      ),
                      controller: _textControllerVideoURL,
                      cursorColor: CustomColors.muxPinkLight,
                      autofocus: false,
                      onSubmitted: (value) {
                        _textFocusNodeVideoURL.unfocus();
                      },
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: CustomColors.muxPink,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black26,
                            width: 2,
                          ),
                        ),
                        labelText: 'Video URL',
                        labelStyle: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        hintText: 'Enter the URL of the video to upload',
                        hintStyle: TextStyle(
                          color: Colors.black12,
                          fontSize: 12.0,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    isProcessing
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 24.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Processing...',
                                  style: TextStyle(
                                    color: CustomColors.muxPink,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.muxPink,
                                  ),
                                  strokeWidth: 2,
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.muxPink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isProcessing = true;
                                  });
                                  await _muxClient.storeVideo(
                                      videoUrl: _textControllerVideoURL.text);
                                  setState(() {
                                    isProcessing = false;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                  ),
                                  child: Text(
                                    'send',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    FutureBuilder<AssetData?>(
                      future: _muxClient.getAssetList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          AssetData? assetData = snapshot.data;
                          int length = assetData!.data.length;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: length,
                            itemBuilder: (context, index) {
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          assetData.data[index].createdAt) *
                                      1000);
                              DateFormat formatter = DateFormat.yMd().add_jm();
                              String dateTimeString =
                                  formatter.format(dateTime);
                              String? currentStatus =
                                  assetData.data[index].status;
                              if (currentStatus != 'ready') {
                                return VideoTile(
                                  assetData: assetData.data[index],
                                  thumbnailUrl: '',
                                  isReady: false,
                                  dateTimeString: dateTimeString,
                                );
                              } else {
                                String playbackId =
                                    assetData.data[index].playbackIds[0].id;
                                String thubnailURL =
                                    '$muxImageBaseUrl/$playbackId/$imageTypeSize';
                                return VideoTile(
                                  assetData: assetData.data[index],
                                  thumbnailUrl: thubnailURL,
                                  isReady: true,
                                  dateTimeString: dateTimeString,
                                );
                              }
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16.0),
                          );
                        }
                        return const SizedBox(
                          child: Text(
                            'No videos present',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
