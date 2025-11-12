import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class FoodDetectionService {
  static bool _isInitialized = false;
  static GenerativeModel? _model;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY tidak diset. Jalankan flutter dengan --dart-define=GEMINI_API_KEY=YOUR_KEY');
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
  generationConfig: GenerationConfig(temperature: 0.2),
    );
    _isInitialized = true;
  }

  // Detect food from image using Gemini Vision
  static Future<Map<String, dynamic>> detectFood(File imageFile) async {
    if (!_isInitialized) await initialize();
    try {
      final bytes = await imageFile.readAsBytes();
      final imagePart = DataPart('image/jpeg', bytes);
      final instructions = TextPart(
        'Identify the primary food item in this image. '
        'Reply with ONLY compact JSON (no markdown) with keys: '
        '{"name": string, "alternatives": [string,string,string], "confidence": number (0..1), "portion_estimate_grams": number}. '
        'Use lowercase underscored name if possible. If unsure, pick the closest common food name and lower confidence.'
      );

      final response = await _model!.generateContent([
        Content.multi([instructions, imagePart])
      ]);
      final text = response.text?.trim() ?? '';

      // Extract JSON even if wrapped in code fences
      String jsonStr = text;
      if (jsonStr.startsWith('```')) {
        final start = jsonStr.indexOf('{');
        final end = jsonStr.lastIndexOf('}');
        if (start != -1 && end != -1 && end > start) {
          jsonStr = jsonStr.substring(start, end + 1);
        }
      }

      final decoded = json.decode(jsonStr) as Map<String, dynamic>;
      final name = (decoded['name'] ?? 'unknown').toString();
      final confidenceVal = (decoded['confidence'] is num) ? (decoded['confidence'] as num).toDouble() : 0.0;

      return {
        'success': true,
        'topPrediction': {
          'name': name,
          'confidence': (confidenceVal * 100).toStringAsFixed(1),
          'confidenceValue': confidenceVal,
        },
        'allPredictions': ((decoded['alternatives'] as List?) ?? const [])
            .take(5)
            .map((e) => {
                  'name': e.toString(),
                  'confidence': '',
                  'confidenceValue': 0.0,
                })
            .toList(),
      };
    } on SocketException catch (e) {
      debugPrint('❌ No internet: $e');
      return {
        'success': false,
        'error': 'Tidak ada koneksi internet. Mohon periksa jaringan Anda dan coba lagi.',
      };
    } catch (e) {
      debugPrint('❌ Gemini detection error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
