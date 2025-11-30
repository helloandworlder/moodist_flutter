import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../presets/presets_screen.dart';
import 'pomodoro_screen.dart';
import 'countdown_screen.dart';
import 'notepad_screen.dart';
import 'todo_screen.dart';
import 'breathing_screen.dart';
import 'binaural_screen.dart';
import 'isochronic_screen.dart';
import '../../widgets/timer/sleep_timer_sheet.dart';
import '../../providers/timer/sleep_timer_provider.dart';

class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepTimer = ref.watch(sleepTimerProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
              decoration: BoxDecoration(
                gradient: AppColors.freshGradient,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'tools.title'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'tools.subtitle'.tr(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tools grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured tools section
                  _SectionTitle(title: 'tools.quick_access'.tr(), icon: LucideIcons.zap),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _FeaturedToolCard(
                          title: 'tools.presets'.tr(),
                          icon: LucideIcons.layers,
                          gradient: AppColors.primaryGradient,
                          onTap: () => _navigate(context, const PresetsScreen()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SleepTimerFeatured(
                          isActive: sleepTimer.isActive,
                          remainingTime: sleepTimer.formattedTime,
                          onTap: () => _showSleepTimer(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Productivity section
                  _SectionTitle(title: 'tools.productivity'.tr(), icon: LucideIcons.target),
                  const SizedBox(height: 12),
                  _ModernToolCard(
                    icon: LucideIcons.timer,
                    title: 'tools.pomodoro'.tr(),
                    subtitle: 'tools.pomodoro_desc'.tr(),
                    color: AppColors.error,
                    onTap: () => _navigate(context, const PomodoroScreen()),
                  ),
                  const SizedBox(height: 10),
                  _ModernToolCard(
                    icon: LucideIcons.clock,
                    title: 'tools.countdown'.tr(),
                    subtitle: 'tools.countdown_desc'.tr(),
                    color: AppColors.warning,
                    onTap: () => _navigate(context, const CountdownScreen()),
                  ),
                  const SizedBox(height: 10),
                  _ModernToolCard(
                    icon: LucideIcons.checkSquare,
                    title: 'tools.todo'.tr(),
                    subtitle: 'tools.todo_desc'.tr(),
                    color: AppColors.success,
                    onTap: () => _navigate(context, const TodoScreen()),
                  ),
                  const SizedBox(height: 10),
                  _ModernToolCard(
                    icon: LucideIcons.fileText,
                    title: 'tools.notepad'.tr(),
                    subtitle: 'tools.notepad_desc'.tr(),
                    color: AppColors.info,
                    onTap: () => _navigate(context, const NotepadScreen()),
                  ),
                  const SizedBox(height: 24),

                  // Wellness section
                  _SectionTitle(title: 'tools.wellness'.tr(), icon: LucideIcons.heart),
                  const SizedBox(height: 12),
                  _ModernToolCard(
                    icon: LucideIcons.wind,
                    title: 'tools.breathing'.tr(),
                    subtitle: 'tools.breathing_desc'.tr(),
                    color: AppColors.categoryTransport,
                    onTap: () => _navigate(context, const BreathingScreen()),
                  ),
                  const SizedBox(height: 24),

                  // Audio tools section
                  _SectionTitle(title: 'tools.audio_tools'.tr(), icon: LucideIcons.headphones),
                  const SizedBox(height: 12),
                  _ModernToolCard(
                    icon: LucideIcons.brainCircuit,
                    title: 'tools.binaural'.tr(),
                    subtitle: 'tools.binaural_desc'.tr(),
                    color: AppColors.categoryThings,
                    onTap: () => _navigate(context, const BinauralScreen()),
                  ),
                  const SizedBox(height: 10),
                  _ModernToolCard(
                    icon: LucideIcons.radio,
                    title: 'tools.isochronic'.tr(),
                    subtitle: 'tools.isochronic_desc'.tr(),
                    color: AppColors.categoryPlaces,
                    onTap: () => _navigate(context, const IsochronicScreen()),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showSleepTimer(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const SleepTimerSheet(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _FeaturedToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _FeaturedToolCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepTimerFeatured extends StatelessWidget {
  final bool isActive;
  final String remainingTime;
  final VoidCallback onTap;

  const _SleepTimerFeatured({
    required this.isActive,
    required this.remainingTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [const Color(0xFF4facfe), const Color(0xFF00f2fe)]
                : [const Color(0xFF2D3748), const Color(0xFF1A202C)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? const Color(0xFF4facfe).withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.moon, color: Colors.white, size: 20),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      remainingTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              'tools.sleep_timer'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ModernToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
