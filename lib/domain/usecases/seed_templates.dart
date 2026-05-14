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
      _template(
        id: 'api-spec-reviewer',
        name: 'API Spec Reviewer',
        description: 'Review API contracts for completeness and developer fit.',
        category: 'Developer',
        promptInstruction: 'You are a senior backend engineer. Review the API '
            'specification for correctness, missing fields, validation rules, '
            'status codes, error responses, pagination, security, and versioning.',
        exampleInput: 'Review this OpenAPI endpoint for searching orders.',
        outputFormat: 'Return sections for Summary, Contract issues, Missing '
            'details, Breaking-change risks, Security concerns, and Suggested '
            'API improvements.',
        now: now,
      ),
      _template(
        id: 'pull-request-description-generator',
        name: 'Pull Request Description Generator',
        description: 'Create a clear PR description from a change summary.',
        category: 'Developer',
        promptInstruction: 'You are a pragmatic software engineer. Convert the '
            'provided change details into a concise pull request description '
            'that reviewers can scan quickly.',
        exampleInput:
            'Added template search, category grouping, and bulk delete.',
        outputFormat: 'Return Markdown with Summary, Changes, User impact, '
            'Technical notes, Testing, and Rollback considerations.',
        now: now,
      ),
      _template(
        id: 'error-log-analyzer',
        name: 'Error Log Analyzer',
        description: 'Analyze logs and suggest likely root causes and fixes.',
        category: 'Developer',
        promptInstruction: 'You are a production support engineer. Analyze the '
            'error logs, stack traces, and symptoms to identify likely causes, '
            'debugging steps, and safe fixes.',
        exampleInput: 'Paste a stack trace, server log, or mobile crash log.',
        outputFormat: 'Return Root cause hypotheses, Evidence, Immediate '
            'checks, Fix options, Regression tests, and Risk level.',
        now: now,
      ),
      _template(
        id: 'security-review-checklist',
        name: 'Security Review Checklist',
        description: 'Generate security checks for code, APIs, and workflows.',
        category: 'Developer',
        promptInstruction: 'You are an application security reviewer. Analyze '
            'the change for authentication, authorization, input validation, '
            'data exposure, secrets, logging, and dependency risks.',
        exampleInput: 'Review a login API, file upload flow, or admin feature.',
        outputFormat: 'Return checklist sections for Auth, Access control, '
            'Input validation, Data protection, Logging, Dependencies, and '
            'Required tests.',
        now: now,
      ),
      _template(
        id: 'performance-bottleneck-analyzer',
        name: 'Performance Bottleneck Analyzer',
        description:
            'Find likely performance bottlenecks and measurement plans.',
        category: 'Developer',
        promptInstruction:
            'You are a performance-focused engineer. Analyze the '
            'feature, code path, query, or architecture for latency, memory, '
            'network, database, rendering, and concurrency bottlenecks.',
        exampleInput: 'Analyze slow doctor search on mobile and backend APIs.',
        outputFormat: 'Return Bottleneck hypotheses, Measurements to collect, '
            'Quick wins, Deeper fixes, Tradeoffs, and Performance tests.',
        now: now,
      ),
      _template(
        id: 'backend-unit-test-generator',
        name: 'Backend Unit Test Generator',
        description: 'Generate backend unit tests and edge cases.',
        category: 'Developer',
        promptInstruction: 'You are a senior backend developer. Generate unit '
            'test cases for service logic, API handlers, validators, database '
            'boundaries, mocks, and failure paths.',
        exampleInput: 'Generate tests for an order service createOrder method.',
        outputFormat: 'Return test cases grouped by Happy path, Validation, '
            'Authorization, External failures, Data boundaries, and Regression '
            'risks.',
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
    String? exampleInput,
  }) {
    return AiTemplate(
      id: id,
      name: name,
      description: description,
      category: category,
      promptInstruction: promptInstruction,
      exampleInput: exampleInput ??
          'Search doctors by gender, specialty, name, department.',
      outputFormat: outputFormat,
      languagePreference: 'English or Thai based on user input',
      createdAt: now,
      updatedAt: now,
    );
  }
}
