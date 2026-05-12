import 'package:devpilotai/data/datasources/local_storage.dart';
import 'package:devpilotai/data/models/generate_result_model.dart';
import 'package:devpilotai/domain/entities/generate_result.dart';
import 'package:devpilotai/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._storage);

  final LocalStorage _storage;

  @override
  Future<List<GenerateResult>> getHistory() async {
    return _storage.history.values
        .map(
          (json) => GenerateResultModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> saveResult(GenerateResult result) async {
    final model = GenerateResultModel.fromEntity(result);
    await _storage.history.put(result.id, model.toJson());
  }

  @override
  Future<void> deleteResult(String id) async {
    await _storage.history.delete(id);
  }
}
