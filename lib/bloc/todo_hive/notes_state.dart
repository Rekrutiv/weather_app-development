part of 'notes_bloc.dart';

class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<WeatherModelDB> notes;

  const NotesLoadedState(this.notes);

  @override
  List<Object?> get props => [notes];

  NotesLoadedState copyWith({
    List<WeatherModelDB>? notes,
  }) {
    return NotesLoadedState(
      notes ?? this.notes,
    );
  }
}
