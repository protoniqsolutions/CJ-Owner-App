// views/dailyreports_view.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:cjowner/models/daily_report_data.dart';
import 'package:cjowner/services/reports/report.dart';

class DailyreportsView extends StatefulWidget {
  const DailyreportsView({super.key});

  @override
  _DailyreportsViewState createState() => _DailyreportsViewState();
}

class _DailyreportsViewState extends State<DailyreportsView> {
  late Future<DailyReportData> futureReportData;
  final Report apiService = Report();

  @override
  void initState() {
    super.initState();
    futureReportData = apiService.fetchDailySalesReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Sales Reports'),
        elevation: 0,
      ),
      body: FutureBuilder<DailyReportData>(
        future: futureReportData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final reportData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeaderCard(reportData),

                    const SizedBox(height: 20),

                    // Pie Chart Section
                    _buildPieChartCard(reportData),

                    const SizedBox(height: 20),

                    // Legend Section
                    const Text(
                      'Items Legend',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: reportData.pieChartData.map((data) {
                        return _buildLegendItem(data.itemName);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds the header card displaying total sales amount and total margin.
  Widget _buildHeaderCard(DailyReportData reportData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Sales Amount: Rs ${reportData.totalSalesAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Margin: Rs ${reportData.totalMargin.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the pie chart card displaying sales distribution.
  Widget _buildPieChartCard(DailyReportData reportData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: fl.PieChart(
                fl.PieChartData(
                  sections: reportData.pieChartData
                      .map(
                        (data) => fl.PieChartSectionData(
                          title: '${data.percentage.toStringAsFixed(1)}%',
                          value: data.percentage,
                          color: _getColor(data.itemName),
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          radius: 60,
                        ),
                      )
                      .toList(),
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  borderData: fl.FlBorderData(show: false),
                  pieTouchData: fl.PieTouchData(
                    touchCallback: (fl.FlTouchEvent event,
                        fl.PieTouchResponse? pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        return;
                      }
                      setState(() {
                        final index = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                        if (index != -1) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(
                                reportData.pieChartData[index].itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Percentage: ${reportData.pieChartData[index].percentage.toStringAsFixed(2)}%',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a legend item with a color circle and item name.
  Widget _buildLegendItem(String itemName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getColor(itemName),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          itemName,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Generates a color based on the item name.
  Color _getColor(String itemName) {
    final int hash = itemName.hashCode;
    final int r = (hash & 0xFF0000) >> 16;
    final int g = (hash & 0x00FF00) >> 8;
    final int b = hash & 0x0000FF;
    return Color.fromARGB(255, r, g, b);
  }
}

