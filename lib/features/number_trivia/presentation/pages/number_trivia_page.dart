import 'package:clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_arch/features/number_trivia/presentation/widgets/trivia_control.dart';
import 'package:clean_arch/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:clean_arch/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  return switch (state) {
                    Empty() => Center(
                        child: Text(
                          'Search for number',
                          style: Theme.of(context).textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Loading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    Loaded() => TriviaDisplay(
                        trivia: state.trivia,
                      ),
                    Error() => Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                  };
                },
              ),
            ),
            const SizedBox(height: 20),
            const TriviaControl()
          ],
        ),
      ),
    );
  }
}

