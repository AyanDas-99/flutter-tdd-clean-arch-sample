import 'package:clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    super.key,
  });

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final _numberController = TextEditingController();

  dispatchConcrete() {
    context.read<NumberTriviaBloc>().add(
          GetTriviaForConcreteNumber(_numberController.text),
        );
    _numberController.clear();
  }

  dispatchRandom() {
    context.read<NumberTriviaBloc>().add(
          GetTriviaForRandomNumber(),
        );

    _numberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _numberController,
            onSubmitted:(value)=> dispatchConcrete(),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter non negative whole numbers'),
            keyboardType: const TextInputType.numberWithOptions(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: dispatchConcrete,
                child: const Text(
                  "Get trivia",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll(Colors.green),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: dispatchRandom,
                child: const Text(
                  "Random",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
