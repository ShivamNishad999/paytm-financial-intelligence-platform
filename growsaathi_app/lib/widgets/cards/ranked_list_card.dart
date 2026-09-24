import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';

/// One row in a [RankedListCard].
class RankedListItem {
  final String title;
  final String subtitle;
  final String trailingValue;
  final String? trailingSubValue;

  const RankedListItem({
    required this.title,
    required this.subtitle,
    required this.trailingValue,
    this.trailingSubValue,
  });
}

/// Generic "Top N" list card — used for Best-Selling Products,
/// Top Customers, and Low-Performing Products so the layout stays
/// consistent across the Insights screen instead of one-off widgets.
class RankedListCard extends StatelessWidget {
  const RankedListCard({
    super.key,
    required this.title,
    required this.items,
    required this.emptyMessage,
    this.icon = Icons.emoji_events_outlined,
  });

  final String title;
  final List<RankedListItem> items;
  final String emptyMessage;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: title),
            const SizedBox(height: 8),
            if (items.isEmpty)
              EmptyState(message: emptyMessage, icon: icon)
            else
              ...List.generate(items.length, (i) {
                final item = items[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(item.subtitle, style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.trailingValue, style: AppTextStyles.bodyMedium),
                          if (item.trailingSubValue != null)
                            Text(item.trailingSubValue!, style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
