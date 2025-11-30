import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/audio/sound_states_provider.dart';

class ShareSheet extends ConsumerStatefulWidget {
  const ShareSheet({super.key});

  @override
  ConsumerState<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends ConsumerState<ShareSheet> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final selectedSoundsAsync = ref.watch(selectedSoundsStreamProvider);

    return selectedSoundsAsync.when(
      data: (selectedSounds) {
        if (selectedSounds.isEmpty) {
          return _buildEmptyState(context);
        }

        final shareData = _buildShareData(selectedSounds);
        final shareUrl = _buildShareUrl(shareData);

        return _buildContent(context, selectedSounds, shareUrl);
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => _buildErrorState(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          Icon(
            LucideIcons.music,
            size: 48,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'No sounds selected',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Select some sounds first to create a shareable link',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load sounds'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<dynamic> selectedSounds,
    String shareUrl,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Row(
            children: [
              Icon(
                LucideIcons.share2,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                'Share your mix',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Share your sound selection with friends',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),

          // Selected sounds preview
          Text(
            '${selectedSounds.length} sound${selectedSounds.length > 1 ? 's' : ''} selected',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedSounds.take(10).map((sound) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    sound.soundId,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // URL field
          Text(
            'Share link',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _copied
                    ? Colors.green
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    shareUrl,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _copyToClipboard(shareUrl),
                  icon: Icon(
                    _copied ? LucideIcons.check : LucideIcons.copy,
                    size: 20,
                    color: _copied ? Colors.green : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Share buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyToClipboard(shareUrl),
                  icon: Icon(_copied ? LucideIcons.check : LucideIcons.copy),
                  label: Text(_copied ? 'Copied!' : 'Copy Link'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _shareUrl(shareUrl),
                  icon: const Icon(LucideIcons.share2),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, double> _buildShareData(List<dynamic> selectedSounds) {
    final Map<String, double> data = {};
    for (final sound in selectedSounds) {
      data[sound.soundId] = sound.volume;
    }
    return data;
  }

  String _buildShareUrl(Map<String, double> shareData) {
    final jsonString = jsonEncode(shareData);
    final encoded = Uri.encodeComponent(jsonString);
    return 'https://moodist.app/?share=$encoded';
  }

  Future<void> _copyToClipboard(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    setState(() => _copied = true);
    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  Future<void> _shareUrl(String url) async {
    await Share.share(
      'Check out my Moodist ambient sound mix!\n\n$url',
      subject: 'My Moodist Mix',
    );
  }
}

void showShareSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const ShareSheet(),
  );
}
