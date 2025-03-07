import 'package:flutter/material.dart';

import 'menu_item.widget.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/medelec.png'),
          ),
          MenuItemWidget(
            index: 0,
            icon: Icons.local_offer,
            title: 'Compras',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 1,
            icon: Icons.card_travel_rounded,
            title: 'Importaciones',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 2,
            icon: Icons.card_travel_rounded,
            title: 'Test',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
        ],
      ),
    );
  }
}
