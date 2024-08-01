import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';

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