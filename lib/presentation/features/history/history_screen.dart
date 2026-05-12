import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/generate_result.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyProvider);
    return PageScaffold(
      title: title,
      child: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.noHistory));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _HistoryCard(result: items[index]),
          );
        },
      ),
    );
  }
}

class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({required this.result});

  final GenerateResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ExpansionTile(
        title: Text(result.templateName),
        subtitle: Text(result.createdAt.toLocal().toString()),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              result.userInput,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: MarkdownBody(data: result.output),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: result.output)),
                icon: const Icon(Icons.copy),
                label: Text(l10n.copy),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () =>
                    ref.read(historyProvider.notifier).delete(result.id),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
