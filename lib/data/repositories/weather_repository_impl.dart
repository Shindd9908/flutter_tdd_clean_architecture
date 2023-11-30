import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/exception.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/data/data_source/remote_data_source.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/weather_entity.dart';
import 'package:flutter_tdd_clean_architecture/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;

  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather({required String cityName}) async {
    try {
      final result = await weatherRemoteDataSource.getCurrentWeather(cityName: cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure("An error has occurred"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    }
  }
}
