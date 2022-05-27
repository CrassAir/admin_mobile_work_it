import 'dart:io';

import 'package:admin_mobile_work_it/screens/face_detector_painter.dart';
import 'package:admin_mobile_work_it/service/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:math' as math;

class SetUserPhoto extends StatefulWidget {
  @override
  _SetUserPhoto createState() => _SetUserPhoto();
}

class _SetUserPhoto extends State<SetUserPhoto> {
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(const FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;
  bool findPic = false;
  XFile img = XFile('');
  CustomPaint? customPaint;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (img.path != '') {
      return Scaffold(
        appBar: AppBar(),
        body: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: Image.file(File(img.path)).image, scale: 1),
            ),
          ),
        ),
      );
    }
    return CameraView(
      customPaint: customPaint,
      onImage: (inputImage, cont) {
        processImage(inputImage, cont);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(InputImage inputImage, CameraController controller) async {
    if (isBusy || findPic) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final painter =
          FaceDetectorPainter(faces, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
      if (faces.isNotEmpty) {
        print(faces[0].boundingBox);
        if (faces[0].boundingBox.left <= 40.0 &&
            faces[0].boundingBox.top <= 260.0 &&
            faces[0].boundingBox.right >= 650.0) {
          try {
            findPic = true;
            await controller.stopImageStream();
            var imgFile = await controller.takePicture();
            img = imgFile;
            setState(() {});
          } catch (e) {
            print(e);
          }
        }
      }
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
