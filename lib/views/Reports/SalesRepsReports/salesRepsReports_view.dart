// lib/views/sales_reps_view.dart
import 'package:flutter/material.dart';
import 'package:cjowner/models/reportSalesRep.dart';
import 'package:cjowner/services/reports/report.dart';

class SalesrepsreportsView extends StatefulWidget {
  const SalesrepsreportsView({super.key});

  @override
  State<SalesrepsreportsView> createState() => _SalesrepsreportsViewState();
}

class _SalesrepsreportsViewState extends State<SalesrepsreportsView> {
  final Report apiService = Report();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Reps Reports'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ReportSalesRep>>(
        future: apiService.fetchSalesReps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Sales Reps Data Available'));
          } else {
            final salesReps = snapshot.data!;
            return ListView.builder(
              itemCount: salesReps.length,
              itemBuilder: (context, index) {
                final salesRep = salesReps[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      salesRep.salesRepName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Total Sales: Rs ${salesRep.totalSales}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () => _showSalesRepDetails(context, salesRep),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }


void _showSalesRepDetails(BuildContext context, ReportSalesRep salesRep) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow control over the height
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7, // Set height here (60% of screen height)
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Rep Details',
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Name:', salesRep.salesRepName),
          _buildDetailRow('Total Sales:', 'RS ${salesRep.totalSales}'),
          _buildDetailRow('Total Margin:', 'Rs ${salesRep.totalMargin}'),
          _buildDetailRow('Number of Invoices:', '${salesRep.numberOfInvoices}'),
          const SizedBox(height: 24),
          Text(
            'Additional Info',
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
          _buildDetailRow('NIC:', salesRep.salesRepDetails.nic),
          _buildDetailRow('Address:', salesRep.salesRepDetails.address),
          _buildDetailRow('DOB:', salesRep.salesRepDetails.dob),
          _buildDetailRow('Mobile Number:', salesRep.salesRepDetails.mobileNumber),
          _buildDetailRow('Email:', salesRep.salesRepDetails.email),
        ],
      ),
    ),
  );
}



  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
