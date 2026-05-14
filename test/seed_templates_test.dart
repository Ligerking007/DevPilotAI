import 'package:devpilotai/domain/usecases/seed_templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seed templates include required defaults', () {
    final templates = SeedTemplates().call();

    expect(templates, hasLength(12));
    expect(
      templates.map((template) => template.name),
      containsAll([
        'Unit Test Generator',
        'Bug Risk Analyzer',
        'Code Review Checklist',
        'Requirement Clarifier',
        'Release Note Generator',
        'Test Case Generator',
        'API Spec Reviewer',
        'Pull Request Description Generator',
        'Error Log Analyzer',
        'Security Review Checklist',
        'Performance Bottleneck Analyzer',
        'Backend Unit Test Generator',
      ]),
    );
  });

  test('developer templates are grouped under developer category', () {
    final developerTemplates = SeedTemplates()
        .call()
        .where((template) => template.category == 'Developer')
        .toList();

    expect(developerTemplates, hasLength(6));
  });
}
