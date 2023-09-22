import 'dart:io' show File;

void deleteFiles(List<File?> files) async {
  await Future.delayed(const Duration(seconds: 1));
  await Future.forEach(files, (File? file) async {
    if (file != null) {
      await file.delete();
    }
  });
}
