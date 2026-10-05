import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../notes_model.dart';
import 'note_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesLoading());

  final Box<NoteModel> _box = Hive.box<NoteModel>(notesBoxName);

  String? validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "You should add any content";
    }
    return null;
  }

  void loadNotes() {
    try {
      final notes = _box.values.toList();
      emit(notes.isEmpty ? NotesEmpty() : NotesSuccess(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(String text) async {
    await _box.add(NoteModel(content: text.trim()));
    loadNotes();
  }

  Future<void> updateNote(int index, String text) async {
    await _box.putAt(index, NoteModel(content: text.trim()));
    loadNotes();
  }

  Future<void> deleteNote(int index) async {
    await _box.deleteAt(index);
    loadNotes();
  }

  Future<void> clearAll() async {
    await _box.clear();
    loadNotes();
  }
}