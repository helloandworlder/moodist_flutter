import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../providers/preset/preset_provider.dart';
import '../../../data/datasources/assets/sound_assets.dart';

class SavePresetSheet extends ConsumerStatefulWidget {
  const SavePresetSheet({super.key});

  @override
  ConsumerState<SavePresetSheet> createState() => _SavePresetSheetState();
}

class _SavePresetSheetState extends ConsumerState<SavePresetSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedSoundsAsync = ref.watch(selectedSoundsStreamProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
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
                  LucideIcons.save,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Save Preset',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Save your current sound mix as a preset for quick access later.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),

            // Selected sounds preview
            selectedSoundsAsync.when(
              data: (sounds) => _buildSoundsPreview(context, sounds),
              loading: () => const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              error: (e, s) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Name input
            TextFormField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Preset Name',
                hintText: 'e.g., Rainy Coffee Shop',
                prefixIcon: const Icon(LucideIcons.pencil, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length > 100) {
                  return 'Name must be 100 characters or less';
                }
                return null;
              },
              onFieldSubmitted: (_) => _savePreset(),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('common.cancel'.tr()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _savePreset,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(LucideIcons.check, size: 20),
                    label: Text(_isSaving ? 'Saving...' : 'Save'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundsPreview(BuildContext context, List<dynamic> sounds) {
    if (sounds.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.alertCircle, color: Colors.red, size: 20),
            SizedBox(width: 12),
            Text(
              'No sounds selected',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.music,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                '${sounds.length} sound${sounds.length > 1 ? 's' : ''} selected',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sounds.take(8).map((soundState) {
              final sound = SoundAssets.getSoundById(soundState.soundId);
              if (sound == null) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      sound.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(soundState.volume * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (sounds.length > 8) ...[
            const SizedBox(height: 8),
            Text(
              '+${sounds.length - 8} more',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _savePreset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    HapticFeedback.lightImpact();

    try {
      final success = await ref
          .read(presetActionsProvider.notifier)
          .saveCurrentAsPreset(_nameController.text);

      if (mounted) {
        if (success) {
          HapticFeedback.mediumImpact();
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(LucideIcons.check, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text('Preset "${_nameController.text.trim()}" saved!'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No sounds selected to save'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving preset: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
