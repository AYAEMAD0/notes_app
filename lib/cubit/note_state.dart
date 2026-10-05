import '../notes_model.dart';

abstract class NotesState {}

class NotesLoading extends NotesState {}

class NotesEmpty extends NotesState {}

class NotesSuccess extends NotesState {
  final List<NoteModel> notes;
  NotesSuccess(this.notes);
}

class NotesError extends NotesState {
  final String message;
  NotesError(this.message);
}