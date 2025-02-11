import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'Carta.dart';
import 'crearCartas.dart';

class ListarCartas extends StatefulWidget {
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
    final data = await DatabaseHelper().getCarta();
    setState(() {
      _carta = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diario de Cartas')),
      body: ListView.builder(
        itemCount: _carta.length,
        itemBuilder: (context, index) {
          final task = _carta[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => crearCartas(task: task)),
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
            MaterialPageRoute(builder: (context) => crearCartas()),
          ).then((_) => _loadCarta());
        },
      ),
    );
  }
}