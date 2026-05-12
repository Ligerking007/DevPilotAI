class AiTemplate {
  const AiTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.promptInstruction,
    required this.exampleInput,
    required this.outputFormat,
    required this.languagePreference,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final String promptInstruction;
  final String exampleInput;
  final String outputFormat;
  final String languagePreference;
  final DateTime createdAt;
  final DateTime updatedAt;

  AiTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? promptInstruction,
    String? exampleInput,
    String? outputFormat,
    String? languagePreference,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AiTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      promptInstruction: promptInstruction ?? this.promptInstruction,
      exampleInput: exampleInput ?? this.exampleInput,
      outputFormat: outputFormat ?? this.outputFormat,
      languagePreference: languagePreference ?? this.languagePreference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
