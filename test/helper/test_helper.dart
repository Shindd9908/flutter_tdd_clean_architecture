import 'package:flutter_tdd_clean_architecture/data/data_source/remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/domain/repositories/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    WeatherRepository,
    WeatherRemoteDataSource,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
