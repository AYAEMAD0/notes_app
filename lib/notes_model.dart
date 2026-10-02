import 'package:hive/hive.dart';

class NoteModel {
  final String content;

  const NoteModel({required this.content});

  NoteModel copyWith({String? content}) {
    return NoteModel(content: content ?? this.content);
  }
}

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader) {
    return NoteModel(content: reader.readString());
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer.writeString(obj.content);
  }
}