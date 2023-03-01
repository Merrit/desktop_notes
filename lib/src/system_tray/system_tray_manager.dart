import 'dart:io';

import 'package:tray_manager/tray_manager.dart';

import '../window/app_window.dart';

class SystemTrayManager {
  const SystemTrayManager._();

  static Future<SystemTrayManager> init() async {
    String iconPath =
        Platform.isWindows ? 'assets/icons/icon.ico' : 'assets/icons/icon.png';

    await trayManager.setIcon(iconPath);

    final Menu menu = Menu(
      items: [
        MenuItem(
          label: 'Reset position',
          onClick: (menuItem) => AppWindow.instance.resetPosition(),
        ),
        MenuItem(
          label: 'Exit',
          onClick: (menuItem) => AppWindow.instance.close(),
        ),
      ],
    );

    await trayManager.setContextMenu(menu);

    return const SystemTrayManager._();
  }
}
