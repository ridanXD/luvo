import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'preview_page.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      debugPrint('Error mengambil foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCDCDC), // Primary
      appBar: AppBar(
        title: const Text(
          'Dokumentasi Cucian',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans', // Plus Jakarta Sans untuk Heading
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0147AD), // Secondary
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(child: ClipRRect(child: CameraPreview(_controller))),
                Container(
                  height: 120,
                  width: double.infinity,
                  color: const Color(0xFFDCDCDC), // Primary
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFF0147AD), // Secondary
                      onPressed: _takePicture,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0147AD)),
            );
          }
        },
      ),
    );
  }
}
