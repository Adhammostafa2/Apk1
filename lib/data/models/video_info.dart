class VideoInfo {
  final String title;
  final String thumbnail;
  final int duration;
  final String uploader;
  final String webpageUrl;
  final List<VideoFormat> formats;

  VideoInfo({
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.uploader,
    required this.webpageUrl,
    required this.formats,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      title: json['title'] ?? 'Unknown Title',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? 0,
      uploader: json['uploader'] ?? 'Unknown',
      webpageUrl: json['webpage_url'] ?? '',
      formats: (json['formats'] as List? ?? [])
          .map((f) => VideoFormat.fromJson(f))
          .toList(),
    );
  }
}

class VideoFormat {
  final String formatId;
  final String ext;
  final String resolution;
  final String type; // 'video' or 'audio'
  final String url;

  VideoFormat({
    required this.formatId,
    required this.ext,
    required this.resolution,
    required this.type,
    required this.url,
  });

  factory VideoFormat.fromJson(Map<String, dynamic> json) {
    return VideoFormat(
      formatId: json['format_id']?.toString() ?? '',
      ext: json['ext'] ?? '',
      resolution: json['resolution']?.toString() ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
