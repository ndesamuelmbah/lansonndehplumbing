import 'dart:io';

import 'package:lansonndehplumbing/core/widgets/custom_icon_button.dart';
import 'package:lansonndehplumbing/core/widgets/default_loading_shimmer.dart';
import 'package:lansonndehplumbing/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoPathOrLink;
  const CustomVideoPlayer({super.key, required this.videoPathOrLink});
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final ref = widget.videoPathOrLink;
    if (ref.startsWith('https')) {
      _controller = VideoPlayerController.network(ref);
    } else if (ref.startsWith('/assets/') || ref.startsWith('assets/')) {
      _controller = VideoPlayerController.asset(ref);
    } else {
      _controller = VideoPlayerController.file(File(ref));
    }
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _controller.value.isInitialized
              ? ListView(
                  children: <Widget>[
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              VideoPlayer(_controller),
                              ControlsOverlay(controller: _controller),
                              VideoProgressIndicator(_controller,
                                  allowScrubbing: true),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            'Viewing Video ${widget.videoPathOrLink.split(".").last}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        'Loading Video',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                    )
                  ],
                )),
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _controller.value.isInitialized
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      CustomIconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back)),
                      CustomIconButton(
                          onPressed: () async {
                            _controller.value.isPlaying
                                ? await _controller.pause()
                                : await _controller.play();
                          },
                          icon: Icon(_controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_circle)),
                    ])
              : const SizedBox.shrink()),
    );
  }
}

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}

class DisplayVideoPreview extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final Function() onPreviewPressed;
  const DisplayVideoPreview(
      {Key? key,
      required this.videoPlayerController,
      required this.onPreviewPressed})
      : super(key: key);

  Future<bool> initializeVideo() async {
    await videoPlayerController.initialize();
    return true;
  }

  Size getDims(Size screenSize) {
    var t = screenSize.width / 100;
    return Size(100, screenSize.height / t);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: initializeVideo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error Initilizing Video');
          }
          if (![ConnectionState.active, ConnectionState.done]
              .contains(snapshot.connectionState)) {
            return const DefaultLoadingSchimmer(
              showRow: false,
            );
          }
          final size = MediaQuery.of(context).size;
          return GestureDetector(
            onTap: onPreviewPressed,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: getDims(size).width,
                    height: getDims(size).height - 10,
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.pink)),
                      child: Center(
                        child: AspectRatio(
                            aspectRatio:
                                videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(videoPlayerController)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
