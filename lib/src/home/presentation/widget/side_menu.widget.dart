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
            child: Image.asset('assets/images.jpg'),
          ),
          MenuItemWidget(
            index: 0,
            icon: Icons.view_in_ar_outlined,
            title: 'Pedidos',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 1,
            icon: Icons.notifications_active,
            title: 'Notificaciones',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 2,
            icon: Icons.edit_document,
            title: 'Facturas',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
        ],
      ),
    );
  }
}
