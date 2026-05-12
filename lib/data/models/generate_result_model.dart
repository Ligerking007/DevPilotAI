import 'package:devpilotai/domain/entities/generate_result.dart';

class GenerateResultModel extends GenerateResult {
  const GenerateResultModel({
    required super.id,
    required super.templateId,
    required super.templateName,
    required super.userInput,
    required super.output,
    required super.createdAt,
  });

  factory GenerateResultModel.fromEntity(GenerateResult entity) {
    return GenerateResultModel(
      id: entity.id,
      templateId: entity.templateId,
      templateName: entity.templateName,
      userInput: entity.userInput,
      output: entity.output,
      createdAt: entity.createdAt,
    );
  }

  factory GenerateResultModel.fromJson(Map<String, dynamic> json) {
    return GenerateResultModel(
      id: json['id'] as String,
      templateId: json['templateId'] as String,
      templateName: json['templateName'] as String,
      userInput: json['userInput'] as String,
      output: json['output'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateId': templateId,
      'templateName': templateName,
      'userInput': userInput,
      'output': output,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
