import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRoutinePage extends StatefulWidget {
  const AddRoutinePage({Key? key}) : super(key: key);

  @override
  _AddRoutinePageState createState() => _AddRoutinePageState();
}

class _AddRoutinePageState extends State<AddRoutinePage> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _timeOfDay;

  @override
  void initState() {
    super.initState();
    _timeOfDay = const TimeOfDay(hour: 8, minute: 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeOfDay = picked;
      });
    }
  }

  void _saveRoutine() {
    var currentDate = DateTime.now();
    context.read<RoutineBloc>().add(AddRoutineEvent(Routine(
        id: 1,
        name: _nameController.text,
        time: DateTime(currentDate.year, currentDate.month, currentDate.day,
            _timeOfDay!.hour, _timeOfDay!.minute))));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Routine')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                key: const Key('routineName'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      key: const Key('routineTime'),
                      onPressed: () => _selectTime(context),
                      child: const Text('Select Time'),
                    ),
                  ),
                  Text(_timeOfDay?.format(context) ?? ''),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                key: const Key('addRoutineButton'),
                onPressed: _saveRoutine,
                child: const Text('Save'),
              ),
            ],
          ),
        ));
  }
}
