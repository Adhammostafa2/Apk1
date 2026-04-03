import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/video_info.dart';
import '../data/services/api_service.dart';
import '../data/services/download_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());
final downloadServiceProvider = Provider((ref) => DownloadService());

class DownloadState {
  final bool isAnalyzing;
  final VideoInfo? videoInfo;
  final String error;
  
  final bool isDownloading;
  final bool isPaused;
  final double progress;
  final String downloadStatus; // idle, downloading, paused, completed, failed

  DownloadState({
    this.isAnalyzing = false,
    this.videoInfo,
    this.error = '',
    this.isDownloading = false,
    this.isPaused = false,
    this.progress = 0.0,
    this.downloadStatus = 'idle',
  });

  DownloadState copyWith({
    bool? isAnalyzing,
    VideoInfo? videoInfo,
    String? error,
    bool? isDownloading,
    bool? isPaused,
    double? progress,
    String? downloadStatus,
  }) {
    return DownloadState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      videoInfo: videoInfo ?? this.videoInfo,
      error: error ?? this.error,
      isDownloading: isDownloading ?? this.isDownloading,
      isPaused: isPaused ?? this.isPaused,
      progress: progress ?? this.progress,
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );
  }
}

class DownloadNotifier extends Notifier<DownloadState> {
  @override
  DownloadState build() {
    return DownloadState();
  }

  void reset() {
    state = DownloadState();
  }

  Future<void> analyzeUrl(String url) async {
    state = state.copyWith(isAnalyzing: true, error: '', videoInfo: null, downloadStatus: 'idle');
    try {
      final info = await ref.read(apiServiceProvider).analyzeVideo(url);
      state = state.copyWith(isAnalyzing: false, videoInfo: info);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: "Network Error: Ensure the Node ADownloader Backend is running on port 3000.");
    }
  }
  
  void pauseDownload() {
    ref.read(downloadServiceProvider).pauseDownload();
    state = state.copyWith(isDownloading: false, isPaused: true, downloadStatus: 'paused');
  }

  Future<void> startDownload(VideoFormat format) async {
    if (state.videoInfo == null) return;
    
    state = state.copyWith(
      isDownloading: true,
      isPaused: false,
      progress: state.downloadStatus == 'paused' ? state.progress : 0.0,
      downloadStatus: 'downloading',
      error: ''
    );

    final savePath = await ref.read(downloadServiceProvider).downloadVideo(
      apiService: ref.read(apiServiceProvider),
      url: state.videoInfo!.webpageUrl.isNotEmpty ? state.videoInfo!.webpageUrl : format.url,
      qualityId: format.formatId,
      title: state.videoInfo!.title,
      ext: format.ext.isNotEmpty ? format.ext : 'mp4',
      onProgress: (received, total) {
        if (total != -1) {
          final progress = received / total;
          state = state.copyWith(progress: progress);
        }
      },
    );

    if (savePath == "PAUSED") {
        state = state.copyWith(downloadStatus: 'paused');
    } else if (savePath != null) {
      state = state.copyWith(
        isDownloading: false,
        downloadStatus: 'completed',
        progress: 1.0,
      );
    } else {
      state = state.copyWith(
        isDownloading: false,
        downloadStatus: 'failed',
        error: 'Failed to complete the download. Check network connection.',
      );
    }
  }
}

final downloadProvider = NotifierProvider<DownloadNotifier, DownloadState>(() {
  return DownloadNotifier();
});
