import 'package:flutter/material.dart';
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
      body: Focus(
        focusNode: focusNode,
        child: const NotesWidget(),
      ),
    );
  }
}
