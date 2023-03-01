import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import '../../src.dart';

class HomePage extends StatefulWidget with WindowListener {
  static const id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  final focusNode = FocusNode();

  @override
  void onWindowBlur() {
    // When the window loses focus, we want to remove focus from the child
    // widget so that it doesn't continue to receive keyboard events,
    // text fields don't continue to show a flashing cursor, etc.
    focusNode.requestFocus();
    super.onWindowBlur();
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CustomAppBar(),
      body: Focus(
        focusNode: focusNode,
        child: const NotesWidget(),
      ),
    );
  }
}

/// An AppBar with a title and a button to close the app.
// implements PreferredSizeWidget
class _CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<_CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<_CustomAppBar> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: AppBar(
        centerTitle: true,
        title: const _TitleWidget(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => AppWindow.instance.close(),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays the title of the selected note and allows the user
/// to edit it.
class _TitleWidget extends StatefulWidget {
  const _TitleWidget();

  @override
  State<_TitleWidget> createState() => __TitleWidgetState();
}

class __TitleWidgetState extends State<_TitleWidget> {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = context.read<NotesCubit>().state.selectedNote.title;

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesCubit, NotesState>(
      listenWhen: (previous, current) =>
          previous.selectedNote.title != current.selectedNote.title,
      listener: (context, state) {
        textController.text = state.selectedNote.title;
      },
      child: IntrinsicWidth(
        child: TextField(
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
        ),
      ),
    );
  }
}
