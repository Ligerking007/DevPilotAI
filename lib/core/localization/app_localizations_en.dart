// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DevPilotAI';

  @override
  String get appBrand => 'DevPilot AI by JakapanK';

  @override
  String appVersionLabel(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get generator => 'Generator';

  @override
  String get templates => 'Templates';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get thai => 'Thai';

  @override
  String get selectTemplate => 'Select template';

  @override
  String get userCommand => 'User command';

  @override
  String get userCommandHint =>
      'Describe the requirement, code, release, or task...';

  @override
  String get generate => 'Generate';

  @override
  String get result => 'Result';

  @override
  String get emptyResult => 'Generated output will appear here.';

  @override
  String get copy => 'Copy';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get createTemplate => 'Create template';

  @override
  String get editTemplate => 'Edit template';

  @override
  String get searchTemplates => 'Search templates';

  @override
  String get noTemplateSearchResults => 'No templates match your search.';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortNameAsc => 'Name A-Z';

  @override
  String get sortNameDesc => 'Name Z-A';

  @override
  String get sortCategoryAsc => 'Category A-Z';

  @override
  String get sortNewest => 'Newest updated';

  @override
  String get sortOldest => 'Oldest updated';

  @override
  String get pageSize => 'Rows per page';

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get createdAt => 'Created';

  @override
  String get updatedAt => 'Updated';

  @override
  String get confirmDeleteTitle => 'Confirm delete';

  @override
  String confirmDeleteTemplatesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count templates?',
      one: 'Delete 1 template?',
    );
    return '$_temp0';
  }

  @override
  String templatePageStatus(int currentPage, int totalPages, int totalItems) {
    return 'Page $currentPage of $totalPages ($totalItems templates)';
  }

  @override
  String get selectAll => 'Select all';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String selectedTemplates(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count templates selected',
      one: '1 template selected',
    );
    return '$_temp0';
  }

  @override
  String get templateName => 'Template name';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get promptInstruction => 'Prompt instruction';

  @override
  String get exampleInput => 'Example input';

  @override
  String get outputFormat => 'Output format';

  @override
  String get languagePreference => 'Language preference';

  @override
  String get promptPreview => 'Prompt preview';

  @override
  String get cancel => 'Cancel';

  @override
  String get saved => 'Saved';

  @override
  String get apiSettings => 'AI provider settings';

  @override
  String get provider => 'Provider';

  @override
  String get apiKey => 'API key';

  @override
  String get baseUrl => 'Base URL';

  @override
  String get model => 'Model';

  @override
  String get releaseNotesTitle => 'Release Notes';

  @override
  String get releaseNotesIntro =>
      'DevPilotAI helps teams turn requirements into practical AI-assisted work outputs.';

  @override
  String get releaseVersion100Title => 'Version 1.0.0';

  @override
  String get releaseVersion100Date => 'Initial developer workspace release';

  @override
  String get releaseVersion100Templates =>
      'Template workspace with search, category grouping, sortable table columns, pagination, row numbers, multi-select, and confirm delete.';

  @override
  String get releaseVersion100Generator =>
      'Split generator workspace with template selection, long context input, prompt preview, formatted result output, copy action, and saved history.';

  @override
  String get releaseVersion100History =>
      'History screen supports keyword, template, category, and date filtering for generated results.';

  @override
  String get releaseVersion100Settings =>
      'Settings include Thai/English switching, OpenAI-compatible provider settings, versioned release notes, and developer message.';

  @override
  String get releaseVersion100DeveloperPacks =>
      'Developer-focused templates include API Spec Reviewer, PR Description Generator, Error Log Analyzer, Security Review Checklist, Performance Bottleneck Analyzer, and Backend Unit Test Generator.';

  @override
  String get developerMessageTitle => 'Message from the Developer';

  @override
  String get developerMessageIntro =>
      'This application is built to reduce repeated analysis work and help product, QA, and engineering teams start from a stronger draft.';

  @override
  String get developerMessageFeatures =>
      'Key strengths are reusable skill templates, OpenAI-compatible integration, local-first history, responsive web/mobile layout, and multilingual workflow support.';

  @override
  String get developerMessageBenefits =>
      'Use it to clarify requirements, generate test cases, analyze bug risks, prepare release notes, and keep useful AI outputs organized for later review.';

  @override
  String get noHistory => 'No generated history yet.';

  @override
  String get searchHistory => 'Search history';

  @override
  String get allTemplates => 'All templates';

  @override
  String get allCategories => 'All categories';

  @override
  String get dateRange => 'Date range';

  @override
  String get allDates => 'All dates';

  @override
  String get today => 'Today';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get noHistorySearchResults => 'No history matches your filters.';

  @override
  String get noTemplates => 'No templates yet.';

  @override
  String get loading => 'Generating...';

  @override
  String get requiredField => 'Required field';

  @override
  String get errorMissingApiKey =>
      'Add an API key in settings or pass OPENAI_API_KEY.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';
}
