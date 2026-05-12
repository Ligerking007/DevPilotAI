class GenerateResult {
  const GenerateResult({
    required this.id,
    required this.templateId,
    required this.templateName,
    required this.userInput,
    required this.output,
    required this.createdAt,
  });

  final String id;
  final String templateId;
  final String templateName;
  final String userInput;
  final String output;
  final DateTime createdAt;
}
