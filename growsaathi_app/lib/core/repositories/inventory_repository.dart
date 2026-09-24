import '../../models/insight/inventory_health_item_model.dart';

/// Backend-ready contract for inventory data.
/// See `sales_repository.dart` for the swap-in pattern this follows.
abstract class InventoryRepository {
  Future<List<InventoryHealthItemModel>> getInventoryHealth();
}
