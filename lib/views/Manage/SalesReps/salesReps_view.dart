import 'package:cjowner/models/manage_salesrep.dart';
import 'package:cjowner/services/salesrep/salesRepService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SalesrepsView extends StatefulWidget {
  const SalesrepsView({super.key});

  @override
  State<SalesrepsView> createState() => _SalesrepsViewState();
}

class _SalesrepsViewState extends State<SalesrepsView> {
  final SalesRepService _salesRepService = SalesRepService();
  late Future<List<ManageSalesRepModel>> _salesRepsFuture;

  @override
  void initState() {
    super.initState();
    _salesRepsFuture = _salesRepService.getAllSalesReps();
  }

  Future<void> _refreshSalesReps() async {
    setState(() {
      _salesRepsFuture = _salesRepService.getAllSalesReps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sales Reps",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            MaterialButton(
              minWidth: double.infinity,
              color: Colors.green,
              height: 55,
              onPressed: () {
                GoRouter.of(context).pushNamed('addsalesReps');
              },
              child: const Text(
                "Add Sales Reps",
                style: TextStyle(fontSize: 26),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshSalesReps, // Add the refresh callback
                child: FutureBuilder<List<ManageSalesRepModel>>(
                  future: _salesRepsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No sales representatives found.'));
                    } else {
                      final salesReps = snapshot.data!;
                      return ListView.builder(
                        itemCount: salesReps.length,
                        itemBuilder: (context, index) {
                          final rep = salesReps[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                  'manageSalesReps',
                                  extra: rep,
                                );
                              },
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                rep.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                rep.mobileNumber,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
