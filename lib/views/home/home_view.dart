// lib/views/home_view.dart

import 'package:cjowner/components/customNavButton.dart';
import 'package:cjowner/services/auth/auth_service.dart';
import 'package:cjowner/services/home/HomeService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<Map<String, dynamic>>? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = HomeService.fetchTotalSalesAndMargin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.applogout();
              context.pushReplacementNamed('login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Hello, Mr. Weerakoon",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildNavigationTiles(),
              SizedBox(height: 30),
              FutureBuilder<Map<String, dynamic>>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data?['status'] != 'success') {
                    return Center(child: Text('No data available'));
                  }

                  final data = snapshot.data!['data'];
                  final overall = data['overall'];
                  final branches = data['branches'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: _buildSectionTitle('Overall Sales')),
                      _buildOverallCard(overall),
                      SizedBox(height: 20),
                      Center(child: _buildSectionTitle('Branch Sales')),
                      ...branches.map((branch) => _buildBranchCard(branch)).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTiles() {
    return Column(
      children: [
        CustomListTile(
          leadingIcon: Icons.view_agenda,
          title: 'View Items',
          subtitle: 'View your stock items',
          onTap: () {
            GoRouter.of(context).pushNamed('viewItems');
          },
        ),
        SizedBox(height: 10),
        CustomListTile(
          leadingIcon: Icons.verified,
          title: 'Verify Items',
          subtitle: 'Verify your items',
          onTap: () {
            GoRouter.of(context).pushNamed('verifyItems');
          },
        ),
        SizedBox(height: 10),
        CustomListTile(
          leadingIcon: Icons.people,
          title: 'Customers',
          subtitle: 'Manage customers ',
          onTap: () {
            GoRouter.of(context).pushNamed('customers');
          },
        ),
        SizedBox(height: 10),
        CustomListTile(
          leadingIcon: Icons.people,
          title: 'Sales Reps',
          subtitle: 'Manage Sales Reps',
          onTap: () {
            GoRouter.of(context).pushNamed('salesReps');
          },
        ),
        SizedBox(height: 10),
        CustomListTile(
          leadingIcon: Icons.account_balance,
          title: 'Branches',
          subtitle: 'Manage branches',
          onTap: () {
            GoRouter.of(context).pushNamed('branches');
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildOverallCard(Map<String, dynamic> overall) {
    return Card(
      color: Colors.white,
      elevation: 0, // Removed shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Total Sales:', overall['totalSales']),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    return Card(
      color: Colors.white,
      elevation: 0, // Removed shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Branch:', branch['branchName']),
            _buildDetailRow('Total Sales:', branch['totalSales']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, size: 18, color: Colors.blueGrey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label $value',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
