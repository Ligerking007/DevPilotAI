import 'package:devpilotai/data/datasources/openai_api_service.dart';
import 'package:devpilotai/domain/entities/ai_provider_settings.dart';
import 'package:devpilotai/domain/entities/generate_request.dart';
import 'package:devpilotai/domain/repositories/ai_repository.dart';
import 'package:devpilotai/domain/usecases/build_prompt.dart';

class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl(this._service, {BuildPrompt? buildPrompt})
      : _buildPrompt = buildPrompt ?? BuildPrompt();

  final OpenAiApiService _service;
  final BuildPrompt _buildPrompt;

  @override
  Future<String> generate({
    required GenerateRequest request,
    required AiProviderSettings settings,
  }) {
    // The API layer receives a stable two-message shape: template instruction as
    // system context, and the composed request as user content.
    return _service.generate(
      systemPrompt: request.template.promptInstruction,
      userInput: _buildPrompt(request),
      settings: settings,
    );
  }
}
