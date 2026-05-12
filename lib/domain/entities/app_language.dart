enum AppLanguage {
  english('en'),
  thai('th');

  const AppLanguage(this.code);
  final String code;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
