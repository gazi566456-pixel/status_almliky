import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statusgetter/services/ads_service.dart';
import 'package:statusgetter/views/widgets/banner_ad_widget.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoStatusSaverView extends StatefulWidget {
  final String path;
  const VideoStatusSaverView({super.key, required this.path});

  @override
  State<VideoStatusSaverView> createState() => _VideoStatusSaverViewState();
}

class _VideoStatusSaverViewState extends State<VideoStatusSaverView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.path));
    
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      "Video Init Error: $e".print();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  final List<Widget> floatingButtons = const <Widget>[
    Icon(Icons.download),
    Icon(Icons.share),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      canPop: true, // 🔥 السماح بالرجوع
      onWillPop: () async {
        return true; // 🔥 السماح بالرجوع عند الضغط على زر الخلف
      },
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: AdBannerWidget(),
      ),
      uiOverlay: AppThemes().normalGB(context).copyWith(
            statusBarColor: AppColors.noColor,
          ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List<Widget>.generate(
          floatingButtons.length,
          (int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                heroTag: "video_fab_$index",
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onPressed: () async {
                  switch (index) {
                    case 0:
                      "download video".print();
                      ImageGallerySaver.saveFile(widget.path).then<void>((_) {
                        AdsService().showInterstitialAd();
                        "Status Saved".showSnackbar(context);
                      });
                      break;
                    case 1:
                      "Share".print();
                      Share.shareXFiles([XFile(widget.path)]);
                      break;
                  }
                },
                child: floatingButtons.elementAt(index),
              ),
            );
          },
        ),
      ),
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.black,
            child: _isInitialized && _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
