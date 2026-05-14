import 'package:devpilotai/data/datasources/local_storage.dart';
import 'package:devpilotai/data/models/ai_template_model.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/domain/repositories/template_repository.dart';
import 'package:devpilotai/domain/usecases/seed_templates.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  TemplateRepositoryImpl(this._storage, this._seedTemplates);

  // Bump this when adding default templates. Existing users get only missing
  // seed IDs once, while templates they edited or deleted stay respected.
  static const _seedVersion = 2;
  static const _seedVersionKey = 'templateSeedVersion';

  final LocalStorage _storage;
  final SeedTemplates _seedTemplates;

  @override
  Future<List<AiTemplate>> getTemplates() async {
    await _ensureSeedTemplates();

    return _storage.templateBox.values
        .map(
          (json) => AiTemplateModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<void> saveTemplate(AiTemplate template) async {
    final model = AiTemplateModel.fromEntity(template);
    await _storage.templateBox.put(template.id, model.toJson());
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await _storage.templateBox.delete(id);
  }

  Future<void> _ensureSeedTemplates() async {
    final currentVersion =
        _storage.settings.get(_seedVersionKey, defaultValue: 0) as int;
    if (currentVersion >= _seedVersion) {
      return;
    }

    final existingIds = _storage.templateBox.keys.cast<String>().toSet();
    for (final template in _seedTemplates()) {
      if (!existingIds.contains(template.id)) {
        await saveTemplate(template);
      }
    }
    await _storage.settings.put(_seedVersionKey, _seedVersion);
  }
}
