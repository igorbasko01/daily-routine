import 'package:daily_routine/blocs/credits_bloc.dart';
import 'package:daily_routine/blocs/credits_state.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_event.dart';
import 'package:daily_routine/blocs/routine_state.dart';
import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/screens/add_routine_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Routine'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          BlocBuilder<RoutineBloc, RoutineState>(builder: (blocContext, state) {
        if (state is InitialRoutineState) {
          return const Center(
            child: Text('Welcome to your Daily Routine!'),
          );
        } else if (state is LoadedAllRoutineState) {
          if (state.routines.isEmpty) {
            return const Center(
              child: Text(
                  'Welcome to your Daily Routine! Please add some routines.'),
            );
          } else {
            return Center(
              child: _listOfRoutines(state.routines),
            );
          }
        } else {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        key: const Key('addRoutineButton'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<RoutineBloc>(context),
                  child: const AddRoutinePage())));
        },
        child: const Icon(Icons.add),
      ),
      bottomSheet: _bottomSheet(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _listOfRoutines(List<Routine> routines) {
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        var routine = routines[index];
        return ListTile(
          leading: Checkbox(
            key: const Key('checkButton'),
            value: routine.isCompleted,
            onChanged: (value) {
              if (value != null && value) {
                BlocProvider.of<RoutineBloc>(context)
                    .add(MarkCompleteRoutineEvent(routine.id));
              }
              else {
                BlocProvider.of<RoutineBloc>(context)
                    .add(MarkIncompleteRoutineEvent(routine.id));
              }
            },
          ),
          title: Text(routines[index].name),
          subtitle: Text(routines[index].time.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                key: const Key('deleteButton'),
                icon: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<RoutineBloc>(context)
                      .add(DeleteRoutineEvent(routine.id));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomSheet() {
    return BlocBuilder<CreditsBloc, CreditsState>(
        builder: (blocContext, state) {
      if (state is CreditsInitial) {
        return const Text('Loading...');
      } else if (state is CurrentAmountCreditsState) {
        return Text(
          'Credits: ${state.credits}',
          key: const Key('credits'),
        );
      } else {
        return const Text('Something went wrong.');
      }
    });
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Routines'),
        BottomNavigationBarItem(icon: Icon(Icons.chair), label: 'Rewards')
      ],
    );
  }
}
