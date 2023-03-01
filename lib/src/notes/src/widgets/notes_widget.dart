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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
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
