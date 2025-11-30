import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CategoryHeader extends StatelessWidget {
  final String title;
  final String icon;

  const CategoryHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getIcon(icon),
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
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

  IconData _getIcon(String iconName) {
    const iconMap = {
      'tree-pine': LucideIcons.treePine,
      'cloud-rain': LucideIcons.cloudRain,
      'dog': LucideIcons.dog,
      'building': LucideIcons.building,
      'map-pin': LucideIcons.mapPin,
      'car': LucideIcons.car,
      'box': LucideIcons.box,
      'radio': LucideIcons.radio,
    };
    return iconMap[iconName] ?? LucideIcons.music;
  }
}
