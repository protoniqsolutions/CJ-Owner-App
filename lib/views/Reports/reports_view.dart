import 'package:cjowner/components/customNavButton.dart';
import 'package:cjowner/services/excel/monthly_services.dart';
import 'package:cjowner/services/excel/reports_services.dart';
import 'package:cjowner/services/excel/stock_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(centerTitle: true, title: const Text("Reports", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              CustomListTile(
                leadingIcon: Icons.access_time,
                title: 'Daily Reports',
                subtitle: 'View daily reports',
                onTap: () {
                  GoRouter.of(context).pushNamed('dailyReports');
                },
              ),
              const SizedBox(height: 18),
              CustomListTile(
                leadingIcon: Icons.calendar_month,
                title: 'Monthly Reports',
                subtitle: 'View monthly reports',
                onTap: () {
                  GoRouter.of(context).pushNamed('monthlyReports');
                },
              ),
              const SizedBox(height: 18),
              CustomListTile(
                leadingIcon: Icons.analytics,
                title: 'Sales Reps Reports',
                subtitle: 'View sales reps reports',
                onTap: () {
                  GoRouter.of(context).pushNamed('salesRepsReports');
                },
              ),
              const SizedBox(height: 18),
              CustomListTile(
                leadingIcon: Icons.analytics,
                title: 'Download invoice reports',
                subtitle: 'Download and invoice reports',
                onTap: () async {
                  ExcelGenerator excelGenerator = ExcelGenerator();
                  await excelGenerator.fetchAndGenerateExcel();
                },
              ),
              const SizedBox(height: 18),
              CustomListTile(
                leadingIcon: Icons.analytics,
                title: 'Download stock reports',
                subtitle: 'Download and stock reports',
                onTap: () async {
                  ExcelGeneratorstock excelGenerator = ExcelGeneratorstock();
                  await excelGenerator.fetchAndGenerateExcelForStocks();
                },
              ),
              const SizedBox(height: 18),
              CustomListTile(
                leadingIcon: Icons.analytics,
                title: 'Download monthly reports',
                subtitle: 'Download and monthly reports',
                onTap: () async {
                  ExcelGeneratormonthly excelGenerator = ExcelGeneratormonthly();
                  await excelGenerator.fetchAndGenerateExcel();
                },
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
