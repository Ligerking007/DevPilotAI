import 'package:devpilotai/domain/usecases/seed_templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seed templates include required defaults', () {
    final templates = SeedTemplates().call();

    expect(templates, hasLength(6));
    expect(
      templates.map((template) => template.name),
      containsAll([
        'Unit Test Generator',
        'Bug Risk Analyzer',
        'Code Review Checklist',
        'Requirement Clarifier',
        'Release Note Generator',
        'Test Case Generator',
      ]),
    );
  });
}
