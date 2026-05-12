import 'dart:convert';

import 'package:devpilotai/domain/entities/ai_provider_settings.dart';
import 'package:http/http.dart' as http;

class OpenAiApiService {
  OpenAiApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> generate({
    required String systemPrompt,
    required String userInput,
    required AiProviderSettings settings,
  }) async {
    if (settings.apiKey.trim().isEmpty) {
      throw const OpenAiException('Missing API key');
    }

    final base = settings.baseUrl.replaceFirst(RegExp(r'/$'), '');
    final response = await _client.post(
      Uri.parse('$base/chat/completions'),
      headers: {
        'Authorization': 'Bearer ${settings.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': settings.model,
        'temperature': 0.2,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userInput},
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw OpenAiException(
        'API error ${response.statusCode}: ${response.body}',
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = payload['choices'] as List<dynamic>? ?? [];
    if (choices.isEmpty) {
      throw const OpenAiException('No response choices returned');
    }

    final message = choices.first as Map<String, dynamic>;
    final content = (message['message'] as Map<String, dynamic>?)?['content'];
    return (content as String? ?? '').trim();
  }
}

class OpenAiException implements Exception {
  const OpenAiException(this.message);
  final String message;

  @override
  String toString() => message;
}
