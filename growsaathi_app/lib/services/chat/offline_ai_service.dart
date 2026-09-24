import '../../core/utils/formatters.dart';
import 'ai_service.dart';

/// Local "knowledge service" answering from a fixed set of business
/// rules over demo numbers — deliberately the same pattern as the real
/// backend's `ChatService.processQuestion()` (keyword matching, no
/// LLM), just running on-device instead of on the server. This keeps
/// the demo honest with the AI reality check in the backend mapping:
/// nothing here is a language model, it's rules over data.
///
/// Numbers match this app's own demo dataset (`dashboard_mock.json`,
/// `InsightService`) so answers stay consistent with what the rest of
/// the app already shows in Demo Mode.
class OfflineAiService implements AiService {
  static const double _todaysSales = 52480;
  static const int _inactiveCustomers = 18;
  static const Map<String, int> _lowStock = {'Rice': 8, 'Sugar': 6};
  static const Map<String, int> _outOfStock = {'Cooking Oil': 0};
  static const String _topProduct = 'Wheat Flour (5kg)';
  static const String _topCustomer = 'Rajesh Kumar';

  @override
  Future<String> ask(String question) async {
    await Future.delayed(const Duration(milliseconds: 700)); // feels like "thinking"

    final q = question.toLowerCase().trim();

    if (q.isEmpty) {
      return 'Please type a question about your business.';
    }

    if (_matchesAny(q, ['today', 'sales today', "today's sales"]) && q.contains('sale')) {
      return "Today's sales are ${Formatters.currency(_todaysSales)}.";
    }

    if (q.contains('low stock') || q.contains('running low') || q.contains('restock')) {
      final entry = _lowStock.entries.first;
      return '${entry.key} has only ${entry.value} units remaining.';
    }

    if (q.contains('out of stock')) {
      final entry = _outOfStock.entries.first;
      return '${entry.key} is currently out of stock.';
    }

    if (q.contains('inactive customer') || q.contains('at risk') || q.contains('at-risk')) {
      return "$_inactiveCustomers customers haven't purchased in 30 days.";
    }

    if (q.contains('best sell') || q.contains('top product') || q.contains('best product')) {
      return 'Your best-selling product right now is $_topProduct.';
    }

    if (q.contains('top customer') || q.contains('best customer')) {
      return 'Your top customer is $_topCustomer.';
    }

    if (q.contains('how is my business') || q.contains('business summary') || q.contains('overview')) {
      return "Today's sales are ${Formatters.currency(_todaysSales)}. "
          '$_inactiveCustomers customers are inactive, and ${_lowStock.length + _outOfStock.length} '
          'products need restocking.';
    }

    if (q.contains('what should i do') || q.contains('recommend')) {
      return 'Start by restocking ${_lowStock.keys.first} and reaching out to your $_inactiveCustomers inactive customers.';
    }

    return "I don't have an answer for that yet in offline mode. Try asking about today's sales, "
        'low stock, inactive customers, or your best-selling products.';
  }

  bool _matchesAny(String q, List<String> phrases) => phrases.any((p) => q.contains(p));
}
