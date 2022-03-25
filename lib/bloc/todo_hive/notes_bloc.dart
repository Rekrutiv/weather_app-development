import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../boxes.dart';
import '../../models/db/weather_model_db.dart';
import '../../repository/todo_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository _noteRepository;
  var box = Boxes.getTransactions();
  // TODO: Move each event handler body to a standalone function
  NotesBloc(this._noteRepository) : super(NotesInitialState()) {
    on<InitRepositoryWithNotesEvent>(((event, emit) async {
        emit(NotesLoadedState(box.values.toList().cast<WeatherModelDB>()));
    }));

    on<AddNoteEvent>(((event, emit) async {
      await _noteRepository.addNote(WeatherModelDB(

      )..weatherMain = event.weatherMain
        ..date = event.date
        ..celsius = event.celsius);
      emit(NotesLoadedState(_noteRepository.notes));
    }));

    on<DeleteNoteEvent>(((event, emit) async {
      await _noteRepository.removeNote(event.note);
      emit(NotesLoadedState(_noteRepository.notes));
    }));




  }
}
