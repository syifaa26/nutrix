import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_permission_dialog.dart';
import 'dart:io';
import '../services/food_detection_service.dart';
import '../data/food_nutrition_database.dart';

class CameraDetectionModal extends StatefulWidget {
  const CameraDetectionModal({super.key});

  @override
  State<CameraDetectionModal> createState() => _CameraDetectionModalState();
}

class _CameraDetectionModalState extends State<CameraDetectionModal> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isPermissionGranted = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Check and request camera permission with custom dialog
      final hasPermission = await CameraPermissionDialog.requestPermission(context);
      if (!hasPermission) {
        setState(() {
          _errorMessage = 'Izin kamera diperlukan untuk menggunakan fitur deteksi makanan.';
          _isPermissionGranted = false;
        });
        return;
      }

      setState(() {
        _isPermissionGranted = true;
      });

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _errorMessage = 'Tidak ada kamera yang tersedia pada perangkat ini.';
        });
        return;
      }

      // Initialize the camera controller
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } on CameraException catch (e) {
      setState(() {
        if (e.code == 'CameraAccessDenied') {
          _errorMessage = 'Akses kamera ditolak. Mohon izinkan akses kamera di pengaturan aplikasi.';
        } else {
          _errorMessage = 'Error kamera: ${e.description ?? e.code}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menginisialisasi kamera. Pastikan aplikasi memiliki izin kamera.';
      });
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final XFile image = await _controller!.takePicture();
      await _processImage(image, 'kamera');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processImage(image, 'galeri');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processImage(XFile image, String source) async {
    debugPrint('Image from $source: ${image.path}');

    // Close modal quickly and show a SnackBar while detecting
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Foto dari $source berhasil dipilih! Mendeteksi makanan...'),
          backgroundColor: const Color(0xFF2ECC71),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    try {
      // Run the AI detection service
      final result = await FoodDetectionService.detectFood(File(image.path));
      debugPrint('Detection result: $result');

      if (result['success'] == true) {
        final top = result['topPrediction'];
        String detectedName = top['name'] as String;

        // Normalize name to DB key format (lowercase, underscores)
        String key = detectedName
            .toLowerCase()
            .replaceAll(RegExp(r"[^a-z0-9 ]"), '')
            .trim()
            .replaceAll(RegExp(r"\s+"), '_');

        final nutrition = FoodNutritionDatabase.getNutrition(key);

        // Show result dialog with nutrition info if available
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hasil Deteksi: ${detectedName}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Confidence: ${top['confidence']}%'),
                  const SizedBox(height: 8),
                  if (nutrition != null) ...[
                    Text('Kalori (per 100g): ${nutrition.calories} kkal'),
                    Text('Porsi: ${nutrition.servingSize}'),
                    Text('Protein: ${nutrition.protein} g'),
                    Text('Karbohidrat: ${nutrition.carbs} g'),
                    Text('Lemak: ${nutrition.fat} g'),
                  ] else ...[
                    const Text('Informasi nutrisi tidak tersedia untuk makanan ini.'),
                    const SizedBox(height: 6),
                    const Text('(Coba gunakan nama makanan yang lebih umum atau update database)')
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        }
      } else {
        // Show failure
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deteksi gagal: ${result['error'] ?? 'Unknown'}'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      debugPrint('Error running detection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi error saat mendeteksi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Note: image source selection UI is integrated directly into the modal controls.

  // Source option builder removed; controls are implemented directly in the modal.

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF2ECC71),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deteksi Makanan dengan AI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ambil foto dengan kamera atau pilih dari galeri untuk mendeteksi kalori dan nutrisi secara otomatis',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            ),
            
            // Camera Preview or Error Message
            Expanded(
              child: _buildCameraContent(),
            ),
            
            // Bottom Controls
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  if (_isInitialized && _isPermissionGranted) ...[
                    // Camera Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Camera Button
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2ECC71),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library, size: 18),
                          label: const Text('Galeri'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ECC71),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Permission or initialization error
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Retry camera initialization
                            setState(() {
                              _errorMessage = null;
                              _isInitialized = false;
                              _isPermissionGranted = false;
                            });
                            await _initializeCamera();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2ECC71),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraContent() {
    if (_errorMessage != null) {
      return Container(
        color: Colors.grey[900],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF2ECC71),
              ),
              SizedBox(height: 20),
              Text(
                'Mempersiapkan kamera...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRect(
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: CameraPreview(_controller!),
      ),
    );
  }
}