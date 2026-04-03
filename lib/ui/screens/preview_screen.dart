import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/download_provider.dart';
import '../../data/models/video_info.dart';
import '../../core/theme.dart';
import '../widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadProvider);
    final info = state.videoInfo;

    if (info == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No Info')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (info.thumbnail.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                      child: Image.network(
                        info.thumbnail, 
                        height: 220, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const SizedBox(height: 220, child: Center(child: Icon(Icons.broken_image, size: 64))),
                      ),
                    )
                  else
                    const SizedBox(height: 220, child: Center(child: Icon(Icons.movie, size: 64))),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      info.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
            const SizedBox(height: 32),
            const Text(
              'Available Formats',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),
            if (info.formats.isEmpty)
               const Text('No direct formats available for this video.'),
            ...info.formats.map((format) {
               return Card(
                 margin: const EdgeInsets.only(bottom: 16),
                 elevation: 4,
                 shadowColor: Colors.black12,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                 child: ListTile(
                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                   leading: CircleAvatar(
                     radius: 24,
                     backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                     child: Icon(
                       format.type == 'audio' ? Icons.audiotrack : Icons.video_file,
                       color: AppTheme.primaryColor,
                       size: 28,
                     ),
                   ),
                   title: Text('${format.type.toUpperCase()} - ${format.resolution}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                   subtitle: Text('Format: ${format.ext.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.w500)),
                   trailing: Container(
                     decoration: BoxDecoration(
                       gradient: AppTheme.primaryGradient,
                       borderRadius: BorderRadius.circular(16),
                       boxShadow: [
                         BoxShadow(color: AppTheme.primaryColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                       ]
                     ),
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.transparent,
                         shadowColor: Colors.transparent,
                         foregroundColor: Colors.white,
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       ),
                       onPressed: () {
                          ref.read(downloadProvider.notifier).startDownload(format);
                          _showDownloadSheet(context, ref, format);
                       },
                       child: const Text('DL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     ),
                   ),
                 ),
               ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1);
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showDownloadSheet(BuildContext context, WidgetRef ref, VideoFormat format) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _DownloadSheet();
      },
    );
  }
}

class _DownloadSheet extends ConsumerWidget {
  const _DownloadSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadProvider);
    final isDone = state.downloadStatus == 'completed';
    final isFailed = state.downloadStatus == 'failed';
    
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5))]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Downloading', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              if (!isDone && !isFailed)
                IconButton(
                  icon: Icon(state.isPaused ? Icons.play_circle_fill : Icons.pause_circle_filled, size: 36, color: AppTheme.primaryColor),
                  onPressed: () {
                    if (state.isPaused) {
                      // Attempt to resume (re-trigger down)
                      // In a real advanced setup, you pass the format back in, but for proxy we restart
                      ref.read(downloadProvider.notifier).startDownload(VideoFormat(formatId: 'best', ext: 'mp4', resolution: 'resume', type: 'video', url: ''));
                    } else {
                      ref.read(downloadProvider.notifier).pauseDownload();
                    }
                  },
                )
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.progress,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
              color: AppTheme.primaryColor,
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(state.progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              if (state.isPaused) const Text('Paused', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              if (isDone) const Text('Complete!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              if (isFailed) const Text('Failed!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton(
              onPressed: () {
                 if (!isDone) ref.read(downloadProvider.notifier).pauseDownload();
                 ref.read(downloadProvider.notifier).reset();
                 Navigator.of(context).pop(); 
                 if(isDone) Navigator.of(context).pop(); // Go back home if completed
              },
              style: TextButton.styleFrom(
                foregroundColor: isDone ? Colors.green : Colors.grey.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(isDone ? 'Open Library' : 'Cancel & Close', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
