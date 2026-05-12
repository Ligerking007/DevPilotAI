import 'package:devpilotai/domain/entities/ai_template.dart';

class SeedTemplates {
  List<AiTemplate> call() {
    final now = DateTime(2026, 1, 1);
    return [
      _template(
        id: 'unit-test-generator',
        name: 'Unit Test Generator',
        description: 'Generate unit test topics, edge cases, and impact.',
        category: 'Testing',
        promptInstruction: 'You are a senior software developer. Analyze the '
            'user requirement and generate unit test scenarios, edge cases, '
            'validation cases, impact, and possible defects.',
        outputFormat: 'Return clear bullet points with Functional test cases, '
            'Filter test cases, Validation cases, Edge cases, Possible bugs, '
            'Suggested improvements, and Impact.',
        now: now,
      ),
      _template(
        id: 'bug-risk-analyzer',
        name: 'Bug Risk Analyzer',
        description: 'Identify likely defects, risk areas, and regressions.',
        category: 'Quality',
        promptInstruction: 'You are a QA lead. Analyze the input for bug '
            'risks, regression risks, ambiguous behavior, and missing '
            'validations.',
        outputFormat: 'Group the answer by Critical risks, Medium risks, '
            'Low risks, Missing information, and Recommended checks.',
        now: now,
      ),
      _template(
        id: 'code-review-checklist',
        name: 'Code Review Checklist',
        description: 'Create a focused review checklist.',
        category: 'Engineering',
        promptInstruction: 'You are a pragmatic senior engineer. Create a '
            'code review checklist for the provided change or requirement.',
        outputFormat: 'Return checklist sections for Correctness, '
            'Maintainability, Security, Performance, Tests, and Release '
            'safety.',
        now: now,
      ),
      _template(
        id: 'requirement-clarifier',
        name: 'Requirement Clarifier',
        description: 'Find gaps and questions in requirements.',
        category: 'Product',
        promptInstruction: 'You are a product-minded business analyst. '
            'Clarify the requirement and identify missing decisions.',
        outputFormat: 'Return Summary, Assumptions, Clarifying questions, '
            'Acceptance criteria, and Edge cases.',
        now: now,
      ),
      _template(
        id: 'release-note-generator',
        name: 'Release Note Generator',
        description: 'Generate concise release notes.',
        category: 'Release',
        promptInstruction: 'You are a release manager. Convert the input into '
            'clear release notes for users and internal teams.',
        outputFormat: 'Return User-facing notes, Technical notes, Known '
            'limitations, and Rollback considerations.',
        now: now,
      ),
      _template(
        id: 'test-case-generator',
        name: 'Test Case Generator',
        description: 'Generate structured manual test cases.',
        category: 'Testing',
        promptInstruction:
            'You are a QA engineer. Generate structured manual test cases from the requirement.',
        outputFormat: 'Return test cases with ID, Title, Preconditions, '
            'Steps, Expected result, Priority, and Notes.',
        now: now,
      ),
    ];
  }

  AiTemplate _template({
    required String id,
    required String name,
    required String description,
    required String category,
    required String promptInstruction,
    required String outputFormat,
    required DateTime now,
  }) {
    return AiTemplate(
      id: id,
      name: name,
      description: description,
      category: category,
      promptInstruction: promptInstruction,
      exampleInput: 'Search doctors by gender, specialty, name, department.',
      outputFormat: outputFormat,
      languagePreference: 'English or Thai based on user input',
      createdAt: now,
      updatedAt: now,
    );
  }
}
