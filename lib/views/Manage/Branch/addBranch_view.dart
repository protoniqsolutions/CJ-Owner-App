import 'package:cjowner/models/branch.dart';
import 'package:cjowner/services/branch/branchService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddbranchView extends StatefulWidget {
  const AddbranchView({super.key});

  @override
  State<AddbranchView> createState() => _AddbranchViewState();
}

class _AddbranchViewState extends State<AddbranchView> {
  final _branchIdController = TextEditingController();
  final _branchNameController = TextEditingController();

  final List<Branch> _branch = [];
  final BranchService _branchService = BranchService();

  void _addBranch() async {
    final branchId = _branchIdController.text;
    final branchName = _branchNameController.text;

    if (branchId.isNotEmpty && branchName.isNotEmpty) {
      final branch = Branch(branchId: branchId, branchName: branchName);
      try {
        await _branchService.createBranch(branch);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Branch added successfully!')),
        );

        GoRouter.of(context).pushNamed("branches");

        // Clear the text fields
        setState(() {
          _branchIdController.clear();
          _branchNameController.clear();
        });
      } catch (e) {
        // Show an error message
        final errorMessage = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      // Handle validation errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add branch",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              TextField(
                controller: _branchIdController,
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
                onPressed: _addBranch,
                child: Text("Add Branch", style: TextStyle(fontSize: 26)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
