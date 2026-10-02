import 'package:flutter/foundation.dart';
import 'package:notes/note_model.dart';

class NotesController extends ChangeNotifier {
  final List<NoteModel> _notes = [];

  List<NoteModel> get notes => List.unmodifiable(_notes);

  String? validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "You should add any content";
    }
    return null;
  }

  void addNote(String content) {
    if (validateNote(content) != null) return;
    _notes.add(NoteModel(content: content.trim()));
    notifyListeners();
  }

  void updateNote(int index, String content) {
    if (validateNote(content) != null) return;
    _notes[index] = _notes[index].copyWith(content: content.trim());
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _notes.clear();
    notifyListeners();
  }
}