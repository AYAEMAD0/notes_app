import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'main.dart';
import 'notes_model.dart';


class NotesController extends ChangeNotifier {
  final Box<NoteModel> _box = Hive.box<NoteModel>(notesBoxName);

  List<NoteModel> get notes => _box.values.toList(growable: false);

  String? validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "You should add any content";
    }
    return null;
  }

  Future<void> addNote(String content) async {
    if (validateNote(content) != null) return;
    await _box.add(NoteModel(content: content.trim()));
    notifyListeners();
  }

  Future<void> updateNote(int index, String content) async {
    if (validateNote(content) != null) return;
    final updated = _box.getAt(index)!.copyWith(content: content.trim());
    await _box.putAt(index, updated);
    notifyListeners();
  }

  Future<void> deleteNote(int index) async {
    await _box.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _box.clear();
    notifyListeners();
  }
}