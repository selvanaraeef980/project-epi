import 'dart:io';
import 'package:eipscan_app/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraWithRtmp extends StatefulWidget {
  @override
  _CameraWithRtmpState createState() => _CameraWithRtmpState();
}

class _CameraWithRtmpState extends State<CameraWithRtmp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isCapturing = false;
  XFile? capturedImage;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      throw CameraException('Camera permission not granted', 'permission');
    }

    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> saveImageToTemporaryDirectory(File imageFile) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now()}.jpg';
    await imageFile.copy(filePath);
    return filePath;
  }

void _takePicture() async {
  if (isCapturing) {
    print('Previous capture has not returned yet.');
    return;
  }

  isCapturing = true;

  try {
    final XFile image = await _controller.takePicture();
    capturedImage = image;
    _selectedImagePath = await saveImageToTemporaryDirectory(File(image.path));
    await _controller.setFlashMode(FlashMode.off);
    print('Picture saved to $_selectedImagePath');

    final File newImage = await File(image.path).copy('$Firstpage()/${DateTime.now()}.jpg');

    setState(() {
      _selectedImagePath = newImage.path;
    });
  } catch (e) {
    print('Error taking picture: $e');
  } finally {
    isCapturing = false;
    setState(() {});
  }
}


  void _resetCapture() {
    setState(() {
      capturedImage = null;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        capturedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return (_controller != null && _controller.value.isInitialized)
                    ? CameraPreview(_controller)
                    : Center(child: Text('Camera initialization failed'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (capturedImage != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DisplayCapturedImage(imagePath: _selectedImagePath!),
                    ),
                  );
                },
                child: Image.file(
                  File(capturedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: capturedImage != null ? _resetCapture : null,
                    child: Icon(Icons.camera_alt),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: FloatingActionButton(
                      onPressed: null,
                      child: Icon(Icons.photo_library),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _takePicture,
                    child: Icon(Icons.camera),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayCapturedImage extends StatelessWidget {
  final String imagePath;

  const DisplayCapturedImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مرحلة التشخيص'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'صورة ملتقطة',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.file(
              File(imagePath),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CameraWithRtmp(),
  ));
}
