import 'package:devpilotai/domain/entities/generate_request.dart';
import 'package:devpilotai/domain/usecases/build_prompt.dart';
import 'package:devpilotai/domain/usecases/seed_templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('build prompt combines template and user input', () {
    final template = SeedTemplates().call().first;
    final prompt = BuildPrompt()(
      GenerateRequest(
        template: template,
        userInput: 'ค้นหารายชื่อหมอ พร้อม filter',
      ),
    );

    expect(prompt, contains(template.promptInstruction));
    expect(prompt, contains(template.outputFormat));
    expect(prompt, contains('ค้นหารายชื่อหมอ'));
  });
}
