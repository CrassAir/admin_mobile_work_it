import 'dart:io';

import 'package:admin_mobile_work_it/controllers/user_ctrl.dart';
import 'package:admin_mobile_work_it/screens/face_detector_painter.dart';
import 'package:admin_mobile_work_it/service/camera_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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
  CustomPaint? customPaint;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      customPaint: customPaint,
      onImage: (inputImage, cont) {
        processImage(inputImage, cont);
      },
      onResume: findPic,
      initialDirection: CameraLensDirection.back,
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
        // Rect.fromLTRB(154.0, 349.0, 570.0, 773.0)
        if (faces[0].boundingBox.right - faces[0].boundingBox.left >= 420 && faces[0].boundingBox.top <= 300.0) {
          try {
            findPic = true;
            await controller.stopImageStream();
            var imgFile = await controller.takePicture();
            setState(() {});
            await Get.to(() => SetPhoto(xfile: imgFile))?.then((value) => setState(() => findPic = false));
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

class SetPhoto extends StatelessWidget {
  final XFile xfile;
  final UserCtrl userCtrl = Get.find();

  SetPhoto({Key? key, required this.xfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Фото')),
        body: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
          // Transform(
          //   alignment: Alignment.center,
          //   transform: Matrix4.rotationY(math.pi),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: Image.file(File(xfile.path)).image, scale: 1),
            ),
          ),
          // ),
          Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {
                    userCtrl.tryUploadAvatar(userCtrl.user!.username!, xfile.path);
                    Navigator.pop(context);
                  }, child: const Text('Принять')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () => Get.back(),
                      child: const Text('Отменить')),
                ],
              )),
        ]));
  }
}
