import 'package:desktop_notes/src/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

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

    return BlocProvider(
      create: (context) => NotesCubit(),
      lazy: false,
      child: SizedBox(
        width: width,
        height: height,
        child: const _NotesView(),
      ),
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

/// A scrollable version of a [NavigationRail].
class ScrollableNavigationRail extends StatefulWidget {
  const ScrollableNavigationRail({super.key});

  @override
  State<ScrollableNavigationRail> createState() =>
      _ScrollableNavigationRailState();
}

class _ScrollableNavigationRailState extends State<ScrollableNavigationRail> {
  bool expanded = false;

  @override
  void initState() {
    checkExpandedPreviously();
    super.initState();
  }

  /// Get the saved state of the navigation rail.
  Future<void> checkExpandedPreviously() async {
    final bool? value = await StorageRepository.instance.get('navExpanded');
    if (value != null) {
      setState(() {
        expanded = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              NotesCubit.instance.create();
            },
          ),
          IconButton(
            icon: (expanded)
                ? const Icon(Icons.arrow_back_ios_rounded)
                : const Icon(Icons.arrow_forward_ios_rounded),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });

              StorageRepository.instance.save(
                key: 'navExpanded',
                value: expanded,
              );
            },
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: expanded ? 256 : 64,
                  height: constraints.maxHeight,
                  child: BlocBuilder<NotesCubit, NotesState>(
                    builder: (context, state) {
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...state.notes.map(
                            (Note note) {
                              String titleText;
                              if (note.title == '') {
                                titleText = 'Title';
                              } else {
                                titleText = note.title;
                              }

                              Widget? titleWidget;
                              if (expanded) {
                                titleWidget = Text(
                                  titleText,
                                  style: (titleText == 'Title')
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.grey,
                                          )
                                      : null,
                                );
                              }

                              return ListTile(
                                leading: const Icon(Icons.notes),
                                title: titleWidget,
                                selected: note.id == state.selectedNote.id,
                                onTap: () {
                                  NotesCubit.instance.select(note);
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
        NoteHeader(),
        Expanded(
          child: NoteBody(),
        ),
      ],
    );
  }
}

class NoteHeader extends StatefulWidget {
  const NoteHeader({super.key});

  @override
  State<NoteHeader> createState() => _NoteHeaderState();
}

class _NoteHeaderState extends State<NoteHeader> {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = NotesCubit.instance.state.selectedNote.title;

    // When the focus node loses focus, update the note title.
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        final note = NotesCubit.instance.state.selectedNote;
        NotesCubit.instance.update(
          note.copyWith(title: textController.text),
        );
      }
    });

    super.initState();
  }

  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      cursor: (hovered) ? SystemMouseCursors.move : MouseCursor.defer,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (_) => windowManager.startDragging(),
        onTapUp: (_) => AppWindow.instance.saveWindowSize(),
        onDoubleTap: () async {
          bool isMaximized = await windowManager.isMaximized();
          if (!isMaximized) {
            windowManager.maximize();
          } else {
            windowManager.unmaximize();
          }
        },
        child: SizedBox(
          height: 56,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IntrinsicWidth(
                child: BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, state) {
                    return TextField(
                      focusNode: focusNode,
                      controller: textController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              // Reserved space to ensure there is room where the window
              // can be grabbed and moved, and the title doesn't overlap.
              const SizedBox(width: 64),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => AppWindow.instance.close(),
              ),
            ],
          ),
        ),
      ),
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
        return Column(
          children: [
            Expanded(
              child: TextField(
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
              ),
            ),
            const NoteActionsBar(),
          ],
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
