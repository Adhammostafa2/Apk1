import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/video_info.dart';

class ApiService {
  final Dio _dio = Dio();
  
  // Dynamic host based on platform for local testing
  // CHANGE THIS TO YOUR COMPUTER'S IPv4 ADDRESS (e.g. 192.168.1.5) to test on a real phone!
  final String actualDeviceIP = '192.168.1.X';
  
  String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // 10.0.2.2 is only for Emulators. For a physical phone, it MUST be the actualDeviceIP!
      return 'http://$actualDeviceIP:3000'; 
    }
    return 'http://127.0.0.1:3000'; // Windows/Web/iOS emulator
  }

  Future<VideoInfo> analyzeVideo(String url) async {
    try {
      final response = await _dio.post(
        '$baseUrl/analyze',
        data: {'url': url},
        options: Options(
           headers: {
             "Content-Type": "application/json",
             "Accept": "application/json"
           },
           sendTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 30),
        )
      );
      
      print('API Response: ${response.data}');

      if (response.statusCode == 200) {
        return VideoInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze video: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message} - ${e.response?.data}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('General Error: $e');
      throw Exception('Network error: $e');
    }
  }
}
