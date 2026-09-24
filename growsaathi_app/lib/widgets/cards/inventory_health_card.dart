import 'package:flutter/material.dart';

import '../../core/constants/app_text_styles.dart';
import '../../models/insight/inventory_health_item_model.dart';
import '../common/empty_state.dart';
import '../common/section_header.dart';
import '../common/status_badge.dart';

/// GREEN = healthy, ORANGE = low stock, RED = out of stock — per the
/// brief's Inventory screen spec.
class InventoryHealthCard extends StatelessWidget {
  const InventoryHealthCard({super.key, required this.items});

  final List<InventoryHealthItemModel> items;

  (String, BadgeTone) _statusMeta(InventoryHealthStatus status) {
    switch (status) {
      case InventoryHealthStatus.healthy:
        return ('Healthy', BadgeTone.positive);
      case InventoryHealthStatus.low:
        return ('Low Stock', BadgeTone.warning);
      case InventoryHealthStatus.outOfStock:
        return ('Out of Stock', BadgeTone.negative);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Inventory Health'),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const EmptyState(message: 'No products recorded yet.', icon: Icons.inventory_2_outlined)
            else
              ...items.map((item) {
                final (label, tone) = _statusMeta(item.status);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: AppTextStyles.bodyMedium),
                            Text('${item.stock} units in stock', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      StatusBadge(label: label, tone: tone),
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
