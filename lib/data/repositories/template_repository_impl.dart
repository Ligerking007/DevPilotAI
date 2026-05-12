import 'package:devpilotai/data/datasources/local_storage.dart';
import 'package:devpilotai/data/models/ai_template_model.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/domain/repositories/template_repository.dart';
import 'package:devpilotai/domain/usecases/seed_templates.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  TemplateRepositoryImpl(this._storage, this._seedTemplates);

  final LocalStorage _storage;
  final SeedTemplates _seedTemplates;

  @override
  Future<List<AiTemplate>> getTemplates() async {
    if (_storage.templateBox.isEmpty) {
      for (final template in _seedTemplates()) {
        await saveTemplate(template);
      }
    }

    return _storage.templateBox.values
        .map((json) => AiTemplateModel.fromJson(Map<String, dynamic>.from(json)))
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
}
