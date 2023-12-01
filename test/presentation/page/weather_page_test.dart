import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecture/domain/entities/weather_entity.dart';
import 'package:flutter_tdd_clean_architecture/presentation/bloc/weather_bloc.dart';
import 'package:flutter_tdd_clean_architecture/presentation/page/weather_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState> implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>(
      create: (context) => mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const testWeather = WeatherEntity(
    cityName: 'New York',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  testWidgets("Test text field should trigger state to change form empty to loading", (widgetTester) async {
    //arrange
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

    await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));
    var textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await widgetTester.enterText(textField, "New York");
    await widgetTester.pump();
    expect(find.text("New York"), findsOneWidget);
  });

  testWidgets(
    'should show progress indicator when state is loading',
    (widgetTester) async {
      //arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

      //act
      await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));

      //assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should show widget contain weather data when state is weather loaded',
    (widgetTester) async {
      //arrange
      when(() => mockWeatherBloc.state).thenReturn(const WeatherLoaded(result: testWeather));

      //act
      await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));


      //assert
      expect(find.byKey(const Key('weather_data')), findsOneWidget);
    },
  );
}
