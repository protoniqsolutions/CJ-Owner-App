import 'package:cjowner/models/branch.dart';
import 'package:cjowner/services/branch/branchService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagebranchView extends StatefulWidget {
  final String branchName;
  final String branchId;

  const ManagebranchView(
      {Key? key, required this.branchName, required this.branchId});

  @override
  State<ManagebranchView> createState() => _ManagebranchViewState();
}

class _ManagebranchViewState extends State<ManagebranchView> {
  late BranchService _branchService;
  final TextEditingController _branchIdController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _branchIdController.text = widget.branchId;
    _branchNameController.text = widget.branchName;
    _branchService = BranchService();
    _fetchBranchDetails();
  }

  Future<void> _fetchBranchDetails() async {
    try {
      final branch = await _branchService.getBranch(widget.branchId);
      setState(() {
        _branchIdController.text = branch.branchId;
        _branchNameController.text = branch.branchName;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching branch details: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching branch details: $e')),
      );
    }
  }

  Future<void> _updateBranch() async {
    try {
      await _branchService.updateBranch(
        _branchIdController.text,
        _branchNameController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Branch updated successfully!')),
      );
      GoRouter.of(context).pushNamed("branches");
    } catch (e) {
      print('Error updating branch: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update branch.')),
      );
    }
  }

  Future<void> _deleteBranch() async {
    try {
      await _branchService.deleteBranch(_branchIdController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Branch deleted successfully!')),
      );
      GoRouter.of(context).pushNamed("branches");
    } catch (e) {
      print('Error deleting branch: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete branch.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Manage branches",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _branchIdController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Branch Id',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _branchNameController,
                      decoration: InputDecoration(
                        labelText: 'Branch Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.green,
                      height: 55,
                      onPressed: _updateBranch,
                      child:
                          Text("Update Branch", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.green,
                      height: 55,
                      onPressed: _deleteBranch,
                      child:
                          Text("Delete Branch", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
