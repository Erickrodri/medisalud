import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/information.widget.dart';
import '../widgets/search.widget.dart';

class InsuredPage extends StatefulWidget {
  InsuredPage({super.key});

  @override
  State<InsuredPage> createState() => _InsuredPageState();
}

class _InsuredPageState extends State<InsuredPage> {

  final TextEditingController _identityNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _planIdController = TextEditingController();


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
  String responseData = "Esperando respuesta...";

  List<Map<String, dynamic>> insuredsData = [];

  // Función para hacer el request y manejar la respuesta
  Future<void> fetchData() async {
    const url = 'http://localhost:3000/insureds';
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa (200 OK), imprime el cuerpo
        // print('Respuesta del servidor:');
        // print(response.body);

        List<dynamic> responseList = json.decode(response.body);

        // Convertir la lista de objetos en una lista de Map<String, dynamic>
        List<Map<String, dynamic>> insureds = responseList.map((item) => item as Map<String, dynamic>).toList();

        

        setState(() {
          responseData = 'Datos obtenidos: ${insureds.length} elementos';  // Muestra la cantidad de elementos
          insuredsData = insureds;
        });
        print('Tamano de la lista');
        print(insuredsData.length);

        // print('Respuesta del servidor como lista de objetos:');
        // print(insuredsData);
        // print('nombre: ${insuredsData[0]['person']['first_name']}');
        // print('plan: ${insuredsData[0]['plan']['name']}');
        // print('Celular: ${insuredsData[0]['person']['phone']}');
        // print('Email: ${insuredsData[0]['email']}');
        // print('Titular: ${insuredsData[0]['email']}');
        // print('Estado: ${insuredsData[0]['status']}');
      } else {
        // Si el servidor devuelve un error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al hacer el request: $e');
    }
  }

  // Método para enviar los datos del formulario
  Future<void> submitForm() async {
    final Map<String, dynamic> data = {
      "identity_number": _identityNumberController.text.toString(),
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "birth_date": _birthDateController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "plan_id": int.parse(_planIdController.text),
      "email": _emailController.text,
      "status": "active",
      "start_date": "2025-02-18",
      "end_date": "2026-02-18"
    };

    const String url = 'http://localhost:3000/insureds';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // Si la respuesta es exitosa
        print('Datos enviados correctamente');
        fetchData();
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
          // const Text(
          //   'Hola Erick',
          //   style: TextStyle(fontSize: 18),
          // ),
          // const SizedBox(height: 12),
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
                              // AddButtonPage.openDialog(context);
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
                                                  controller: _identityNumberController,
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
                                                  controller: _firstNameController,
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
                                                  controller: _lastNameController,
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
                                                  controller: _birthDateController,
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
                                                  controller: _phoneController,
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
                                                  controller: _emailController,
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
                                                  controller: _addressController,
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
                                                  controller: _planIdController,
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
                                                        submitForm();
                                                        
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
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Nombre Asegurado')),
                              DataColumn(label: Text('Plan')),
                              DataColumn(label: Text('Celular')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Titular')),
                              DataColumn(label: Text('Estado')),
                            ],
                            // rows: data
                            //     .map(
                            //       (row) => DataRow(cells: [
                            //         DataCell(Text(row['name'])),
                            //         DataCell(Text(row['plan'])),
                            //         DataCell(Text(row['cel'])),
                            //         DataCell(Text(row['email'])),
                            //         DataCell(Text(row['holder'])),
                            //         DataCell(Text(row['state'])),
                            //       ]),
                            //     )
                            //     .toList(),
                            rows: insuredsData
                                .map(
                                  (row) => DataRow(cells: [
                                    DataCell(Text(row['person']['first_name'])),
                                    DataCell(Text(row['plan']['name'])),
                                    DataCell(Text(row['person']['phone'])),
                                    DataCell(Text(row['email'])),
                                    DataCell(Text('Titular')),
                                    DataCell(Text(row['status'])),
                                  ]),
                                )
                                .toList(),
                          ),
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

// class AddButtonPage {
//   static void openDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor:
//               Colors.transparent, // Fondo transparente para usar Stack
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width / 2,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       const Text(
//                         'Registro del Asegurado',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         // controller: ,
//                         decoration: InputDecoration(
//                           labelText: 'Numero de Identidad (CI)',
//                           hintText: 'Ingrese CI',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Nombres',
//                           hintText: 'Ingresa nombres',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Apellidos',
//                           hintText: 'Ingresa apellidos',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Fecha de Nacimiento',
//                           hintText: 'dd/mm/aaaa',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Telefono',
//                           hintText: 'Ingresa telefono',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Correo Electronico',
//                           hintText: 'Ingresa email',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Direccion',
//                           hintText: 'Ingresa direccion',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           labelText: 'Plan de seguro',
//                           hintText: 'Seleccione un plan',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 12,
//                               ),
//                             ),
//                             child: const Text(
//                               'Cerrar',
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF5932EA),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 12,
//                               ),
//                             ),
//                             child: const Text(
//                               'Registrar Asegurado',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
