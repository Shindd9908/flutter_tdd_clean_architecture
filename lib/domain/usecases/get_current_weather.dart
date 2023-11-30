import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/weather_entity.dart';
import 'package:flutter_tdd_clean_architecture/domain/repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository weatherRepository;

  GetCurrentWeatherUseCase({required this.weatherRepository});

  Future<Either<Failure, WeatherEntity>> execute({required String cityName}) {
    return weatherRepository.getCurrentWeather(cityName: cityName);
  }
}
