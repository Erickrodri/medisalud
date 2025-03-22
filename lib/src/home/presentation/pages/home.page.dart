import 'package:flutter/material.dart';
import 'package:medisalud/src/features/insured/pages/facturas.page.dart';
import 'package:medisalud/src/features/insured/pages/notificaciones.page.dart';
import 'package:medisalud/src/features/insured/pages/pedidos.page.dart';
import '../widget/side_menu.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List _content = <Widget>[
    PedidosPage(),
    NotificacionesPage(),
    FacturaPage(),
  ];

  void _updateContent(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: _updateContent,
          ),
          Expanded(
            child: Container(
              color: Color(0xFFF0F0F0),
              child: _content[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
