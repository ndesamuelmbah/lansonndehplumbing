// import 'dart:io' show File;
// // import 'dart:ui' as ui show Image, ImageByteFormat;

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

// enum MediaTypes { image, video, imageOrVideo }

// class CameraPage extends StatefulWidget {
//   final Function(XFile pickedFiles) onPictureOrVideo;
//   final MediaTypes mediaType;
//   const CameraPage(
//       {required this.mediaType, required this.onPictureOrVideo, Key? key})
//       : super(key: key);

//   @override
//   CameraPageState createState() => CameraPageState();
// }

// class CameraPageState extends State<CameraPage> {
//   GlobalKey downloadObjectKey = GlobalKey();
//   List<XFile> pickedFiles = [];

//   late CameraController controller;
//   late CameraDescription camerToUse;
//   late int numberOfCameras = 0;
//   late List<CameraDescription> cameras;
//   bool isTakingVideo = false;
//   bool isInitialized = false;
//   double safeHeight = 1;

//   @override
//   void initState() {
//     super.initState();
//     requestCameraPermissionsAndShowCamera();
//   }

//   requestCameraPermissionsAndShowCamera() async {
//     final permissions = await Permission.camera.request();
//     if (permissions.isGranted || permissions.isLimited) {
//       cameras = await availableCameras();
//       numberOfCameras = cameras.length;
//       if (numberOfCameras > 0) {
//         for (var camera in cameras) {
//           camerToUse = camera;
//           if (camera.lensDirection == CameraLensDirection.back) {
//             break;
//           }
//         }
//         await Future.delayed(const Duration(milliseconds: 10));
//         controller = CameraController(camerToUse, ResolutionPreset.max,
//             imageFormatGroup: ImageFormatGroup.jpeg);
//         controller.initialize().then((_) {
//           if (!mounted) {
//             return;
//           }
//           isInitialized = true;
//           setState(() {});
//         });
//       }
//     } else {
//       Fluttertoast.showToast(
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Colors.pink,
//           textColor: Colors.white,
//           msg: Strings.grantPermissionsToContinue);
//     }
//   }

//   Future stopRecording() async {
//     if (isTakingVideo) {
//       isTakingVideo = false;
//       var pickedFile = await controller.stopVideoRecording();
//       pickedFiles.add(pickedFile);
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }

//   @override
//   void dispose() {
//     stopRecording().then((_) {});
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (safeHeight == 1) {
//       var dims = MediaQuery.of(context);
//       safeHeight = dims.size.height - dims.padding.top - dims.padding.bottom;
//     }
//     return Scaffold(
//       body: SafeArea(child: buildCameraBody(context, safeHeight)),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if (widget.mediaType != MediaTypes.video)
//               Material(
//                 borderRadius: BorderRadius.circular(30),
//                 child: IconButton(
//                   onPressed: () async {
//                     var pickedFile = await controller.takePicture();
//                     pickedFiles.add(pickedFile);
//                     setState(() {});
//                   },
//                   icon: const Icon(Icons.camera_alt, size: 30),
//                 ),
//               ),
//             if (widget.mediaType != MediaTypes.image)
//               Material(
//                 borderRadius: BorderRadius.circular(30),
//                 child: IconButton(
//                   onPressed: () async {
//                     if (!isTakingVideo) {
//                       isTakingVideo = true;
//                       await controller.startVideoRecording();
//                     } else {
//                       isTakingVideo = false;
//                       await stopRecording();
//                     }
//                     setState(() {});
//                   },
//                   icon: Icon(isTakingVideo ? Icons.stop : Icons.videocam,
//                       size: 30),
//                 ),
//               ),
//             if (numberOfCameras > 1)
//               Material(
//                 borderRadius: BorderRadius.circular(30),
//                 child: IconButton(
//                   onPressed: () async {
//                     if (controller.value.isRecordingVideo) {
//                       Fluttertoast.showToast(msg: 'First Stop Recording Video');
//                     } else {
//                       var newCamera =
//                           cameras.firstWhere((camera) => camera != camerToUse);
//                       controller = CameraController(
//                         newCamera,
//                         ResolutionPreset.medium,
//                       );
//                       camerToUse = newCamera;
//                     }

//                     setState(() {});
//                   },
//                   icon: const Icon(Icons.cameraswitch_outlined, size: 30),
//                 ),
//               ),
//             // IconButton(
//             //     onPressed: () async {
//             //       var l = await pickedFiles[0].length();
//             //       print(l);
//             //       // final RenderRepaintBoundary boundary =
//             //       //     downloadObjectKey.currentContext!.findRenderObject()!
//             //       //         as RenderRepaintBoundary;

//             //       // ui.Image image = await boundary.toImage(pixelRatio: 4);
//             //       // final directory = getIt<GetChatsDir>().getMediaDir();
//             //       // ByteData? byteData =
//             //       //     await image.toByteData(format: ui.ImageByteFormat.png);
//             //       // Uint8List pngBytes = byteData!.buffer.asUint8List();
//             //       // File imgFile = File(
//             //       //     '$directory${DateTime.now().toLocal().toString()}.png');
//             //       // await imgFile.writeAsBytes(pngBytes);
//             //       // await Future.delayed(const Duration(milliseconds: 100));
//             //       // XFile xFile = XFile(imgFile.path);
//             //       // pickedFiles.add(xFile);
//             //       // setState(() {});
//             //       // print('Successfully added the xfile ${xFile.path}');

//             //       // Share.shareFiles([imgFile.path],
//             //       //     text: 'Captured Image Example',
//             //       //     subject: 'View Shop Menu');
//             //     },
//             //     icon: Icon(Icons.download_outlined)),
//             Material(
//               borderRadius: BorderRadius.circular(30),
//               child: IconButton(
//                 onPressed: () async {
//                   if (controller.value.isRecordingVideo) {
//                     await stopRecording();
//                     widget.onPictureOrVideo(pickedFiles.last);
//                     if (mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   } else {
//                     if (pickedFiles.isNotEmpty) {
//                       widget.onPictureOrVideo(pickedFiles.last);
//                     }
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 icon: Icon(
//                   pickedFiles.isNotEmpty ? Icons.check : Icons.close_rounded,
//                   size: 30,
//                   color: pickedFiles.isNotEmpty ? Colors.green : Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildCameraBody(BuildContext context, double safeHeight) {
//     if (!isInitialized) {
//       return const SizedBox(
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 8.0,
//       ),
//       child: Center(
//         child: Stack(
//           children: [
//             SizedBox(
//               height: safeHeight,
//               width: 400,
//               child: pickedFiles.isNotEmpty
//                   ? Image.file(
//                       File(pickedFiles.first.path),
//                       fit: BoxFit.cover,
//                     )
//                   : CameraPreview(controller),
//             ),
//             // Align(
//             //   alignment: Alignment.topCenter,
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(16.0),
//             //     child: RepaintBoundary(
//             //       key: downloadObjectKey,
//             //       child: Container(
//             //         height: 300,
//             //         width: double.maxFinite,
//             //         decoration: BoxDecoration(
//             //             color: Colors.transparent,
//             //             borderRadius: BorderRadius.circular(20),
//             //             border: Border.all(color: Colors.grey, width: 2)),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             if (isTakingVideo)
//               const Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Text(
//                     'time goes',
//                     style: TextStyle(fontSize: 18),
//                   )),
//             Align(
//               alignment: Alignment.bottomCenter,
//               // height: 2 * (safeHeight - 16) / 3,
//               // top: (safeHeight - 16),
//               child: SizedBox(
//                 width: 400,
//                 height: 200,
//                 child: ListView.builder(
//                     itemCount: pickedFiles.length,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) {
//                       var currentFile = pickedFiles[index];
//                       var imgExts = 'jpg,jpeg,png'.split(',');
//                       if (imgExts.contains(currentFile.path.split('.').last)) {
//                         return Stack(
//                           children: [
//                             Image.file(
//                               File(currentFile.path),
//                               height: 200,
//                             ),
//                             Positioned(
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: Colors.white54,
//                                 child: InkWell(
//                                   child: const Icon(
//                                     Icons.delete_outline_sharp,
//                                     size: 30,
//                                     color: Colors.red,
//                                   ),
//                                   onTap: () {
//                                     pickedFiles.removeAt(index);
//                                     setState(() {});
//                                   },
//                                 ),
//                               ),
//                             )
//                           ],
//                         );
//                       } else {
//                         return const Text('Video File');
//                       }
//                     }),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
