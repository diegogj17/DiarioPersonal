// lib/ListarCartas.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'Carta.dart';
import 'crearCartas.dart';
import 'login.dart';

class ListarCartas extends StatefulWidget {
   int userId;

  ListarCartas({required this.userId});

  @override
  _ListarCartasState createState() => _ListarCartasState();
}

class _ListarCartasState extends State<ListarCartas> {
  List<Carta> _carta = [];



  @override
  void initState() {
    super.initState();
    _loadCarta();

  }

  Future<void> _loadCarta() async {
    int userId = widget.userId;
    final data = await DatabaseHelper().getCarta(userId);
    setState(() {
      _carta = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    int userId = widget.userId;
    return Scaffold(
      appBar: AppBar(title: Text('Diario de Cartas')),
      body: ListView.builder(
        itemCount: _carta.length,
        itemBuilder: (context, index) {
          final task = _carta[index];
          final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(task.fechaHora);
          return ListTile(
            title: Text(task.title),
            subtitle: Text('${task.description}\nFecha y hora: $formattedDate'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => crearCartas(task: task, userId: userId)),
              ).then((_) => _loadCarta());
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                DatabaseHelper().deleteCarta(task.id!);
                _loadCarta();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => crearCartas(userId: userId)),
          ).then((_) => _loadCarta());
        },
      ),
    );
  }
}