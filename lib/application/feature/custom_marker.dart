import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class CustomMarker {
  String imagePath;
  String fileName;
  CustomMarker(this.imagePath, this.fileName);

  Future<ui.Image> loadBgImage(String path) async {
    final data = await rootBundle.load(path);
    final list = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(list);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<String> customMarker(String tagColor) async {
    final bgImage = await loadBgImage('assets/images/bg_$tagColor.png');
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(200, 230)));

// 背景画像の描画
    final bgPaint = Paint();
    canvas.drawImage(bgImage, Offset(0, 0), bgPaint);

// フロント画像をロードします。
    final frontImageBytes = await File(imagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(frontImageBytes);
    final frameInfo = await codec.getNextFrame();
    final frontImage = frameInfo.image;

// リサイズした画像の描画

    // 画像をリサイズ
    canvas.drawImageRect(
      frontImage,
      Rect.fromPoints(Offset(0, 0),
          Offset(frontImage.width.toDouble(), frontImage.height.toDouble())),
      Rect.fromPoints(Offset(10, 10), Offset(190, 190)),
      Paint(),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(200, 230);

    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData?.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/CustomMarker_$fileName.png');
    debugPrint(file.path);
    await file.writeAsBytes(buffer!);
    return file.path;
  }
}
