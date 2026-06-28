import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file_saver.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCameraSupported = true;
  String _cameraStatusMessage = 'Initializing camera...';

  // Animation for the scanning laser line
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;

  // Gemini API & Scan State
  bool _isScanning = false;
  bool _isSavingPhoto = false;
  String? _apiKey;
  final TextEditingController _apiKeyFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _initializeCamera();

    // Set up scanning line animation
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanLineController.dispose();
    _apiKeyFieldController.dispose();
    super.dispose();
  }

  // Load saved Gemini API Key
  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = prefs.getString('GEMINI_API_KEY');
      if (_apiKey != null) {
        _apiKeyFieldController.text = _apiKey!;
      }
    });
  }

  // Save Gemini API Key
  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('GEMINI_API_KEY', key);
    setState(() {
      _apiKey = key.isEmpty ? null : key;
    });
  }

  // Initialize camera system
  Future<void> _initializeCamera() async {
    if (kIsWeb) {
      // Camera web can sometimes take a while or fail if permissions are not set
      // We wrap carefully
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isCameraSupported = false;
          _cameraStatusMessage = 'No cameras found on this device.';
        });
        return;
      }

      // Select back camera or first available
      CameraDescription selectedCamera = _cameras.first;
      for (var camera in _cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          selectedCamera = camera;
          break;
        }
      }

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraSupported = false;
          _cameraStatusMessage = 'Camera access not available: $e';
        });
      }
    }
  }

  // Trigger capture and food scanning
  Future<void> _scanFood() async {
    if (_isScanning || _isSavingPhoto) return;

    setState(() {
      _isScanning = true;
    });

    try {
      Uint8List imageBytes;
      String fileName = 'food_scan_${DateTime.now().millisecondsSinceEpoch}.png';

      if (_isCameraInitialized && _cameraController != null) {
        final XFile file = await _cameraController!.takePicture();
        imageBytes = await file.readAsBytes();
      } else {
        // Fallback for simulation mode / no camera
        // Load a mock image (a simple green/orange block to represent captured food)
        // or a simulated byte array
        await Future.delayed(const Duration(seconds: 1));
        imageBytes = Uint8List.fromList(List.generate(100, (index) => index));
      }

      // Save the captured image using FileSaver
      final saver = FileSaver();
      final savedPath = await saver.saveImage(imageBytes, fileName);

      debugPrint("===== IMAGE SAVED (_scanFood) =====");
      debugPrint(savedPath);

      // Perform Gemini analysis or simulate
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        await _runGeminiAnalysis(imageBytes, savedPath);
      } else {
        await _runSimulationAnalysis(savedPath);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to scan food: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  // Capture photo and save directly to the project's picture folder
  Future<void> _captureAndSavePhoto() async {
    if (_isScanning || _isSavingPhoto) return;

    setState(() {
      _isSavingPhoto = true;
    });

    try {
      Uint8List imageBytes;
      String fileName = 'food_picture_${DateTime.now().millisecondsSinceEpoch}.png';

      if (_isCameraInitialized && _cameraController != null) {
        final XFile file = await _cameraController!.takePicture();
        imageBytes = await file.readAsBytes();
      } else {
        // Fallback for simulation mode / no camera
        await Future.delayed(const Duration(seconds: 1));
        imageBytes = Uint8List.fromList(List.generate(100, (index) => index));
      }

      // Save the captured image using FileSaver
      final saver = FileSaver();
      final savedPath = await saver.saveImage(imageBytes, fileName);

      debugPrint("===== IMAGE SAVED (_captureAndSavePhoto) =====");
      debugPrint(savedPath);
      
      _showSuccessSnackBar('Photo saved to: $savedPath');
    } catch (e) {
      _showErrorSnackBar('Failed to save photo: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSavingPhoto = false;
        });
      }
    }
  }

  // Real Gemini Analysis
  // Real Gemini Analysis - FIXED VERSION
  Future<void> _runGeminiAnalysis(Uint8List imageBytes, String savedPath) async {
    try {
      // 1. Definisikan Schema agar Gemini mengembalikan tipe data yang konsisten
      final dietSchema = Schema.object(
        properties: {
          'foodName': Schema.string(description: 'Name of the food identified.'),
          'calories': Schema.integer(description: 'Total calories as a pure number.'),
          'protein': Schema.string(description: 'Protein content, e.g., "10g".'),
          'carbs': Schema.string(description: 'Carbohydrates content, e.g., "30g".'),
          'fat': Schema.string(description: 'Fat content, e.g., "8g".'),
          'description': Schema.string(description: 'Short dynamic description of the food and its health values.'),
        },
        requiredProperties: ['foodName', 'calories', 'protein', 'carbs', 'fat', 'description'],
      );

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey!,
        // 2. Paksa model untuk mengembalikan format JSON paten sesuai schema
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: dietSchema,
        ),
      );

      // Prompt disederhanakan karena strukturnya sudah diatur oleh schema di atas
      final prompt = 'Identify the food in this image and provide its estimated nutritional facts accurately.';

      final response = await model.generateContent([
        Content.multi([
          DataPart('image/png', imageBytes),
          TextPart(prompt),
        ])
      ]);

      final jsonText = response.text?.trim() ?? '';
      debugPrint("===== GEMINI RAW RESPONSE =====");
      debugPrint(jsonText); // Untuk memantau hasil di debug console

      if (jsonText.isEmpty) throw Exception('Gemini returned an empty response.');

      // 3. Langsung decode tanpa perlu pakai Regex cleaner lagi
      final parsed = jsonDecode(jsonText);
      
      _showResultBottomSheet(
        foodName: parsed['foodName'] ?? 'Unknown Food',
        calories: parsed['calories']?.toString() ?? '0', // Aman dari Int ke String
        protein: parsed['protein'] ?? '0g',
        carbs: parsed['carbs'] ?? '0g',
        fat: parsed['fat'] ?? '0g',
        description: parsed['description'] ?? 'No description available.',
        savedPath: savedPath,
        isSimulated: false,
      );
    } catch (e) {
      debugPrint("===== GEMINI PARSING ERROR =====");
      debugPrint(e.toString());
      // Jika gagal, fallback ke simulation dan tampilkan detail error aslinya
      await _runSimulationAnalysis(savedPath, errorMessage: e.toString());
    }
  }

  // Simulated fallback analysis
  Future<void> _runSimulationAnalysis(String savedPath, {String? errorMessage}) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _showResultBottomSheet(
      foodName: 'Avocado Egg Toast',
      calories: '320',
      protein: '12g',
      carbs: '28g',
      fat: '18g',
      description: 'A nutritious breakfast offering complex carbohydrates from whole wheat toast, '
          'healthy monounsaturated fats from avocado, and complete proteins from the poached egg.',
      savedPath: savedPath,
      isSimulated: true,
      errorMessage: errorMessage,
    );
  }

  // Display result modal
  void _showResultBottomSheet({
    required String foodName,
    required String calories,
    required String protein,
    required String carbs,
    required String fat,
    required String description,
    required String savedPath,
    required bool isSimulated,
    String? errorMessage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              
              if (isSimulated) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 18),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          errorMessage != null
                              ? 'Gemini API failed: Using Simulation Mode.'
                              : 'Simulation Mode: Configure Gemini API Key in Settings to scan real food.',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      foodName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B1C30),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF006E2F).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      '$calories kcal',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006E2F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20.0),

              const Text(
                'Macronutrients',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C30),
                ),
              ),
              const SizedBox(height: 12.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacroCard('Carbs', carbs, const Color(0xFF006591)),
                  _buildMacroCard('Protein', protein, const Color(0xFF006E2F)),
                  _buildMacroCard('Fat', fat, const Color(0xFF9D4300)),
                ],
              ),
              const SizedBox(height: 24.0),

              // File Saved Location Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.save_outlined, color: Colors.grey.shade700, size: 18),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Saved to: $savedPath',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey.shade700,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text('Scan Again'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Redirect to the healthy modifier recipes view
                        Navigator.pushNamed(context, '/homemade-food');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006E2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text('View Healthy Swap'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show settings popup to configure Gemini API Key
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF006E2F)),
              SizedBox(width: 8),
              Text('Gemini Configuration'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your Gemini API Key to enable real-time food scanning and identification.',
                style: TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _apiKeyFieldController,
                decoration: const InputDecoration(
                  labelText: 'Gemini API Key',
                  border: OutlineInputBorder(),
                  hintText: 'AIzaSy...',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveApiKey(_apiKeyFieldController.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  _showSuccessSnackBar('API Key configuration updated!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006E2F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF006E2F),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera preview or Mock background
          Positioned.fill(
            child: _isCameraSupported && _isCameraInitialized && _cameraController != null
                ? AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  )
                : _buildMockCameraFeed(),
          ),

          // 2. Translucent dark overlay with viewport scanner frame
          Positioned.fill(
            child: _buildScannerOverlay(size),
          ),

          // 3. Header bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF004B1E),
                      ),
                      child: const Icon(Icons.restaurant, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12.0),
                    const Text(
                      'NutriScan AI',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white, size: 26.0),
                      onPressed: _showSettingsDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Instructions text
          Positioned(
            bottom: 200.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  'Bidik makananmu untuk mulai scan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),

          // Shutter Button for Saving Food Photo
          // CARI BAGIAN INI DI DALAM STACK:
Positioned(
  bottom: 90.0,
  left: 0,
  right: 0,
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          // 1. UBAH DARI _captureAndSavePhoto MENJADI _scanFood
          onTap: _scanFood, 
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white, width: 4.0),
            ),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00C853),
              ),
              // 2. SESUAIKAN KONDISI LOADING INDICATOR-NYA
              child: _isScanning // <--- Ubah dari _isSavingPhoto ke _isScanning
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3.0,
                      ),
                    )
                  : const Icon(
                      Icons.center_focus_strong, // <--- Opsional: Ganti ikon biar lebih cocok buat scan
                      color: Colors.white,
                      size: 30.0,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Scan Food with AI', // <--- Ganti teks label bawah tombol
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            shadows: const [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

          // 5. Active scanner loading animation overlay
          if (_isScanning)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Analyzing Food with AI...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Custom mock camera feed for devices/web with no camera permission/hardware
  Widget _buildMockCameraFeed() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // A beautiful mock background photo representing what the camera "sees"
          Opacity(
            opacity: 0.25,
            child: GridPaper(
              color: Colors.green.withValues(alpha: 0.1),
              divisions: 2,
              interval: 40.0,
              subdivisions: 1,
              child: const SizedBox(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_enhance_outlined,
                  size: 64,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 16.0),
                Text(
                  _cameraStatusMessage,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  '(Click camera scan button below to simulate capture)',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Scanner grid and border overlay with laser animation
  Widget _buildScannerOverlay(Size screenSize) {
    // Viewport target dimensions
    final width = screenSize.width * 0.75;
    final height = screenSize.width * 0.75;

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF00C853), // Green scanner frame color
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0),
          child: Stack(
            children: [
              // Animated green scanning line
              AnimatedBuilder(
                animation: _scanLineAnimation,
                builder: (context, child) {
                  final position = _scanLineAnimation.value * height;
                  return Positioned(
                    top: position,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF00C853),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              // Corner tick marks to look like a premium scope
              _buildCornerTick(Alignment.topLeft),
              _buildCornerTick(Alignment.topRight),
              _buildCornerTick(Alignment.bottomLeft),
              _buildCornerTick(Alignment.bottomRight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerTick(Alignment alignment) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              top: (alignment == Alignment.topLeft || alignment == Alignment.topRight)
                  ? const BorderSide(color: Color(0xFF00C853), width: 4.0)
                  : BorderSide.none,
              bottom: (alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight)
                  ? const BorderSide(color: Color(0xFF00C853), width: 4.0)
                  : BorderSide.none,
              left: (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft)
                  ? const BorderSide(color: Color(0xFF00C853), width: 4.0)
                  : BorderSide.none,
              right: (alignment == Alignment.topRight || alignment == Alignment.bottomRight)
                  ? const BorderSide(color: Color(0xFF00C853), width: 4.0)
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  // Matches the bottom navigation bar from the user mockup
  Widget _buildBottomNavBar() {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Camera active pill tab
          GestureDetector(
            onTap: _scanFood,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF00C853), // Active green background pill
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_camera, color: Colors.white, size: 20.0),
                  SizedBox(width: 8.0),
                  Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Stats inactive tab
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/nutrition-detail');
            },
            borderRadius: BorderRadius.circular(20.0),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.analytics_outlined, color: Colors.grey, size: 24.0),
                  SizedBox(height: 4.0),
                  Text(
                    'Stats',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. AI Hub inactive tab
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            borderRadius: BorderRadius.circular(20.0),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.smart_toy_outlined, color: Colors.grey, size: 24.0),
                  SizedBox(height: 4.0),
                  Text(
                    'AI Hub',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                    ),
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
