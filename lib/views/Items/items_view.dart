import 'package:cjowner/components/customNavButton.dart';
import 'package:cjowner/services/excel/reports_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            CustomListTile(
              leadingIcon: Icons.add_box,
              title: 'Items In',
              subtitle: 'Stock in process',
              onTap: () {
                GoRouter.of(context).pushNamed('itemsIn');
              },
            ),
            const SizedBox(height: 18),
            CustomListTile(
              leadingIcon: Icons.book,
              title: 'Pre Orders',
              subtitle: 'Manage preorders',
              onTap: () {
                GoRouter.of(context).pushNamed('preOrders');
              },
            ),
            const SizedBox(height: 18),
            CustomListTile(
              leadingIcon: Icons.view_agenda,
              title: 'View Items',
              subtitle: 'View stock items',
              onTap: () {
                GoRouter.of(context).pushNamed('viewItems');
              },
            ),
            
           
          ],
        ),
      ),
    );
  }
}
