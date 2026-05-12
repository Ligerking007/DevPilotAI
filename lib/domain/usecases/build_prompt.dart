import 'package:devpilotai/domain/entities/generate_request.dart';

class BuildPrompt {
  String call(GenerateRequest request) {
    final template = request.template;
    return '''
${template.promptInstruction}

Language preference: ${template.languagePreference}
Expected output format:
${template.outputFormat}

User input:
${request.userInput}
'''.trim();
  }
}
