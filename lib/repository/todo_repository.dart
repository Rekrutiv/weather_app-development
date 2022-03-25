import 'package:hive_flutter/hive_flutter.dart';

import '../models/db/weather_model_db.dart';

class NoteRepository {
  final Box<WeatherModelDB> _notes;

  NoteRepository(this._notes);

  List<WeatherModelDB> get notes => [..._notes.values.toList()];

  Future<void> addNote(final WeatherModelDB note) async {

    await _notes.add(note);
  }

  Future<void> removeNote(final WeatherModelDB note) async {
    final noteToRemove = _notes.values.firstWhere((element) => element == note);
    await noteToRemove.delete();
  }

  Future<void> updateNote(final WeatherModelDB oldNote, final WeatherModelDB newNote) async {
    final noteToUpdate =
        _notes.values.firstWhere((element) => element == oldNote);
    final index = noteToUpdate.key as int;
    await _notes.put(index, newNote);
  }

  bool get isEmpty => _notes.isEmpty;
}
