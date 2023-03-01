import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/src.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.themeData,
          routes: {
            NotesWidget.id: (context) => const NotesWidget(),
            WidgetWrapper.id: (context) => const WidgetWrapper(),
          },
          home: const WidgetWrapper(),
        );
      },
    );
  }
}
