import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/weather_entity.dart';
import 'package:flutter_tdd_clean_architecture/domain/usecases/get_current_weather.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  WeatherBloc(this._getCurrentWeatherUseCase) : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<OnCityChanged>(
      (event, emit) async {
        emit(WeatherLoading());
        final result = await _getCurrentWeatherUseCase.execute(cityName: event.cityName);
        result.fold(
          (l) => emit(WeatherLoadFailure(message: l.message)),
          (r) => emit(WeatherLoaded(result: r)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
