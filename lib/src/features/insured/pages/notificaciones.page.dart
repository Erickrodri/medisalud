import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificacionesPage extends StatefulWidget {
  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  List<Map<String, dynamic>> notificaciones = [];
  String responseData = "Esperando respuesta...";

    Future<void> fetch() async {
    const url = 'http://localhost:3000/notificaciones';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> facturasData =
            responseList.map((item) => item as Map<String, dynamic>).toList();
        setState(() {
          responseData = 'Datos obtenidos: ${facturasData.length} elementos';
          notificaciones = facturasData;
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
                                'Notificaciones',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Tipo')),
                              DataColumn(label: Text('Mensaje')),
                              DataColumn(label: Text('Fecha y Hora')),
                              DataColumn(label: Text('Destinatario')),
                              DataColumn(label: Text('Pedido N°')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Leída')),
                            ],
                            rows: notificaciones.map((notificacion) {
                              return DataRow(cells: [
                                DataCell(Text(notificacion['tipo'])),
                                DataCell(Text(notificacion['mensaje'])),
                                DataCell(Text(notificacion['fecha_hora'])),
                                DataCell(Text(
                                    notificacion['destinatario']['nombre'])),
                                DataCell(Text(notificacion['pedido']
                                        ['numero_pedido']
                                    .toString())),
                                DataCell(
                                    Text(notificacion['pedido']['estado'])),
                                DataCell(Text(notificacion['pedido']['total'])),
                                DataCell(
                                    Text(notificacion['leida'] ? 'Sí' : 'No')),
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
