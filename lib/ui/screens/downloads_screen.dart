import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../core/theme.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download/ADownloader');
      } else {
        final baseDir = await getDownloadsDirectory();
        if (baseDir != null) {
          dir = Directory('${baseDir.path}/ADownloader');
        }
      }
      
      if (dir != null && await dir.exists()) {
        setState(() {
          _files = dir!.listSync().whereType<File>().toList();
        });
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(ref.watch(localeProvider));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('downloads'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 26, letterSpacing: -0.5)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _files.isEmpty 
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_open_rounded, size: 80, color: AppTheme.primaryColor.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No videos downloaded yet', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index] as File;
                final filename = file.path.split(Platform.pathSeparator).last;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_circle_fill, color: AppTheme.primaryColor, size: 28),
                    ),
                    title: Text(filename, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.blue),
                          onPressed: () => Share.shareXFiles([XFile(file.path)], text: 'Check out this video!'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () async {
                            await file.delete();
                            _loadFiles();
                          },
                        ),
                      ],
                    ),
                    onTap: () => OpenFilex.open(file.path),
                  ),
                );
              },
            ),
    );
  }
}
