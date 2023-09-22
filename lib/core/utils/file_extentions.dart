import 'package:flutter/material.dart' show Icon, Colors;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const audioExtensions = [
  'mp3',
  'ogg',
  'm4a',
  'wav',
  'aac',
  'aac',
  'opus',
  'weba',
  'aif',
  'aifc',
  'aiff',
];
const documentsExtensions = [
  'txt',
  'pdf',
  'xlsx',
  'xls',
  'xlsl',
  'doc',
  'docx',
  'ppt',
  'tsv',
  'csv',
  'html',
  'html5',
  'yaml',
  'json'
];
const imagesExtensions = ['png', 'jpg', 'jpeg', 'gif', 'tif', 'tiff'];
const videoExtensions = [
  'mp4',
  'mov',
  'wmv',
  'webm',
  'avi',
  'flv',
  'mkv',
  'mts',
  'mpeg',
  'html5',
  'mpeg-1',
  'mpeg-2',
  'mpeg-4',
  'html5'
];
List<String> getAllExtensions() {
  List<String> exts = [];
  for (var s in [
    audioExtensions,
    documentsExtensions,
    imagesExtensions,
    videoExtensions
  ]) {
    exts.addAll(s);
  }
  return exts;
}

enum MediaSourceTypes {
  cameraImage,
  cameraVideo,
  galleryAudio,
  galleryPhoto,
  galleryVideo,
  galleryOther,
  galleryDocument
}

String? normalizeFilePath(String? path) => path?.replaceAll('file://', '');

Icon getIconForExtention(String ext) {
  if (audioExtensions.contains(ext)) {
    return const Icon(FontAwesomeIcons.fileAudio);
  }
  if (documentsExtensions.contains(ext)) {
    var icon = 'doc docx'.contains(ext)
        ? FontAwesomeIcons.fileWord
        : ext == 'pdf'
            ? FontAwesomeIcons.filePdf
            : 'xls xlsx csv'.contains(ext)
                ? FontAwesomeIcons.fileExcel
                : FontAwesomeIcons.fileLines;
    return Icon(
      icon,
      color: Colors.red,
    );
  }
  if (videoExtensions.contains(ext)) {
    return const Icon(FontAwesomeIcons.circlePlay);
  }
  if (imagesExtensions.contains(ext)) {
    return const Icon(FontAwesomeIcons.image);
  }
  return const Icon(FontAwesomeIcons.file);
}
