import 'package:devpilotai/domain/entities/ai_template.dart';

class GenerateRequest {
  const GenerateRequest({
    required this.template,
    required this.userInput,
  });

  final AiTemplate template;
  final String userInput;
}
