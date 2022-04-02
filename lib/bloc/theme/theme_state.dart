part of 'theme_cubit.dart';

class ThemeState {
  final bool isDarkThemeOn;
  ThemeData? theme;
  ThemeState({required this.isDarkThemeOn}) {
    if (isDarkThemeOn) {
      theme = appThemeData[AppTheme.DarkAppTheme];
    } else {
      theme = appThemeData[AppTheme.LightAppTheme];
    }
  }

  ThemeState copyWith({  bool? changeState}) {
    return ThemeState(isDarkThemeOn: changeState ?? isDarkThemeOn);
  }
}
