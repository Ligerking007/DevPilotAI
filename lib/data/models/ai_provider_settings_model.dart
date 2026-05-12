import 'package:devpilotai/core/config/app_config.dart';
import 'package:devpilotai/domain/entities/ai_provider_settings.dart';

class AiProviderSettingsModel extends AiProviderSettings {
  const AiProviderSettingsModel({
    required super.provider,
    required super.apiKey,
    required super.baseUrl,
    required super.model,
  });

  factory AiProviderSettingsModel.defaults() {
    return const AiProviderSettingsModel(
      provider: 'OpenAI',
      apiKey: AppConfig.openAiApiKey,
      baseUrl: AppConfig.openAiBaseUrl,
      model: AppConfig.openAiModel,
    );
  }

  factory AiProviderSettingsModel.fromEntity(AiProviderSettings entity) {
    return AiProviderSettingsModel(
      provider: entity.provider,
      apiKey: entity.apiKey,
      baseUrl: entity.baseUrl,
      model: entity.model,
    );
  }

  factory AiProviderSettingsModel.fromJson(Map<String, dynamic> json) {
    return AiProviderSettingsModel(
      provider: json['provider'] as String? ?? 'OpenAI',
      apiKey: json['apiKey'] as String? ?? AppConfig.openAiApiKey,
      baseUrl: json['baseUrl'] as String? ?? AppConfig.openAiBaseUrl,
      model: json['model'] as String? ?? AppConfig.openAiModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'apiKey': apiKey,
      'baseUrl': baseUrl,
      'model': model,
    };
  }
}
