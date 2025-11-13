import 'package:flutter/material.dart';

class QuickStatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color onColor;

  const QuickStatCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onColor,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    // ignore: deprecated_member_use
                    color: onColor.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
