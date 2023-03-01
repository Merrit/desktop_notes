part of 'theme_cubit.dart';

@immutable
class ThemeState {
  final AppTheme appTheme;

  const ThemeState({
    required this.appTheme,
  });

  ThemeData get themeData {
    switch (appTheme) {
      case AppTheme.dark:
        return darkTheme;
      case AppTheme.light:
        return lightTheme;
    }
  }

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appTheme': appTheme.toString(),
    };
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(
      appTheme: AppTheme.values.firstWhere(
        (e) => e.toString() == map['appTheme'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeState.fromJson(String source) =>
      ThemeState.fromMap(json.decode(source));

  @override
  String toString() => 'ThemeState(appTheme: $appTheme)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeState && other.appTheme == appTheme;
  }

  @override
  int get hashCode => appTheme.hashCode;
}
