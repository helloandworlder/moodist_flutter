import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/tools/note_provider.dart';

class NotepadScreen extends ConsumerStatefulWidget {
  const NotepadScreen({super.key});

  @override
  ConsumerState<NotepadScreen> createState() => _NotepadScreenState();
}

class _NotepadScreenState extends ConsumerState<NotepadScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _hasUnsavedChanges = false;
  bool _isInitialized = false;
  int _wordCount = 0;

  @override
  void dispose() {
    _saveIfNeeded();
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    _hasUnsavedChanges = true;
    _updateWordCount(text);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      _saveNote();
    });
  }

  void _updateWordCount(String text) {
    final words = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    setState(() => _wordCount = text.isEmpty ? 0 : words);
  }

  Future<void> _saveNote() async {
    if (!_hasUnsavedChanges) return;
    await ref.read(noteActionsProvider.notifier).saveNote(_controller.text);
    _hasUnsavedChanges = false;
  }

  void _saveIfNeeded() {
    if (_hasUnsavedChanges) {
      ref.read(noteActionsProvider.notifier).saveNote(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteStreamProvider);

    // Initialize controller with saved note (only once)
    noteAsync.whenData((note) {
      if (!_isInitialized && note != null) {
        _isInitialized = true;
        if (note.content.isNotEmpty) {
          _controller.text = note.content;
          _updateWordCount(note.content);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        actions: [
          // Word count
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_wordCount words',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          // More options
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical, size: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              switch (value) {
                case 'copy':
                  _copyToClipboard();
                  break;
                case 'clear':
                  _showClearDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(LucideIcons.copy, size: 18),
                    SizedBox(width: 12),
                    Text('Copy All'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Clear', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Editor
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
              decoration: InputDecoration(
                hintText: 'Start writing...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: _onTextChanged,
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Auto-save indicator
                  Icon(
                    _hasUnsavedChanges
                        ? LucideIcons.cloud
                        : LucideIcons.cloudCog,
                    size: 16,
                    color: _hasUnsavedChanges
                        ? Colors.orange
                        : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _hasUnsavedChanges ? 'Saving...' : 'Saved',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _hasUnsavedChanges
                              ? Colors.orange
                              : Colors.green,
                        ),
                  ),
                  const Spacer(),
                  // Character count
                  Text(
                    '${_controller.text.length} characters',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
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

  void _copyToClipboard() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to copy'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: _controller.text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(LucideIcons.check, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text('Copied to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Note?'),
        content: const Text('This will delete all your note content.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.clear();
              ref.read(noteActionsProvider.notifier).clearNote();
              _updateWordCount('');
              _hasUnsavedChanges = false;
              HapticFeedback.mediumImpact();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
