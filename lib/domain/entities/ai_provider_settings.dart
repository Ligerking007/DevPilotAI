class AiProviderSettings {
  const AiProviderSettings({
    required this.provider,
    required this.apiKey,
    required this.baseUrl,
    required this.model,
  });

  final String provider;
  final String apiKey;
  final String baseUrl;
  final String model;

  AiProviderSettings copyWith({
    String? provider,
    String? apiKey,
    String? baseUrl,
    String? model,
  }) {
    return AiProviderSettings(
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      model: model ?? this.model,
    );
  }
}
