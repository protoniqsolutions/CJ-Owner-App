import 'package:cjowner/models/branch.dart';
import 'package:cjowner/services/branch/branchService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchsView extends StatefulWidget {
  const BranchsView({super.key});

  @override
  State<BranchsView> createState() => _BranchsViewState();
}

class _BranchsViewState extends State<BranchsView> {
  final BranchService _branchService = BranchService();
  List<Branch> _branches = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBranches();
  }

  Future<void> _fetchBranches() async {
    try {
      final branches = await _branchService.getAllBranches();
      setState(() {
        _branches = branches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshBranches() async {
    setState(() {
      _isLoading = true; // Optionally set loading state while refreshing
    });
    await _fetchBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Branches",
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
                GoRouter.of(context).pushNamed('addBranch');
              },
              child: const Text("Add Branch", style: TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshBranches, // Add the refresh callback
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                        ? Center(child: Text('Error: $_errorMessage'))
                        : _branches.isEmpty
                            ? const Center(child: Text('No data available'))
                            : ListView.builder(
                                itemCount: _branches.length,
                                itemBuilder: (context, index) {
                                  final branch = _branches[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 20,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        GoRouter.of(context).pushNamed(
                                          'manageBranch',
                                          extra: {
                                            'branchId': branch.branchId,
                                            'branchName': branch.branchName
                                          },
                                        );
                                      },
                                      title: Text(
                                        branch.branchName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
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
