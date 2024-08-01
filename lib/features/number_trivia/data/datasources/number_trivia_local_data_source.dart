import 'dart:convert';

import 'package:clean_arch/core/errors/exceptions.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  ///Gets the cached [NumberTriviaModel] which was gotten last time
  ///the user had an active internet connection
  ///
  ///Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  ///Caches the most recently loaded [NumberTriviaModel] from network
  ///
  ///Throws [CacheException] if caching fails
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString == null) {
      throw CacheException();
    } else {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString!)));
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
