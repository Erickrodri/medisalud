import 'package:flutter/material.dart';

import '../widgets/information.widget.dart';
import '../widgets/search.widget.dart';

class InsuredPage extends StatelessWidget {
  InsuredPage({super.key});
  final List<Map<String, dynamic>> data = [
    {
      'name': 'Juan',
      'plan': 'Basico',
      'cel': '78055112',
      'email': 'email@email.com',
      'holder': 'Titular',
      'state': 'Activo'
    },
    {
      'name': 'Maria',
      'plan': 'Medio',
      'cel': '78055112',
      'email': 'email@email.com',
      'holder': 'Titular',
      'state': 'Activo'
    },
    {
      'name': 'Pedro',
      'plan': 'Basico',
      'cel': '78055112',
      'email': 'email@email.com',
      'holder': 'Titular',
      'state': 'Activo'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hola Erick',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          const InsuredInformationWidget(),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Asegurados',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Asegurados Activos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[400],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const SearchWidget(),
                          ElevatedButton.icon(
                            onPressed: () {
                              AddButtonPage.openDialog(context);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Nuevo',
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
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Nombre Asegurado')),
                            DataColumn(label: Text('Plan')),
                            DataColumn(label: Text('Celular')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Titular')),
                            DataColumn(label: Text('Estado')),
                          ],
                          rows: data
                              .map(
                                (row) => DataRow(cells: [
                                  DataCell(Text(row['name'])),
                                  DataCell(Text(row['plan'])),
                                  DataCell(Text(row['cel'])),
                                  DataCell(Text(row['email'])),
                                  DataCell(Text(row['holder'])),
                                  DataCell(Text(row['state'])),
                                ]),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class AddButtonPage {
  static void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Fondo transparente para usar Stack
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Registro del Asegurado',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Numero de Identidad (CI)',
                          hintText: 'Ingrese CI',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          hintText: 'Ingresa nombres',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          hintText: 'Ingresa apellidos',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                          hintText: 'dd/mm/aaaa',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Telefono',
                          hintText: 'Ingresa telefono',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo Electronico',
                          hintText: 'Ingresa email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Direccion',
                          hintText: 'Ingresa direccion',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Plan de seguro',
                          hintText: 'Seleccione un plan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Cerrar',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5932EA),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Registrar Asegurado',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
