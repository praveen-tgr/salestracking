import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:salespersontracking/Models/report_model.dart';
import 'package:salespersontracking/Providers/Reports/reports_provider.dart';
import 'package:salespersontracking/Style/Stylecustomer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesDashboard extends ConsumerStatefulWidget {
  const SalesDashboard({super.key});

  @override
  ConsumerState<SalesDashboard> createState() => _SalesDashboardState();
}

class _SalesDashboardState extends ConsumerState<SalesDashboard> {
  String _selectedPeriod = 'This Year';
  
  final List<String> _periods = [
    'This Year',
    'This Month',
    'Last 3 Months',
    'Last 6 Months',
    'This Week',
  ];

  (String, String) _getDateRange(String period) {
    final now = DateTime.now();
    final format = DateFormat('yyyy-MM-dd');
    DateTime from;
    DateTime to = now;

    switch (period) {
      case 'This Year':
        from = DateTime(now.year, 1, 1);
        break;
      case 'This Month':
        from = DateTime(now.year, now.month, 1);
        break;
      case 'Last 3 Months':
        from = DateTime(now.year, now.month - 3, 1);
        break;
      case 'Last 6 Months':
        from = DateTime(now.year, now.month - 6, 1);
        break;
      case 'This Week':
        from = now.subtract(Duration(days: now.weekday - 1));
        break;
      default:
        from = DateTime(now.year, 1, 1);
    }
    return (format.format(from), format.format(to));
  }

  @override
  Widget build(BuildContext context) {
    final (from, to) = _getDateRange(_selectedPeriod);
    final dashboardAsync = ref.watch(salesDashboardProvider(fromDate: from, toDate: to));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 24),
                  dashboardAsync.when(
                    data: (metric) => _buildDashboardContent(metric),
                    loading: () => const Center(child: CircularProgressIndicator(color: Stylecustomer.CrmColor)),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Stylecustomer.CrmColor,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Sales Analytics",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Stylecustomer.CrmColor, Color(0xFF0097A7)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          final bool isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedPeriod = period);
              },
              selectedColor: Stylecustomer.CrmColor,
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
              elevation: isSelected ? 4 : 0,
              pressElevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardContent(SalesDashboardMetric metric) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTotalSalesCard(metric.totalInvoiceAmount),
        const SizedBox(height: 32),
        _buildChartSection(metric.monthlyTrends),
        const SizedBox(height: 32),
        _buildLeaderboardSection(metric.topSales),
      ],
    );
  }

  Widget _buildTotalSalesCard(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Stylecustomer.CrmColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue[50]!],
        ),
      ),
      child: Column(
        children: [
          Text(
            "Overall Sales Revenue",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${NumberFormat('#,##,###').format(total)}",
            style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w800, color: Stylecustomer.CrmColor),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.graph_circle_fill, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              Text(
                "Growth trend recorded",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<MonthlyTrend> trends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Monthly Revenue Trend"),
        Container(
          height: 250,
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              labelStyle: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <SplineAreaSeries<MonthlyTrend, String>>[
              SplineAreaSeries<MonthlyTrend, String>(
                dataSource: trends,
                xValueMapper: (MonthlyTrend data, _) => data.month,
                yValueMapper: (MonthlyTrend data, _) => data.totalAmount,
                name: 'Revenue',
                gradient: LinearGradient(
                  colors: [
                    Stylecustomer.CrmColor,
                    Stylecustomer.CrmColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderColor: Stylecustomer.CrmColor,
                borderWidth: 3,
                markerSettings: const MarkerSettings(isVisible: true, color: Colors.white, borderColor: Stylecustomer.CrmColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardSection(List<TopSalesPerson> topSales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Top Sales Representatives"),
        ...topSales.map((sales) => _buildLeaderCard(sales)),
      ],
    );
  }

  Widget _buildLeaderCard(TopSalesPerson sales) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline, color: Colors.blue[400], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sales.customerName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                ),
                Text(
                  "Sales Contribution",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Text(
            "₹${NumberFormat('#,##,###').format(sales.totalAmount)}",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey[400], letterSpacing: 1.5),
      ),
    );
  }
}
