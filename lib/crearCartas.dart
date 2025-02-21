import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'Carta.dart';
import 'login.dart';

class crearCartas extends StatefulWidget {
  final Carta? task;
  final int userId;

  crearCartas({this.task, required this.userId});

  @override
  _crearCartasState createState() => _crearCartasState();
}

class _crearCartasState extends State<crearCartas> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();



  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  void _saveTask() async {
    final userId = widget.userId;
    if (_formKey.currentState!.validate()) {
      final carta = Carta(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        fechaHora: DateTime.now(),
        userId: userId,
      );

      if (widget.task == null) {
        await DatabaseHelper().insertCarta(carta);
      } else {
        await DatabaseHelper().updateCarta(carta);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Nuevo Tarea' : 'Editar Tarea')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Por favor ingrese un título' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Por favor ingrese una descripción' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}