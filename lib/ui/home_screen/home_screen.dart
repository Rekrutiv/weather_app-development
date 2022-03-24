import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/location/location_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const id = '/home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedDay;
  String? selectedHour;
  List<Weather>? itemsFiltered;

  void _locationStateListener(context, state) {
    BlocProvider.of<WeatherBloc>(context).add(WeatherSetLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('loading_location_title'.tr()),
        // TODO: add dropdown menu
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<LocationBloc>(context).add(
                const DetermineLocationEvent(),
              );
            },
            icon: const Icon(
              Icons.my_location,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BlocConsumer<LocationBloc, LocationState>(
            listener: _locationStateListener,
            builder: (context, state) {
              if (state is LocationDeterminedState) {
                return Text(
                  state.location.name ?? 'undetermined_location_title'.tr(),
                );
              } else {
                return Text(
                  'loading_location_title'.tr(),
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoadingState) {
                  return _weatherLoadingStateWidget(context);
                } else if (state is WeatherFetchErrorState) {
                  return _weatherFetchErrorWidget(context);
                } else if (state is WeatherDaysForecastState) {
                  return _daysForecastListWidget(context, state);
                } else if (state is WeatherInitial) {
                  return const Center(
                    child: Text('WeatherInitial'),
                  );
                } else {
                  return const Center(
                    child: Text('unhandled state'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _daysForecastListWidget(
    BuildContext context,
    WeatherDaysForecastState state,
  ) {
    List<Weather> items = state.forecast;
    final itemDay = items
        .map<String>((row) => row.date?.day.toString() ?? '')
        .toSet()
        .toList(growable: false);
    final itemHour = items
        .map<String>((row) => row.date?.hour.toString() ?? '')
        .toSet()
        .toList(growable: false);
    if (selectedDay == null || selectedHour == null) {
      selectedDay = itemDay[0];
      selectedHour = itemHour[0];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('choose day '),
            SizedBox(
              height: 30,
              child: DropdownButton<String>(
                isExpanded: false,
                hint: const Text(
                  "day",
                ),
                value: selectedDay,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue!;
                    itemsFiltered = state.forecast
                        .where((e) => e.date?.day == int.parse(selectedDay!))
                        .toList();
                  });
                },
                items: itemDay.map((String i) {
                  return DropdownMenuItem<String>(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
              ),
            ),
            Text('choose hour '),
            SizedBox(
              height: 30,
              child: DropdownButton<String>(
                isExpanded: false,
                hint: const Text(
                  "hour",
                ),
                value: selectedHour,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHour = newValue ?? '';
                    itemsFiltered = state.forecast
                        .where((e) => e.date?.hour == int.parse(selectedHour!))
                        .toList();
                  });
                },
                items: itemHour.map((String i) {
                  return DropdownMenuItem<String>(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: itemsFiltered?.length ?? items.length,
            itemBuilder: (context, index) {
              final item =
                  itemsFiltered == null ? items[index] : itemsFiltered![index];
              final int? celsius = item.temperature?.celsius?.round();
              String title =
                  DateFormat('yyyy-MM-dd – kk:mm').format(item.date!);
              final weatherMainText =
                  item.weatherMain ?? 'weather_main_is_null'.tr();
              final temperatureText = celsius == null
                  ? 'unknown_temperature'.tr()
                  : '$celsius' + 'celsius_degree'.tr();

              return ListTile(
                title: Text(
                  title,
                ),
                subtitle: Text(
                  weatherMainText + ' ' + temperatureText,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Center _weatherLoadingStateWidget(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Center _weatherFetchErrorWidget(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: Text(
          'weather_fetch_button_text'.tr(),
        ),
        onPressed: () => BlocProvider.of<WeatherBloc>(context).add(
          WeatherShowDaysForecastEvent(
            DateTime.now(),
          ),
        ),
      ),
    );
  }
}
