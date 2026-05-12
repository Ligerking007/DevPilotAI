import 'package:devpilotai/core/config/app_config.dart';
import 'package:devpilotai/data/datasources/local_storage.dart';
import 'package:devpilotai/data/datasources/openai_api_service.dart';
import 'package:devpilotai/data/models/ai_provider_settings_model.dart';
import 'package:devpilotai/data/repositories/ai_repository_impl.dart';
import 'package:devpilotai/data/repositories/history_repository_impl.dart';
import 'package:devpilotai/data/repositories/template_repository_impl.dart';
import 'package:devpilotai/domain/entities/ai_provider_settings.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/domain/entities/app_language.dart';
import 'package:devpilotai/domain/entities/generate_request.dart';
import 'package:devpilotai/domain/entities/generate_result.dart';
import 'package:devpilotai/domain/repositories/ai_repository.dart';
import 'package:devpilotai/domain/repositories/history_repository.dart';
import 'package:devpilotai/domain/repositories/template_repository.dart';
import 'package:devpilotai/domain/usecases/seed_templates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final localStorageProvider = Provider((ref) => LocalStorage());
final seedTemplatesProvider = Provider((ref) => SeedTemplates());

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepositoryImpl(
    ref.watch(localStorageProvider),
    ref.watch(seedTemplatesProvider),
  );
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(ref.watch(localStorageProvider));
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(OpenAiApiService());
});

final languageControllerProvider =
    StateNotifierProvider<LanguageController, AppLanguage>((ref) {
  return LanguageController(ref.watch(localStorageProvider));
});

class LanguageController extends StateNotifier<AppLanguage> {
  LanguageController(this._storage)
      : super(
          AppLanguage.fromCode(
            _storage.settings.get('language', defaultValue: 'en') as String,
          ),
        );

  final LocalStorage _storage;

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    await _storage.settings.put('language', language.code);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AiProviderSettings>((ref) {
  return SettingsController(ref.watch(localStorageProvider));
});

class SettingsController extends StateNotifier<AiProviderSettings> {
  SettingsController(this._storage) : super(_load(_storage));

  final LocalStorage _storage;

  static AiProviderSettings _load(LocalStorage storage) {
    final raw = storage.settings.get('aiProvider');
    if (raw is Map) {
      return AiProviderSettingsModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return AiProviderSettingsModel.defaults();
  }

  Future<void> save(AiProviderSettings settings) async {
    state = settings;
    await _storage.settings.put(
      'aiProvider',
      AiProviderSettingsModel.fromEntity(settings).toJson(),
    );
  }
}

final templatesProvider =
    StateNotifierProvider<TemplatesController, AsyncValue<List<AiTemplate>>>(
  (ref) => TemplatesController(ref.watch(templateRepositoryProvider))..load(),
);

class TemplatesController extends StateNotifier<AsyncValue<List<AiTemplate>>> {
  TemplatesController(this._repository) : super(const AsyncValue.loading());

  final TemplateRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getTemplates);
  }

  Future<void> save(AiTemplate template) async {
    await _repository.saveTemplate(template);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.deleteTemplate(id);
    await load();
  }

  Future<void> deleteMany(Iterable<String> ids) async {
    for (final id in ids) {
      await _repository.deleteTemplate(id);
    }
    await load();
  }
}

final historyProvider =
    StateNotifierProvider<HistoryController, AsyncValue<List<GenerateResult>>>(
  (ref) => HistoryController(ref.watch(historyRepositoryProvider))..load(),
);

class HistoryController extends StateNotifier<AsyncValue<List<GenerateResult>>> {
  HistoryController(this._repository) : super(const AsyncValue.loading());

  final HistoryRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getHistory);
  }

  Future<void> save(GenerateResult result) async {
    await _repository.saveResult(result);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.deleteResult(id);
    await load();
  }
}

final generatorControllerProvider =
    StateNotifierProvider<GeneratorController, GeneratorState>((ref) {
  return GeneratorController(
    aiRepository: ref.watch(aiRepositoryProvider),
    historyRepository: ref.watch(historyRepositoryProvider),
    readSettings: () => ref.read(settingsControllerProvider),
    refreshHistory: () => ref.read(historyProvider.notifier).load(),
  );
});

class GeneratorState {
  const GeneratorState({
    this.output = '',
    this.isLoading = false,
    this.error,
  });

  final String output;
  final bool isLoading;
  final String? error;

  GeneratorState copyWith({
    String? output,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return GeneratorState(
      output: output ?? this.output,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class GeneratorController extends StateNotifier<GeneratorState> {
  GeneratorController({
    required AiRepository aiRepository,
    required HistoryRepository historyRepository,
    required AiProviderSettings Function() readSettings,
    required Future<void> Function() refreshHistory,
  })  : _aiRepository = aiRepository,
        _historyRepository = historyRepository,
        _readSettings = readSettings,
        _refreshHistory = refreshHistory,
        super(const GeneratorState());

  final AiRepository _aiRepository;
  final HistoryRepository _historyRepository;
  final AiProviderSettings Function() _readSettings;
  final Future<void> Function() _refreshHistory;

  Future<void> generate({
    required AiTemplate template,
    required String userInput,
  }) async {
    final settings = _readSettings();
    if (settings.apiKey.trim().isEmpty && AppConfig.openAiApiKey.isEmpty) {
      state = state.copyWith(error: 'Missing API key');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final request = GenerateRequest(template: template, userInput: userInput);
      final output = await _aiRepository.generate(
        request: request,
        settings: settings,
      );
      state = GeneratorState(output: output);
      await _historyRepository.saveResult(
        GenerateResult(
          id: const Uuid().v4(),
          templateId: template.id,
          templateName: template.name,
          userInput: userInput,
          output: output,
          createdAt: DateTime.now(),
        ),
      );
      await _refreshHistory();
    } catch (error) {
      state = GeneratorState(error: error.toString());
    }
  }
}
