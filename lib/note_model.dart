class NoteModel {
  final String content;

  const NoteModel({required this.content});

  NoteModel copyWith({String? content}) {
    return NoteModel(content: content ?? this.content);
  }
}