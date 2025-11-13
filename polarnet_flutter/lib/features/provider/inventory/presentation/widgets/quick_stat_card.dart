import 'package:flutter/material.dart';

class QuickStatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const QuickStatCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        // ignore: deprecated_member_use
                        color: iconColor.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
