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
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...state.notes.map(
                            (Note note) {
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
                              } else {
                                titleWidget = colorSquare;
                              }

                              return ListTile(
                                leading: (expanded) ? colorSquare : null,
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
