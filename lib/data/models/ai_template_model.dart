import 'package:devpilotai/domain/entities/ai_template.dart';

class AiTemplateModel extends AiTemplate {
  const AiTemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.promptInstruction,
    required super.exampleInput,
    required super.outputFormat,
    required super.languagePreference,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AiTemplateModel.fromEntity(AiTemplate entity) {
    return AiTemplateModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      promptInstruction: entity.promptInstruction,
      exampleInput: entity.exampleInput,
      outputFormat: entity.outputFormat,
      languagePreference: entity.languagePreference,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory AiTemplateModel.fromJson(Map<String, dynamic> json) {
    return AiTemplateModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      promptInstruction: json['promptInstruction'] as String,
      exampleInput: json['exampleInput'] as String,
      outputFormat: json['outputFormat'] as String,
      languagePreference: json['languagePreference'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'promptInstruction': promptInstruction,
      'exampleInput': exampleInput,
      'outputFormat': outputFormat,
      'languagePreference': languagePreference,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
