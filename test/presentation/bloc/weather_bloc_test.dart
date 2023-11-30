import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/failure.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/weather_entity.dart';
import 'package:flutter_tdd_clean_architecture/presentation/bloc/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
  });

  const testWeather = WeatherEntity(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  const testCityName = 'New York';

  test("initial state should be empty", () {
    expect(weatherBloc.state, WeatherInitial());
  });

  blocTest<WeatherBloc, WeatherState>('should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(mockGetCurrentWeatherUseCase.execute(cityName: testCityName)).thenAnswer((invocation) async => const Right(testWeather));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const OnCityChanged(cityName: testCityName)),
      wait: const Duration(milliseconds: 500),
      expect: () => [WeatherLoading(), const WeatherLoaded(result: testWeather)]);

  blocTest<WeatherBloc, WeatherState>('should emit [WeatherLoading, WeatherLoadFailure] when get data is unsuccessful',
      build: () {
        when(mockGetCurrentWeatherUseCase.execute(cityName: testCityName)).thenAnswer((_) async => const Left(ServerFailure("Server failure")));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const OnCityChanged(cityName: testCityName)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            WeatherLoading(),
            const WeatherLoadFailure(message: "Server failure"),
          ]);
}
