import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/audio/playback_provider.dart';
import '../../providers/settings/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalVolume = ref.watch(globalVolumeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Gradient header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'settings.title'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'settings.subtitle'.tr(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // App icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.music2,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Settings content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Audio section
                  _SectionTitle(title: 'settings.audio'.tr(), icon: LucideIcons.volume2),
                  const SizedBox(height: 12),
                  _VolumeCard(
                    volume: globalVolume,
                    onChanged: (value) {
                      ref.read(globalVolumeProvider.notifier).setVolume(value);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Appearance section
                  _SectionTitle(title: 'settings.appearance'.tr(), icon: LucideIcons.palette),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: _getThemeIcon(themeMode),
                        title: 'settings.theme'.tr(),
                        subtitle: _getThemeSubtitle(themeMode),
                        color: AppColors.warning,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getThemeLabel(themeMode),
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () => _showThemeSelector(context, ref, themeMode),
                      ),
                      const Divider(height: 1, indent: 64),
                      _SettingsTile(
                        icon: LucideIcons.globe,
                        title: 'settings.language'.tr(),
                        subtitle: _getLanguageName(context.locale),
                        color: AppColors.info,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getLanguageFlag(context.locale),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        onTap: () => _showLanguageSelector(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // About section
                  _SectionTitle(title: 'settings.about'.tr(), icon: LucideIcons.info),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: LucideIcons.sparkles,
                        title: 'settings.about_moodist'.tr(),
                        subtitle: 'settings.version'.tr(args: ['1.0.0']),
                        color: AppColors.primary,
                        onTap: () => _showAboutDialog(context),
                      ),
                      const Divider(height: 1, indent: 64),
                      _SettingsTile(
                        icon: LucideIcons.github,
                        title: 'settings.github'.tr(),
                        subtitle: 'settings.github_desc'.tr(),
                        color: const Color(0xFF171515),
                        onTap: () => _openGitHub(),
                      ),
                      const Divider(height: 1, indent: 64),
                      _SettingsTile(
                        icon: LucideIcons.star,
                        title: 'settings.rate'.tr(),
                        subtitle: 'settings.rate_desc'.tr(),
                        color: AppColors.warning,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Support section
                  _SectionTitle(title: 'settings.support'.tr(), icon: LucideIcons.helpCircle),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: LucideIcons.messageCircle,
                        title: 'settings.feedback'.tr(),
                        subtitle: 'settings.feedback_desc'.tr(),
                        color: AppColors.info,
                        onTap: () => _openFeedback(),
                      ),
                      const Divider(height: 1, indent: 64),
                      _SettingsTile(
                        icon: LucideIcons.fileText,
                        title: 'settings.privacy'.tr(),
                        subtitle: 'settings.privacy_desc'.tr(),
                        color: AppColors.success,
                        onTap: () => _openPrivacyPolicy(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'settings.footer'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'settings.sounds_count'.tr(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
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

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return '简体中文';
      case 'ja':
        return '日本語';
      case 'en':
      default:
        return 'English';
    }
  }

  String _getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'en':
      default:
        return '🇺🇸';
    }
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return LucideIcons.sun;
      case ThemeMode.dark:
        return LucideIcons.moon;
      case ThemeMode.system:
        return LucideIcons.smartphone;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'settings.theme_light'.tr();
      case ThemeMode.dark:
        return 'settings.theme_dark'.tr();
      case ThemeMode.system:
        return 'settings.theme_auto'.tr();
    }
  }

  String _getThemeSubtitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'settings.theme_light_desc'.tr();
      case ThemeMode.dark:
        return 'settings.theme_dark_desc'.tr();
      case ThemeMode.system:
        return 'settings.theme_system'.tr();
    }
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'settings.theme'.tr(),
              style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _ThemeOption(
              icon: LucideIcons.smartphone,
              title: 'settings.theme_system'.tr(),
              isSelected: currentMode == ThemeMode.system,
              onTap: () {
                ref.read(themeModeProvider.notifier).setTheme(ThemeMode.system);
                Navigator.pop(sheetContext);
              },
            ),
            _ThemeOption(
              icon: LucideIcons.sun,
              title: 'settings.theme_light'.tr(),
              isSelected: currentMode == ThemeMode.light,
              onTap: () {
                ref.read(themeModeProvider.notifier).setTheme(ThemeMode.light);
                Navigator.pop(sheetContext);
              },
            ),
            _ThemeOption(
              icon: LucideIcons.moon,
              title: 'settings.theme_dark'.tr(),
              isSelected: currentMode == ThemeMode.dark,
              onTap: () {
                ref.read(themeModeProvider.notifier).setTheme(ThemeMode.dark);
                Navigator.pop(sheetContext);
              },
            ),
            SizedBox(height: MediaQuery.of(sheetContext).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'settings.language'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _LanguageOption(
              flag: '🇺🇸',
              title: 'English',
              isSelected: context.locale.languageCode == 'en',
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
            _LanguageOption(
              flag: '🇨🇳',
              title: '简体中文',
              isSelected: context.locale.languageCode == 'zh',
              onTap: () {
                context.setLocale(const Locale('zh'));
                Navigator.pop(ctx);
              },
            ),
            _LanguageOption(
              flag: '🇯🇵',
              title: '日本語',
              isSelected: context.locale.languageCode == 'ja',
              onTap: () {
                context.setLocale(const Locale('ja'));
                Navigator.pop(ctx);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                LucideIcons.music2,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Moodist',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ambient sounds for focus and calm. Mix 75+ high-quality sounds to create your perfect environment.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _openGitHub() async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse('https://github.com/helloandworlder/moodist_flutter');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openFeedback() async {
    HapticFeedback.lightImpact();
    // Open email for feedback
    final uri = Uri.parse('mailto:helloandworlder@gmail.com?subject=Moodist%20Feedback');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openPrivacyPolicy() async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse('https://github.com/helloandworlder/moodist_flutter/blob/main/PRIVACY.md');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

class _VolumeCard extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumeCard({
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(LucideIcons.volume2, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Master Volume',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Controls overall sound level',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${(volume * 100).toInt()}%',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                volume == 0 ? LucideIcons.volumeX : LucideIcons.volume1,
                size: 20,
                color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: onChanged,
                  ),
                ),
              ),
              Icon(
                LucideIcons.volume2,
                size: 20,
                color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
              trailing ??
                  Icon(
                    LucideIcons.chevronRight,
                    color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
                    size: 20,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.grey,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            flag,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
