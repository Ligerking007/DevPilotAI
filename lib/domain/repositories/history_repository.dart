import 'package:devpilotai/domain/entities/generate_result.dart';

abstract class HistoryRepository {
  Future<List<GenerateResult>> getHistory();
  Future<void> saveResult(GenerateResult result);
  Future<void> deleteResult(String id);
}
