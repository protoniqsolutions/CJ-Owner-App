import 'package:flutter/material.dart';


class AddcartitemsView extends StatelessWidget {
  const AddcartitemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add cart items",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(child: Text("Add cart items")),
    );
  }
}