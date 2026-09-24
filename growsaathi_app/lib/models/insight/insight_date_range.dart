/// Date-filter options on the Insights screen. `custom` is reserved
/// for a future date-picker; only the fixed presets are wired for now.
enum InsightDateRange { last7Days, last30Days, thisMonth }

extension InsightDateRangeLabel on InsightDateRange {
  String get label {
    switch (this) {
      case InsightDateRange.last7Days:
        return 'Last 7 Days';
      case InsightDateRange.last30Days:
        return 'Last 30 Days';
      case InsightDateRange.thisMonth:
        return 'This Month';
    }
  }

  int get days {
    switch (this) {
      case InsightDateRange.last7Days:
        return 7;
      case InsightDateRange.last30Days:
        return 30;
      case InsightDateRange.thisMonth:
        return DateTime.now().day;
    }
  }
}
