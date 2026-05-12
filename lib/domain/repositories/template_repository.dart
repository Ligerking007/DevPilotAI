import 'package:devpilotai/domain/entities/ai_template.dart';

abstract class TemplateRepository {
  Future<List<AiTemplate>> getTemplates();
  Future<void> saveTemplate(AiTemplate template);
  Future<void> deleteTemplate(String id);
}
