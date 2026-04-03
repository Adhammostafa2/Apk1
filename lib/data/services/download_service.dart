import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'api_service.dart';

class DownloadService {
  final Dio _dio = Dio();
  CancelToken? cancelToken;
  
  void pauseDownload() {
    cancelToken?.cancel("paused");
  }

  Future<String?> downloadVideo({
    required ApiService apiService,
    required String url,
    required String qualityId,
    required String title,
    required String ext,
    required Function(int, int) onProgress,
  }) async {
    cancelToken = CancelToken();
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download/ADownloader');
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      } else {
        dir = await getDownloadsDirectory();
        if (dir == null) return null;
        final customDir = Directory('${dir.path}/ADownloader');
        if (!await customDir.exists()) {
          await customDir.create(recursive: true);
        }
        dir = customDir;
      }

      final safeTitle = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final savePath = '${dir.path}/$safeTitle.$ext';

      // Start the POST request to the Node backend proxy
      await _dio.download(
        '${apiService.baseUrl}/download',
        savePath,
        data: {'url': url, 'quality': qualityId},
        options: Options(
          method: 'POST',
          receiveTimeout: const Duration(hours: 1),
        ),
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
      );

      return savePath;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return "PAUSED";
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
