// lib/info.dart
import 'package:flutter/material.dart';
import 'ListarCartas.dart';

class InfoScreen extends StatelessWidget {
  final String email;
  final int userId;

  InfoScreen({required this.email, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Información del Usuario"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¡Registro exitoso!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Bienvenido, $email",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListarCartas(userId: userId),
                  ),
                );
              },
              child: Text("Ir a la interfaz"),
            ),
          ],
        ),
      ),
    );
  }
}