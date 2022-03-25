part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class InitRepositoryWithNotesEvent extends NotesEvent {
  @override
  List<Object> get props => [];
}

class AddNoteEvent extends NotesEvent {
  final String weatherMain;

  final DateTime date;

  final int celsius;

  const AddNoteEvent(this.weatherMain, this.date,this.celsius);

  @override
  List<Object> get props => [weatherMain, date, celsius];
}

class DeleteNoteEvent extends NotesEvent {
  final WeatherModelDB note;

  const DeleteNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final WeatherModelDB noteToUpdate;
  final String title;
  final String description;

  const UpdateNoteEvent(this.noteToUpdate, this.title, this.description);

  @override
  List<Object> get props => [title, description];
}

class ToggleNoteCompletition extends NotesEvent {
  final WeatherModelDB note;

  const ToggleNoteCompletition(this.note);

  @override
  List<Object> get props => [note];
}
