import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String? subtitle;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MenuItemWidget({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.selectedIndex,
    required this.onItemSelected,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromARGB(255, 8, 150, 84) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Color(0xFF919783),
          size: 18,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isSelected ? Colors.white : Color(0xFF919783),
          size: 14,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF919783),
            fontSize: 14,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF919783),
                  fontSize: 12,
                ),
              )
            : null,
        tileColor: isSelected ? Colors.blue[300] : Colors.transparent,
        onTap: () => onItemSelected(index),
      ),
    );
  }
}
