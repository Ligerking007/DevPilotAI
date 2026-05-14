import 'package:devpilotai/domain/entities/generate_request.dart';

class BuildPrompt {
  String call(GenerateRequest request) {
    final template = request.template;
    // Centralized prompt composition keeps preview, tests, and API generation
    // aligned when the request shape changes.
    return '''
${template.promptInstruction}

Language preference: ${template.languagePreference}
Expected output format:
${template.outputFormat}

User input:
${request.userInput}
'''
        .trim();
  }
}
