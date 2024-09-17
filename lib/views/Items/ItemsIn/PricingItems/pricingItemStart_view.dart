import 'package:flutter/material.dart';


class PricingitemstartView extends StatelessWidget {
  const PricingitemstartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pricing item start",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Center(child: Text("Pricing item start View")),
    );
  }
}