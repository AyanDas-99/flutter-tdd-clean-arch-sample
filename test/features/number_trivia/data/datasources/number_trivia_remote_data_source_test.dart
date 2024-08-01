import 'dart:convert';

import 'package:clean_arch/core/errors/exceptions.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateMocks([http.Client])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void httpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void httpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform GET request on a URL with number being the endpoint and application/json header',
        () async {
      // arrange
      httpClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTriviaModel when reseponse is 200(success)',
        () async {
      // arrange

      httpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert

      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when reseponse is not 200', () async {
      // arrange
      httpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert

      expect(() async => await call(tNumber), throwsA(isA<ServerException>()));
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform GET request on a URL with number being the endpoint and application/json header',
        () async {
      // arrange
      httpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTriviaModel when reseponse is 200(success)',
        () async {
      // arrange

      httpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert

      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when reseponse is not 200', () async {
      // arrange
      httpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert

      expect(() async => await call(), throwsA(isA<ServerException>()));
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });
  });
}
