import 'package:flutter/material.dart';


class ManageitemsView extends StatelessWidget {
  const ManageitemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Manage items",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(child: Text("Manage items View")),
    );
  }
}