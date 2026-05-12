class AppConfig {
  static const openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const openAiBaseUrl = String.fromEnvironment(
    'OPENAI_BASE_URL',
    defaultValue: 'https://api.openai.com/v1',
  );
  static const openAiModel = String.fromEnvironment(
    'OPENAI_MODEL',
    defaultValue: 'gpt-4o-mini',
  );
}
