import 'package:flutter/material.dart';
import 'package:login/database_helper.dart';
import 'package:login/ListarCartas.dart';
import 'registro.dart';
import 'user_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      int? loginResult = await DatabaseHelper().loginUsuario(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      bool isValid = loginResult != null && loginResult > 0;

      if (isValid) {
        // Redirigir a la pantalla de listar cartas tras iniciar sesión
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListarCartas(userId: loginResult),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesión"),
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor ingresa un correo válido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña.';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _loginUser,
                      child: Text("Iniciar Sesión"),
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text("¿No tienes cuenta? Regístrate"),
              ),
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de cambiar contraseña
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetScreen(),
                    ),
                  );
                },
                child: Text("¿Olvidaste tu contraseña? Cámbiala aquí"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
