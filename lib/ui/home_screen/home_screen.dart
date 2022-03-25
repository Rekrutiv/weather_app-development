import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/location/location_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';

import '../../bloc/todo_hive/notes_bloc.dart';
import '../../models/db/weather_model_db.dart';

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
  List<WeatherModelDB>? itemsFilteredDB;

  void _locationStateListener(context, state) {
    BlocProvider.of<WeatherBloc>(context).add(WeatherSetLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('loading_location_title'.tr()),
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
                    } else if (state is WeatherDaysForecastState) {
                      return _daysForecastListWidget(context, state.forecast);
                    } else if (state is WeatherInitial) {
                      return context.read<NotesBloc>().box.values.isNotEmpty
                          ? _daysForecastDB(context,
                              context.read<NotesBloc>().box.values.toList())
                          : Container();
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
      },
    );
  }

  Column _daysForecastListWidget(
    BuildContext context,
    List<Weather> weather,
  ) {
    List<Weather> items = weather;
    context.read<NotesBloc>().box.clear();
    for (var element in items) {
      context.read<NotesBloc>().add(AddNoteEvent(
            element.weatherMain ?? '',
            element.date ?? DateTime.now(),
            element.temperature?.celsius?.round() ?? -1,
          ));
    }
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
            const Text('choose day '),
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
                    itemsFiltered = weather
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
            const Text('choose hour '),
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
                    itemsFiltered = weather
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

  Column _daysForecastDB(
    BuildContext context,
    List<WeatherModelDB> weather,
  ) {
    List<WeatherModelDB> itemsDB = weather;
    print(itemsDB.length);
    final itemDay = itemsDB
        .map<String>((row) => row.date?.day.toString() ?? '')
        .toSet()
        .toList(growable: false);
    final itemHour = itemsDB
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
            const Text('choose day '),
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
                    itemsFilteredDB = weather
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
            const Text('choose hour '),
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
                    itemsFilteredDB = weather
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
            itemCount: itemsFilteredDB?.length ?? itemsDB.length,
            itemBuilder: (context, index) {
              final item = itemsFiltered == null
                  ? itemsDB[index]
                  : itemsFilteredDB![index];
              String title =
                  DateFormat('yyyy-MM-dd – kk:mm').format(item.date!);
              final weatherMainText = item.weatherMain;
              final temperatureText =
                  '${item.celsius.round()}' + 'celsius_degree'.tr();

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

  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }
}
