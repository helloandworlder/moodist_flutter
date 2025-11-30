import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/audio/sound_actions_provider.dart';

class SmartMixCard extends ConsumerWidget {
  const SmartMixCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'smart_mix.title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _MixCard(
                  title: 'smart_mix.focus'.tr(),
                  subtitle: 'smart_mix.focus_desc'.tr(),
                  icon: LucideIcons.brain,
                  gradient: AppColors.primaryGradient,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(soundActionsProvider.notifier).loadSmartMix('focus');
                  },
                ),
                const SizedBox(width: 12),
                _MixCard(
                  title: 'smart_mix.relax'.tr(),
                  subtitle: 'smart_mix.relax_desc'.tr(),
                  icon: LucideIcons.cloudRain,
                  gradient: AppColors.freshGradient,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(soundActionsProvider.notifier).loadSmartMix('relax');
                  },
                ),
                const SizedBox(width: 12),
                _MixCard(
                  title: 'smart_mix.sleep'.tr(),
                  subtitle: 'smart_mix.sleep_desc'.tr(),
                  icon: LucideIcons.moon,
                  gradient: AppColors.coolGradient,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(soundActionsProvider.notifier).loadSmartMix('sleep');
                  },
                ),
                const SizedBox(width: 12),
                _MixCard(
                  title: 'smart_mix.nature'.tr(),
                  subtitle: 'smart_mix.nature_desc'.tr(),
                  icon: LucideIcons.treePine,
                  gradient: AppColors.sunsetGradient,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(soundActionsProvider.notifier).loadSmartMix('nature');
                  },
                ),
                const SizedBox(width: 12),
                _MixCard(
                  title: 'smart_mix.cafe'.tr(),
                  subtitle: 'smart_mix.cafe_desc'.tr(),
                  icon: LucideIcons.coffee,
                  gradient: AppColors.warmGradient,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(soundActionsProvider.notifier).loadSmartMix('cafe');
                  },
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MixCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _MixCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (gradient as LinearGradient).colors.first.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
