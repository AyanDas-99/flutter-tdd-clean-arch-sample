import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arch/core/errors/failures.dart';
import 'package:clean_arch/core/usecases/usecase.dart';
import 'package:clean_arch/core/util/input_converter.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('bloc initial state should be empty', () {
    expect(bloc.state, Empty());
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void inputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    void mockGetConcreteSuccess() =>
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => Right(tNumberTrivia));

    test(
        'should call the InputConverter to validate and convert string to unsigned int',
        () async {
      // arrange
      inputConverterSuccess();
      mockGetConcreteSuccess();

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest(
      'should emit [Error] when the input is invalid',
      build: () => bloc,
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        mockGetConcreteSuccess();
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [equals(const Error(message: INVALID_INPUT_FAILURE_MSG))],
    );

    blocTest(
      'should get data from concrete usecase',
      build: () => bloc,
      setUp: () {
        inputConverterSuccess();
        mockGetConcreteSuccess();
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      verify: (bloc) {
        mockGetConcreteNumberTrivia(Params(number: tNumberParsed));
      },
    );

    blocTest(
      'should emit [Loading, Loaded] when data is successfully fetched',
      build: () => bloc,
      setUp: () {
        inputConverterSuccess();
        mockGetConcreteSuccess();
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [Loading(), Loaded(trivia: tNumberTrivia)],
    );

    blocTest(
      'should emit [Loading, Error] when data fetching fails',
      build: () => bloc,
      setUp: () {
        inputConverterSuccess();
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => const Left(ServerFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        const Error(message: SERVER_FAILURE_MSG),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with proper message when data fetching fails',
      build: () => bloc,
      setUp: () {
        inputConverterSuccess();
        when(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)))
            .thenAnswer((_) async => const Left(CacheFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MSG),
      ],
    );
  });

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void mockGetRandomSuccess() => when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    blocTest(
      'should get data from random usecase',
      build: () => bloc,
      setUp: () {
        mockGetRandomSuccess();
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      verify: (bloc) {
        mockGetRandomNumberTrivia(NoParams());
      },
    );

    blocTest(
      'should emit [Loading, Loaded] when data is successfully fetched',
      build: () => bloc,
      setUp: () {
        mockGetRandomSuccess();
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [Loading(), Loaded(trivia: tNumberTrivia)],
    );

    blocTest(
      'should emit [Loading, Error] when data fetching fails',
      build: () => bloc,
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => const Left(ServerFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        Loading(),
        const Error(message: SERVER_FAILURE_MSG),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with proper message when data fetching fails',
      build: () => bloc,
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => const Left(CacheFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MSG),
      ],
    );
  });
}
