import 'package:flutter/material.dart';
import 'package:medisalud/src/home/presentation/pages/home.page.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Controlar la visibilidad de la contraseña

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    int statusCode = await postLogin(username: username, password: password);
    print(statusCode);
    if (statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuario o contraseña incorrectos'),
      ));
    }
  }

  Future<int> postLogin(
      {required String username, required String password}) async {
    // Construir el JSON del pedido
    final Map<String, dynamic> data = {
      "username": username,
      "password": password
    };

    const String url =
        'http://localhost:3000/auth/login'; // Reemplaza con tu endpoint real

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return response.statusCode; // Devuelve el statusCode
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images.jpg', width: 100, height: 100),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width *
                    0.19, // Ancho responsive
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Campo de contraseña con el ojito para mostrarla
              Container(
                width: MediaQuery.of(context).size.width * 0.19,
                child: TextField(
                  controller: _passwordController,
                  obscureText:
                      !_isPasswordVisible, // Mostrar u ocultar contraseña
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Cambiar estado
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botón de login con el mismo tamaño que los inputs
              Container(
                width: MediaQuery.of(context).size.width *
                    0.19, // Ancho responsive
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 8, 150, 84),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
