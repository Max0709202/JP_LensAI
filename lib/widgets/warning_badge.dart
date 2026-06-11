import 'package:flutter/material.dart';

class WarningBadge extends StatelessWidget {
  const WarningBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final normalized = label.toLowerCase();
    final Color background;
    final Color foreground;

    if (normalized.contains('important') ||
        normalized.contains('pork') ||
        normalized.contains('seafood') ||
        normalized.contains('not vegan')) {
      background = colors.errorContainer;
      foreground = colors.onErrorContainer;
    } else if (normalized.contains('caution') ||
        normalized.contains('wheat') ||
        normalized.contains('egg') ||
        normalized.contains('soy') ||
        normalized.contains('alcohol') ||
        normalized.contains('spicy')) {
      background = const Color(0xffffe2a9);
      foreground = const Color(0xff3f2d00);
    } else {
      background = colors.secondaryContainer;
      foreground = colors.onSecondaryContainer;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
