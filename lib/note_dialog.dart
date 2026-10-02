import 'package:flutter/material.dart';

class NoteDialog extends StatefulWidget {
  final String title;
  final String actionText;
  final String initialText;
  final String? Function(String?) validator;
  final void Function(String text) onSubmit;

  const NoteDialog({
    super.key,
    required this.title,
    required this.actionText,
    required this.validator,
    required this.onSubmit,
    this.initialText = '',
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_textController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text(widget.title),
        content: TextFormField(
          controller: _textController,
          validator: widget.validator,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _submit,
            child: Text(widget.actionText),
          ),
        ],
      ),
    );
  }
}