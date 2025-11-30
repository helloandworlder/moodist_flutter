import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/database/app_database.dart';
import '../../../data/datasources/assets/sound_assets.dart';
import '../../providers/preset/preset_provider.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../widgets/preset/save_preset_sheet.dart';

class PresetsScreen extends ConsumerWidget {
  const PresetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsync = ref.watch(presetsStreamProvider);
    final hasSelection = ref.watch(hasSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presets'),
      ),
      floatingActionButton: hasSelection
          ? FloatingActionButton.extended(
              onPressed: () => _showSavePresetSheet(context),
              icon: const Icon(LucideIcons.plus),
              label: const Text('Save Current'),
            )
          : null,
      body: presetsAsync.when(
        data: (presets) {
          if (presets.isEmpty) {
            return _buildEmptyState(context, hasSelection);
          }
          return _buildPresetList(context, ref, presets);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool hasSelection) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.folderOpen,
              size: 64,
              color: Colors.grey.shade600,
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 24),
            Text(
              'No Presets Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            Text(
              'Save your favorite sound combinations as presets for quick access.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 32),
            if (hasSelection)
              FilledButton.icon(
                onPressed: () => _showSavePresetSheet(context),
                icon: const Icon(LucideIcons.save, size: 20),
                label: const Text('Save Current Mix'),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0)
            else
              Text(
                'Select some sounds first, then save them as a preset.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetList(
      BuildContext context, WidgetRef ref, List<Preset> presets) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        return _PresetCard(
          preset: preset,
          onLoad: () => _loadPreset(context, ref, preset),
          onRename: () => _showRenameDialog(context, ref, preset),
          onDelete: () => _showDeleteDialog(context, ref, preset),
          onUpdate: () => _showUpdateDialog(context, ref, preset),
        ).animate(delay: Duration(milliseconds: index * 50)).fadeIn().slideX(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOut,
            );
      },
    );
  }

  void _showSavePresetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SavePresetSheet(),
    );
  }

  Future<void> _loadPreset(
      BuildContext context, WidgetRef ref, Preset preset) async {
    HapticFeedback.mediumImpact();
    await ref.read(presetActionsProvider.notifier).loadPreset(preset);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.check, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text('Loaded "${preset.name}"'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, Preset preset) {
    final controller = TextEditingController(text: preset.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Preset'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Enter new name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref.read(presetActionsProvider.notifier).renamePreset(
                    preset.id,
                    value.trim(),
                  );
              Navigator.pop(context);
              HapticFeedback.lightImpact();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(presetActionsProvider.notifier).renamePreset(
                      preset.id,
                      controller.text.trim(),
                    );
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Preset preset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset'),
        content: Text('Are you sure you want to delete "${preset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              ref.read(presetActionsProvider.notifier).deletePreset(preset.id);
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${preset.name}"'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, WidgetRef ref, Preset preset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Preset'),
        content: Text(
          'Replace "${preset.name}" with your current sound selection?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              final success = await ref
                  .read(presetActionsProvider.notifier)
                  .updatePresetWithCurrent(preset.id);
              if (context.mounted) {
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Updated "${preset.name}"'
                          : 'No sounds selected to update',
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: success ? null : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final Preset preset;
  final VoidCallback onLoad;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const _PresetCard({
    required this.preset,
    required this.onLoad,
    required this.onRename,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final soundsMap = preset.soundsMap;
    final soundNames = soundsMap.keys.map((id) {
      final sound = SoundAssets.getSoundById(id);
      return sound?.label ?? id;
    }).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onLoad,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.layers,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preset.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${soundsMap.length} sound${soundsMap.length > 1 ? 's' : ''} • ${_formatDate(preset.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(LucideIcons.moreVertical, size: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'load':
                          onLoad();
                          break;
                        case 'update':
                          onUpdate();
                          break;
                        case 'rename':
                          onRename();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'load',
                        child: Row(
                          children: [
                            Icon(LucideIcons.play, size: 18),
                            SizedBox(width: 12),
                            Text('Load'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'update',
                        child: Row(
                          children: [
                            Icon(LucideIcons.refreshCw, size: 18),
                            SizedBox(width: 12),
                            Text('Update'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(LucideIcons.pencil, size: 18),
                            SizedBox(width: 12),
                            Text('Rename'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (soundNames.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: soundNames.take(5).map((name) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
                if (soundNames.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+${soundNames.length - 5} more',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
