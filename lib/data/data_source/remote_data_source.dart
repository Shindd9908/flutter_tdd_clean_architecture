import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/core/constants/constants.dart';
import 'package:flutter_tdd_clean_architecture/core/error/exception.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather({required String cityName});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather({required String cityName}) async {
    final response = await client.get(Uri.parse(Urls.currentWeatherByName(cityName)));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
