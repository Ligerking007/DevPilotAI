import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DevPilotAI'**
  String get appTitle;

  /// No description provided for @appBrand.
  ///
  /// In en, this message translates to:
  /// **'DevPilot AI by JakapanK'**
  String get appBrand;

  /// No description provided for @generator.
  ///
  /// In en, this message translates to:
  /// **'Generator'**
  String get generator;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thai;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select template'**
  String get selectTemplate;

  /// No description provided for @userCommand.
  ///
  /// In en, this message translates to:
  /// **'User command'**
  String get userCommand;

  /// No description provided for @userCommandHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the requirement, code, release, or task...'**
  String get userCommandHint;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @emptyResult.
  ///
  /// In en, this message translates to:
  /// **'Generated output will appear here.'**
  String get emptyResult;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get createTemplate;

  /// No description provided for @editTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit template'**
  String get editTemplate;

  /// No description provided for @searchTemplates.
  ///
  /// In en, this message translates to:
  /// **'Search templates'**
  String get searchTemplates;

  /// No description provided for @noTemplateSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No templates match your search.'**
  String get noTemplateSearchResults;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get sortNameDesc;

  /// No description provided for @sortCategoryAsc.
  ///
  /// In en, this message translates to:
  /// **'Category A-Z'**
  String get sortCategoryAsc;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest updated'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest updated'**
  String get sortOldest;

  /// No description provided for @pageSize.
  ///
  /// In en, this message translates to:
  /// **'Rows per page'**
  String get pageSize;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedAt;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteTemplatesMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 template?} other{Delete {count} templates?}}'**
  String confirmDeleteTemplatesMessage(int count);

  /// No description provided for @templatePageStatus.
  ///
  /// In en, this message translates to:
  /// **'Page {currentPage} of {totalPages} ({totalItems} templates)'**
  String templatePageStatus(int currentPage, int totalPages, int totalItems);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// No description provided for @selectedTemplates.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 template selected} other{{count} templates selected}}'**
  String selectedTemplates(int count);

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get templateName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @promptInstruction.
  ///
  /// In en, this message translates to:
  /// **'Prompt instruction'**
  String get promptInstruction;

  /// No description provided for @exampleInput.
  ///
  /// In en, this message translates to:
  /// **'Example input'**
  String get exampleInput;

  /// No description provided for @outputFormat.
  ///
  /// In en, this message translates to:
  /// **'Output format'**
  String get outputFormat;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language preference'**
  String get languagePreference;

  /// No description provided for @promptPreview.
  ///
  /// In en, this message translates to:
  /// **'Prompt preview'**
  String get promptPreview;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @apiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI provider settings'**
  String get apiSettings;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get apiKey;

  /// No description provided for @baseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get baseUrl;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @releaseNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Release Notes'**
  String get releaseNotesTitle;

  /// No description provided for @releaseNotesIntro.
  ///
  /// In en, this message translates to:
  /// **'DevPilotAI helps teams turn requirements into practical AI-assisted work outputs.'**
  String get releaseNotesIntro;

  /// No description provided for @releaseNoteTemplates.
  ///
  /// In en, this message translates to:
  /// **'Template workspace for creating, editing, searching, selecting, and deleting AI skills.'**
  String get releaseNoteTemplates;

  /// No description provided for @releaseNoteGenerator.
  ///
  /// In en, this message translates to:
  /// **'Generator screen combines a selected prompt template with long user input and returns formatted output.'**
  String get releaseNoteGenerator;

  /// No description provided for @releaseNoteHistory.
  ///
  /// In en, this message translates to:
  /// **'Generated results can be copied, saved, reviewed, and deleted from local history.'**
  String get releaseNoteHistory;

  /// No description provided for @releaseNoteLocalization.
  ///
  /// In en, this message translates to:
  /// **'Thai and English are supported across the main user interface.'**
  String get releaseNoteLocalization;

  /// No description provided for @developerMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Message from the Developer'**
  String get developerMessageTitle;

  /// No description provided for @developerMessageIntro.
  ///
  /// In en, this message translates to:
  /// **'This application is built to reduce repeated analysis work and help product, QA, and engineering teams start from a stronger draft.'**
  String get developerMessageIntro;

  /// No description provided for @developerMessageFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key strengths are reusable skill templates, OpenAI-compatible integration, local-first history, responsive web/mobile layout, and multilingual workflow support.'**
  String get developerMessageFeatures;

  /// No description provided for @developerMessageBenefits.
  ///
  /// In en, this message translates to:
  /// **'Use it to clarify requirements, generate test cases, analyze bug risks, prepare release notes, and keep useful AI outputs organized for later review.'**
  String get developerMessageBenefits;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No generated history yet.'**
  String get noHistory;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search history'**
  String get searchHistory;

  /// No description provided for @allTemplates.
  ///
  /// In en, this message translates to:
  /// **'All templates'**
  String get allTemplates;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get allDates;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @noHistorySearchResults.
  ///
  /// In en, this message translates to:
  /// **'No history matches your filters.'**
  String get noHistorySearchResults;

  /// No description provided for @noTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates yet.'**
  String get noTemplates;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get loading;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @errorMissingApiKey.
  ///
  /// In en, this message translates to:
  /// **'Add an API key in settings or pass OPENAI_API_KEY.'**
  String get errorMissingApiKey;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
