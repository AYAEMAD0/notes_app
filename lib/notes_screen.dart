import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/note_cubit.dart';
import 'cubit/note_state.dart';
import 'note_dialog.dart';
import 'notes_model.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  static const Color backgroundColor = Color(0xFFE0E0E0);
  static const Color titleColor = Colors.black;

  void _showAddDialog(BuildContext context) {
    final cubit = context.read<NotesCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NoteDialog(
        title: 'Add Note',
        actionText: 'Add',
        validator: cubit.validateNote,
        onSubmit: cubit.addNote,
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, int index, NoteModel note) {
    final cubit = context.read<NotesCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NoteDialog(
        title: 'Update Note',
        actionText: 'Update',
        initialText: note.content,
        validator: cubit.validateNote,
        onSubmit: (text) => cubit.updateNote(index, text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotesCubit>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: cubit.clearAll,
              child: const Text(
                "Clear All",
                style: TextStyle(color: titleColor, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notes",
              style: TextStyle(fontSize: 48, color: titleColor),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, state) {
                  if (state is NotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NotesEmpty) {
                    return const _StatusView(
                      icon: Icons.note_add_outlined,
                      message: 'No notes yet.\nTap + to add your first note.',
                    );
                  }

                  if (state is NotesError) {
                    return _StatusView(
                      icon: Icons.error_outline,
                      message: state.message,
                      color: Colors.red,
                      onRetry: cubit.loadNotes,
                    );
                  }

                  if (state is NotesSuccess) {
                    final notes = state.notes;
                    return ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => Stack(
                        children: [
                          InkWell(
                            onTap: () =>
                                _showUpdateDialog(context, index, notes[index]),
                            child: Container(
                              height: 100,
                              width: 380,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  right: 15,
                                  top: 12,
                                ),
                                child:
                                Center(child: Text(notes[index].content)),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => cubit.deleteNote(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

/// Reusable view for the Empty and Error states.
class _StatusView extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? color;
  final VoidCallback? onRetry;

  const _StatusView({
    required this.icon,
    required this.message,
    this.color,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: color ?? Colors.black45),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}