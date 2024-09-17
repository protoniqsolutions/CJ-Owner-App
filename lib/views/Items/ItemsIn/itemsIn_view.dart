import 'package:cjowner/components/customNavButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemsinView extends StatelessWidget {
  const ItemsinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF1F1F1),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Items In",
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
                  title: 'Add Stock',
                  subtitle: 'Add items in your stock',
                  onTap: () {
                    GoRouter.of(context).pushNamed('addStock');
                  },
                ),
                const SizedBox(height: 18),
                CustomListTile(
                  leadingIcon: Icons.verified,
                  title: 'Verify Items',
                  subtitle: 'Verify your pending items',
                  onTap: () {
                    GoRouter.of(context).pushNamed('verifyItems');
                  },
                ),
                const SizedBox(height: 18),
                CustomListTile(
                  leadingIcon: Icons.currency_exchange,
                  title: 'Pricing Items',
                  subtitle: 'Pricing your stock items',
                  onTap: () {
                    GoRouter.of(context).pushNamed('pricingItem');
                  },
                ),
                const SizedBox(height: 18),
                CustomListTile(
                  leadingIcon: Icons.app_registration_rounded,
                  title: 'Register items',
                  subtitle: 'Register new items',
                  onTap: () {
                    GoRouter.of(context).pushNamed('registerItems');
                  },
                ),
              ],
            )));
  }
}
