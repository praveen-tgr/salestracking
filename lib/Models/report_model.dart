class ActivityRecord {
  final String date;
  final String subject;
  final String type;
  final String description;
  final String status;

  ActivityRecord({
    required this.date,
    required this.subject,
    required this.type,
    required this.description,
    required this.status,
  });

  factory ActivityRecord.fromMap(Map<String, dynamic> map) {
    return ActivityRecord(
      date: map['Created_Date'] ?? '',
      subject: map['Subject'] ?? '',
      type: map['Activity_Type'] ?? '',
      description: map['Description'] ?? '',
      status: map['Status'] ?? '',
    );
  }
}

class SalesDashboardMetric {
  final int totalInvoiceAmount;
  final List<TopSalesPerson> topSales;
  final List<MonthlyTrend> monthlyTrends;

  SalesDashboardMetric({
    required this.totalInvoiceAmount,
    required this.topSales,
    required this.monthlyTrends,
  });

  factory SalesDashboardMetric.fromMap(Map<String, dynamic> map) {
    return SalesDashboardMetric(
      totalInvoiceAmount: map['total_invoice_amount'] ?? 0,
      topSales: List<TopSalesPerson>.from(
        (map['top_sales'] ?? []).map((x) => TopSalesPerson.fromMap(x)),
      ),
      monthlyTrends: List<MonthlyTrend>.from(
        (map['month_wise_amounts'] ?? []).map((x) => MonthlyTrend.fromMap(x)),
      ),
    );
  }
}

class TopSalesPerson {
  final String customerName;
  final double totalAmount;

  TopSalesPerson({required this.customerName, required this.totalAmount});

  factory TopSalesPerson.fromMap(Map<String, dynamic> map) {
    return TopSalesPerson(
      customerName: map['Customer_Name'] ?? 'Unknown',
      totalAmount: (map['total_amount'] ?? 0.0).toDouble(),
    );
  }
}

class MonthlyTrend {
  final String month;
  final double totalAmount;

  MonthlyTrend({required this.month, required this.totalAmount});

  factory MonthlyTrend.fromMap(Map<String, dynamic> map) {
    return MonthlyTrend(
      month: map['month'] ?? '',
      totalAmount: (map['total_amount'] ?? 0.0).toDouble(),
    );
  }
}
