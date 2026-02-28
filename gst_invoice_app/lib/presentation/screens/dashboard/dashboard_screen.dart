import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../data/models/hive/invoice_model.dart';
import '../../../services/admob_service.dart';
import '../invoice/invoice_list_screen.dart';
import '../invoice/create_invoice_screen.dart';
import '../customer/customer_list_screen.dart';
import '../product/product_list_screen.dart';
import '../settings/settings_screen.dart';
import '../templates/template_selector_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final InvoiceRepository _invoiceRepo = InvoiceRepository();
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdMobService.createBannerAd()
      ..load().then((_) {
        if (mounted) {
          setState(() => _bannerAdLoaded = true);
        }
      });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStats();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(stats),
                    const SizedBox(height: 20),
                    _buildQuickActions(context),
                    const SizedBox(height: 20),
                    _buildMonthlyChart(),
                    const SizedBox(height: 20),
                    _buildRecentInvoices(context),
                  ],
                ),
              ),
            ),
          ),
          if (_bannerAdLoaded && _bannerAd != null)
            SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateInvoiceScreen()),
        ),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Invoice',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStats() {
    return {
      'totalSales': _invoiceRepo.getTotalSales(),
      'totalGST': _invoiceRepo.getTotalGSTCollected(),
      'pending': _invoiceRepo.getTotalPending(),
      'invoiceCount': _invoiceRepo.getInvoiceCount(),
    };
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _statCard('Total Sales',
            _formatCurrency(stats['totalSales'] as double),
            Icons.trending_up, Colors.blue.shade700),
        _statCard('GST Collected',
            _formatCurrency(stats['totalGST'] as double),
            Icons.receipt_long, Colors.green.shade700),
        _statCard('Pending',
            _formatCurrency(stats['pending'] as double),
            Icons.pending_actions, Colors.orange.shade700),
        _statCard('Total Invoices',
            '${stats['invoiceCount']}',
            Icons.description, Colors.purple.shade700),
      ],
    );
  }

  Widget _statCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMedium,
                        fontWeight: FontWeight.w500)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
        const SizedBox(height: 10),
        Row(
          children: [
            _actionChip(context, 'Invoices',
                Icons.description, AppTheme.primaryBlue,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const InvoiceListScreen()))),
            const SizedBox(width: 8),
            _actionChip(context, 'Customers',
                Icons.people, Colors.teal.shade700,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const CustomerListScreen()))),
            const SizedBox(width: 8),
            _actionChip(context, 'Products',
                Icons.inventory_2, Colors.purple.shade700,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const ProductListScreen()))),
            const SizedBox(width: 8),
            _actionChip(context, 'Templates',
                Icons.design_services, Colors.orange.shade700,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const TemplateSelectorScreen()))),
          ],
        ),
      ],
    );
  }

  Widget _actionChip(BuildContext context, String label,
      IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final monthly =
        _invoiceRepo.getMonthlySales();
    if (monthly.isEmpty) return const SizedBox();

    final sorted = monthly.entries.toList()
      ..sort((a, b) =>
          a.key.compareTo(b.key));
    final last6 = sorted.takeLast(6).toList();

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              barGroups: last6
                  .asMap()
                  .entries
                  .map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.value,
                      color: AppTheme.primaryBlue,
                      width: 16,
                      borderRadius:
                          const BorderRadius.only(
                        topLeft:
                            Radius.circular(4),
                        topRight:
                            Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget:
                        (value, meta) {
                      final idx =
                          value.toInt();
                      if (idx <
                          last6.length) {
                        final parts =
                            last6[idx]
                                .key
                                .split('-');
                        final month =
                            int.tryParse(
                                    parts[1]) ??
                                1;
                        const months = [
                          '',
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec'
                        ];
                        return Text(
                            months[month],
                            style:
                                const TextStyle(
                                    fontSize:
                                        10));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              gridData:
                  FlGridData(show: false),
              borderData:
                  FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentInvoices(
      BuildContext context) {
    final recent =
        _invoiceRepo.getRecentInvoices(
            limit: 5);

    if (recent.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text('Recent Invoices',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
        const SizedBox(height: 8),
        ...recent.map(
            (inv) => _recentInvoiceTile(
                context, inv)),
      ],
    );
  }

  Widget _recentInvoiceTile(
      BuildContext context,
      InvoiceModel inv) {
    final statusColor =
        inv.paymentStatus == 'paid'
            ? Colors.green
            : inv.paymentStatus ==
                    'partial'
                ? Colors.orange
                : Colors.red;

    return Card(
      margin:
          const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              AppTheme.primaryBlue
                  .withOpacity(0.1),
          child: const Icon(
              Icons.description,
              color:
                  AppTheme.primaryBlue),
        ),
        title: Text(inv.customerName,
            style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                fontSize: 14)),
        subtitle: Text(
            '${inv.invoiceNumber} • ${DateFormat('dd MMM yyyy').format(inv.invoiceDate)}'),
        trailing: Text(
            _formatCurrency(
                inv.finalTotal)),
      ),
    );
  }

  String _formatCurrency(
      double amount) {
    return '₹${NumberFormat('#,##,##0.00').format(amount)}';
  }
}

extension IterableExtension<E>
    on Iterable<E> {
  Iterable<E> takeLast(int n) {
    final list = toList();
    final start =
        list.length - n;
    return list.sublist(
        start < 0 ? 0 : start);
  }
}
