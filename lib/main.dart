import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'src/src.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await LoggingManager.initialize(verbose: args.contains('--verbose'));

  // Handle platform errors not caught by Flutter.
  PlatformDispatcher.instance.onError = (error, stack) {
    log.e('Uncaught platform error', error, stack);
    return true;
  };

  await StorageRepository.initialize(Hive);
  await AppWindow.create();

  final themeCubit = await ThemeCubit.init(StorageRepository.instance);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesCubit()),
        BlocProvider.value(value: themeCubit),
      ],
      child: const App(),
    ),
  );

  await SystemTrayManager.init();
}
