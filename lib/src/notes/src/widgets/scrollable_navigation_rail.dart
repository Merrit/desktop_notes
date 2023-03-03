import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../src.dart';

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
    final Widget divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: expanded ? 256 : 64,
        child: const Divider(
          height: 1,
          thickness: 1,
          indent: 8,
          endIndent: 8,
        ),
      ),
    );

    return Card(
      child: Column(
        crossAxisAlignment: (expanded) //
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add note',
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              NotesCubit.instance.create();
            },
          ),
          IconButton(
            icon: (expanded)
                ? const Icon(Icons.arrow_back_ios_rounded)
                : const Icon(Icons.arrow_forward_ios_rounded),
            tooltip: (expanded) ? 'Collapse' : 'Expand',
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
          divider,
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: expanded ? 256 : 64,
                  height: constraints.maxHeight,
                  child: BlocBuilder<NotesCubit, NotesState>(
                    builder: (context, state) {
                      return ReorderableListView(
                        padding: EdgeInsets.zero,
                        buildDefaultDragHandles: false,
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          NotesCubit.instance.reorder(oldIndex, newIndex);
                        },
                        children: [
                          ...state.notes.map(
                            (Note note) {
                              return _NoteSelectionTile(
                                key: ValueKey(note.id),
                                expanded: expanded,
                                note: note,
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

class _NoteSelectionTile extends StatefulWidget {
  final bool expanded;
  final Note note;

  const _NoteSelectionTile({
    Key? key,
    required this.expanded,
    required this.note,
  }) : super(key: key);

  @override
  State<_NoteSelectionTile> createState() => _NoteSelectionTileState();
}

class _NoteSelectionTileState extends State<_NoteSelectionTile> {
  /// Whether the mouse is hovering over the ListTile.
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => hovered = true),
      onExit: (event) => setState(() => hovered = false),
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          final Note note = state //
              .notes
              .firstWhere((note) => note.id == widget.note.id);

          final Widget colorSquare = Icon(
            Icons.square_rounded,
            color: Color(note.color),
            size: 32,
          );

          String titleText;
          if (note.title == '') {
            titleText = 'Title';
          } else {
            titleText = note.title;
          }

          Widget? titleWidget;
          if (widget.expanded) {
            titleWidget = Text(
              titleText,
              style: (titleText == 'Title')
                  ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey,
                      )
                  : null,
            );
          } else {
            titleWidget = colorSquare;
          }

          /// The trailing widget is a ReorderableDragStartListener when
          /// expanded, and null when collapsed.
          ///
          /// The drag handle is only shown when the ListTile
          /// is hovered over with the mouse.
          Widget? trailing;
          if (widget.expanded && hovered) {
            trailing = ReorderableDragStartListener(
              index: note.index,
              // index: NotesCubit.instance.state.notes.indexOf(note),
              child: const Icon(Icons.drag_handle),
            );
          }

          return ListTile(
            leading: (widget.expanded) ? colorSquare : null,
            title: titleWidget,
            selected: note.id == state.selectedNote.id,
            onTap: () => NotesCubit.instance.select(note),
            trailing: trailing,
          );
        },
      ),
    );
  }
}
