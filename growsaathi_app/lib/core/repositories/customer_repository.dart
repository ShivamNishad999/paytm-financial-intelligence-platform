import '../../models/insight/customer_growth_point_model.dart';
import '../../models/insight/top_customer_model.dart';

/// Backend-ready contract for customer intelligence data.
/// See `sales_repository.dart` for the swap-in pattern this follows.
abstract class CustomerRepository {
  Future<List<CustomerGrowthPointModel>> getCustomerGrowth({DateTime? from, DateTime? to});
  Future<List<TopCustomerModel>> getTopCustomers();
  Future<int> getInactiveCustomerCount();
}
