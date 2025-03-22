import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PedidosPage extends StatefulWidget {
  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
    // Ejemplo de datos, los reemplazarías con los datos obtenidos de tu API
  String responseData = "Esperando respuesta...";

  List<Map<String, dynamic>> pedidos = [];

  Future<void> fetch() async {
    const url = 'http://localhost:3000/pedidos';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> facturasData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${facturasData.length} elementos';
          pedidos = facturasData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error al hacer el request: $e');
    }
  }

    @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedidos',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                          onPressed: () {
                            //showCompras();
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Nuevo Pedido',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 8, 150, 84),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Nro Pedido')),
                              DataColumn(label: Text('Fecha y Hora')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Para Llevar')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Mesa')),
                              DataColumn(label: Text('Mesero')),
                            ],
                            rows: pedidos.map((pedido) {
                              return DataRow(cells: [
                                DataCell(Text(pedido['id'].toString())),
                                DataCell(Text(pedido['numero_pedido'].toString())),
                                DataCell(Text(pedido['fecha_hora'])),
                                DataCell(Text(pedido['estado'])),
                                DataCell(Text(pedido['para_llevar'] ? 'Sí' : 'No')),
                                DataCell(Text(pedido['total'])),
                                DataCell(Text(pedido['mesa_numero']?.toString() ?? 'N/A')),
                                DataCell(Text(pedido['usuario']['nombre'])),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
