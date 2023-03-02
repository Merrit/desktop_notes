import 'package:desktop_notes/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that displays a text field for taking notes.
class NotesWidget extends StatelessWidget {
  static const id = 'notes_widget';

  const NotesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return SizedBox(
      width: width,
      height: height,
      child: const _NotesView(),
    );
  }
}

class _NotesView extends StatefulWidget {
  const _NotesView();

  @override
  State<_NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<_NotesView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Row(
          children: [
            const ScrollableNavigationRail(),
            const SizedBox(width: 8),
            Expanded(
                child: NoteWidgetContents(
              key: ValueKey(state.selectedNote.id),
              note: state.selectedNote,
            )),
          ],
        );
      },
    );
  }
}

class NoteWidgetContents extends StatelessWidget {
  /// The selected note.
  final Note note;

  const NoteWidgetContents({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(
          child: NoteBody(),
        ),
        NoteActionsBar(),
      ],
    );
  }
}

class NoteBody extends StatefulWidget {
  const NoteBody({super.key});

  @override
  State<NoteBody> createState() => _NoteBodyState();
}

class _NoteBodyState extends State<NoteBody> {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = NotesCubit.instance.state.selectedNote.text;

    // When the focus node loses focus, update the note text.
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        final note = NotesCubit.instance.state.selectedNote;
        NotesCubit.instance.update(
          note.copyWith(text: textController.text),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          controller: textController,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'New note...',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
    );
  }
}

/// A row of icon buttons that will be displayed at the bottom of the note.
class NoteActionsBar extends StatelessWidget {
  const NoteActionsBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Change color',
          icon: const Icon(Icons.color_lens),
          onPressed: () async => await _showColorPickerDialog(context),
        ),
        IconButton(
          tooltip: 'Delete note',
          icon: const Icon(Icons.delete),
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Future<void> _showColorPickerDialog(BuildContext context) async {
    final result = await showDialog<Color>(
      context: context,
      builder: (context) => const ColorPickerDialog(),
    );

    if (result != null) {
      final note = NotesCubit.instance.state.selectedNote;
      NotesCubit.instance.update(note.copyWith(color: result.value));
    }
  }

  /// Display a dialog to confirm the deletion of the note.
  Future<void> _showDeleteDialog(BuildContext context) async {
    final note = NotesCubit.instance.state.selectedNote;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      NotesCubit.instance.delete(note);
    }
  }
}

/// A dialog that allows the user to select a color for the note.
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;

  @override
  void initState() {
    selectedColor = Color(NotesCubit.instance.state.selectedNote.color);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a color'),
      content: SingleChildScrollView(
        child: Wrap(
          children: [
            for (final color in Colors.primaries)
              _ColorPickerTile(
                color: color,
                selected: selectedColor == color,
                onTap: () => setState(() => selectedColor = color),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(selectedColor),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ColorPickerTile extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorPickerTile({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: selected ? const CircleBorder() : null,
      child: InkWell(
        onTap: onTap,
        child: const SizedBox(
          width: 48,
          height: 48,
        ),
      ),
    );
  }
}
