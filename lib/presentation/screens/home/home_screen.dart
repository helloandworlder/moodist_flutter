import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../sounds/sounds_screen.dart';
import '../favorites/favorites_screen.dart';
import '../tools/tools_screen.dart';
import '../settings/settings_screen.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../widgets/playback/mini_player.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    HapticFeedback.lightImpact();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = ref.watch(hasSelectionProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: const [
          _KeepAlivePage(child: SoundsScreen()),
          _KeepAlivePage(child: FavoritesScreen()),
          _KeepAlivePage(child: ToolsScreen()),
          _KeepAlivePage(child: SettingsScreen()),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini player (shown when sounds are selected)
          if (hasSelection) const MiniPlayer(),
          // Modern bottom navigation
          _ModernBottomNav(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            bottomPadding: bottomPadding,
          ),
        ],
      ),
    );
  }
}

// Keep pages alive when switching tabs
class _KeepAlivePage extends StatefulWidget {
  final Widget child;
  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double bottomPadding;

  const _ModernBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xF0181818)
              : const Color(0xF5FFFFFF),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: bottomPadding > 0 ? 4 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: LucideIcons.music2,
                  label: 'nav.sounds'.tr(),
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: LucideIcons.heart,
                  label: 'nav.favorites'.tr(),
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: LucideIcons.layoutGrid,
                  label: 'nav.tools'.tr(),
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: LucideIcons.settings,
                  label: 'nav.settings'.tr(),
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSelected ? 20 : 24,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white60
                      : Colors.black54,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
