import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/generate_result.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _HistoryDateFilter {
  all,
  today,
  last7Days,
  last30Days,
}

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({required this.title, super.key});

  final String title;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _templateName;
  String? _category;
  _HistoryDateFilter _dateFilter = _HistoryDateFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyProvider);
    final templates = ref.watch(templatesProvider);
    return PageScaffold(
      title: widget.title,
      expandContent: true,
      child: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) => templates.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (templateItems) {
            if (items.isEmpty) {
              return Center(child: Text(l10n.noHistory));
            }

            final categoryByTemplateId = {
              for (final template in templateItems)
                template.id: template.category,
            };
            final templateNames = items.map((item) => item.templateName).toSet()
              ..removeWhere((name) => name.trim().isEmpty);
            final categories = categoryByTemplateId.values.toSet()
              ..removeWhere((category) => category.trim().isEmpty);
            final filtered = _filterHistory(items, categoryByTemplateId);

            return Column(
              children: [
                _HistoryFilterBar(
                  searchController: _searchController,
                  query: _query,
                  templateName: _templateName,
                  category: _category,
                  dateFilter: _dateFilter,
                  templateNames: templateNames.toList()..sort(),
                  categories: categories.toList()..sort(),
                  onSearchChanged: (value) => setState(() {
                    _query = value;
                  }),
                  onClearSearch: () => setState(() {
                    _searchController.clear();
                    _query = '';
                  }),
                  onTemplateChanged: (value) => setState(() {
                    _templateName = value;
                  }),
                  onCategoryChanged: (value) => setState(() {
                    _category = value;
                  }),
                  onDateFilterChanged: (value) => setState(() {
                    _dateFilter = value;
                  }),
                ),
                const SizedBox(height: 12),
                if (filtered.isEmpty)
                  Expanded(
                    child: Center(child: Text(l10n.noHistorySearchResults)),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _HistoryCard(result: filtered[index]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<GenerateResult> _filterHistory(
    List<GenerateResult> items,
    Map<String, String> categoryByTemplateId,
  ) {
    final normalizedQuery = _query.trim().toLowerCase();
    return items.where((item) {
      final category = categoryByTemplateId[item.templateId] ?? '';
      final matchesTemplate =
          _templateName == null || item.templateName == _templateName;
      final matchesCategory = _category == null || category == _category;
      final matchesDate = _matchesDate(item.createdAt);
      final searchable = [
        item.templateName,
        category,
        item.userInput,
        item.output,
      ].join(' ').toLowerCase();
      final matchesQuery =
          normalizedQuery.isEmpty || searchable.contains(normalizedQuery);
      return matchesTemplate && matchesCategory && matchesDate && matchesQuery;
    }).toList();
  }

  bool _matchesDate(DateTime value) {
    final now = DateTime.now();
    final local = value.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(local.year, local.month, local.day);
    return switch (_dateFilter) {
      _HistoryDateFilter.all => true,
      _HistoryDateFilter.today => itemDate == today,
      _HistoryDateFilter.last7Days =>
        !itemDate.isBefore(today.subtract(const Duration(days: 6))),
      _HistoryDateFilter.last30Days =>
        !itemDate.isBefore(today.subtract(const Duration(days: 29))),
    };
  }
}

class _HistoryFilterBar extends StatelessWidget {
  const _HistoryFilterBar({
    required this.searchController,
    required this.query,
    required this.templateName,
    required this.category,
    required this.dateFilter,
    required this.templateNames,
    required this.categories,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onTemplateChanged,
    required this.onCategoryChanged,
    required this.onDateFilterChanged,
  });

  final TextEditingController searchController;
  final String query;
  final String? templateName;
  final String? category;
  final _HistoryDateFilter dateFilter;
  final List<String> templateNames;
  final List<String> categories;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<String?> onTemplateChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<_HistoryDateFilter> onDateFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 44,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  labelText: l10n.searchHistory,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: l10n.cancel,
                          onPressed: onClearSearch,
                          icon: const Icon(Icons.close, size: 18),
                        ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            _HistoryDropdown<String?>(
              width: 220,
              label: l10n.selectTemplate,
              value: templateName,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.allTemplates)),
                ...templateNames.map(
                  (name) => DropdownMenuItem(value: name, child: Text(name)),
                ),
              ],
              onChanged: onTemplateChanged,
            ),
            _HistoryDropdown<String?>(
              width: 180,
              label: l10n.category,
              value: category,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.allCategories)),
                ...categories.map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                ),
              ],
              onChanged: onCategoryChanged,
            ),
            _HistoryDropdown<_HistoryDateFilter>(
              width: 180,
              label: l10n.dateRange,
              value: dateFilter,
              items: _HistoryDateFilter.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_dateFilterLabel(l10n, value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onDateFilterChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _dateFilterLabel(AppLocalizations l10n, _HistoryDateFilter value) {
    return switch (value) {
      _HistoryDateFilter.all => l10n.allDates,
      _HistoryDateFilter.today => l10n.today,
      _HistoryDateFilter.last7Days => l10n.last7Days,
      _HistoryDateFilter.last30Days => l10n.last30Days,
    };
  }
}

class _HistoryDropdown<T> extends StatelessWidget {
  const _HistoryDropdown({
    required this.width,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final double width;
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
        ),
        items: items,
        onChanged: onChanged,
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
