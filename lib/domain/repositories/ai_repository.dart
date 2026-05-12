import 'package:devpilotai/domain/entities/ai_provider_settings.dart';
import 'package:devpilotai/domain/entities/generate_request.dart';

abstract class AiRepository {
  Future<String> generate({
    required GenerateRequest request,
    required AiProviderSettings settings,
  });
}
