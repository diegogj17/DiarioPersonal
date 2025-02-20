import 'package:flutter/material.dart';
import 'package:login/database_helper.dart';
import 'info.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _message = '';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Registrar el usuario en la base de datos
        final userId = await DatabaseHelper().insertUsuario(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // Redirigir al archivo info.dart con el userId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InfoScreen(
              email: _emailController.text.trim(),
              userId: userId!,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          _message = 'Error al registrar usuario: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo Electrónico"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa un correo electrónico.";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                      .hasMatch(value)) {
                    return "Ingresa un correo electrónico válido.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa una contraseña.";
                  } else if (value.length < 6) {
                    return "La contraseña debe tener al menos 6 caracteres.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text("Registrar"),
              ),
              SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
