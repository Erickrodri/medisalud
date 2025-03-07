import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImportacionesPage extends StatefulWidget {
  @override
  State<ImportacionesPage> createState() => _ImportacionesPageState();
}

class _ImportacionesPageState extends State<ImportacionesPage> {
  List<Map<String, dynamic>> importaciones = [];
  String responseData = "Esperando respuesta...";

  Future<void> fetchData() async {
    const url = 'http://localhost:3000/importaciones';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);

        List<Map<String, dynamic>> importacionesData =
            responseList.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          responseData =
              'Datos obtenidos: ${importacionesData.length} elementos';
          importaciones = importacionesData;
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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                              'Importaciones',
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
                            // button
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Nueva Importación',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5932EA),
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
                            DataColumn(label: Text('Nro Importación')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Proveedor')),
                            DataColumn(label: Text('Costo Total')),
                            DataColumn(label: Text('Estado')),
                          ],
                          rows: importaciones.map((row) {
                            return DataRow(cells: [
                              DataCell(Text(row['id_importacion'].toString())),
                              DataCell(Text(row['nro_importacion'])),
                              DataCell(Text(row['fecha_importacion'])),
                              DataCell(Text(row['proveedor'])),
                              DataCell(Text(row['costo_total'])),
                              DataCell(Text(row['estado'])),
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
    );
  }
}

/*

{
  "nro_importacion": "IMP-2025-005",
  "fecha_importacion": "2025-03-17",
  "proveedor": "Proveedor X",
  "costo_total": 5000.00,
  "estado": "Pendiente",
  "detalles": [
    {
      "id_tipo_medidor": 1,
      "cantidad": 5,
      "precio_unitario": 100.00,
      "subtotal": 500.00
    }
  ]
}

 */