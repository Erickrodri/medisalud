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
            child: Image.asset('assets/logo.png'),
          ),
          MenuItemWidget(
            index: 0,
            icon: Icons.home,
            title: 'Menu',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 1,
            icon: Icons.account_balance_wallet,
            title: 'Inscripciones',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 2,
            icon: Icons.people,
            title: 'Alumnos',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 3,
            icon: Icons.payments,
            title: 'Pagos',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 4,
            icon: Icons.perm_contact_calendar,
            title: 'Modulos',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          MenuItemWidget(
            index: 5,
            icon: Icons.help,
            title: 'Ayuda',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          const Spacer(),
          MenuItemWidget(
            index: 6,
            icon: Icons.person_sharp,
            title: 'Erick',
            subtitle: 'Administrador',
            selectedIndex: selectedIndex,
            onItemSelected: onItemSelected,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
