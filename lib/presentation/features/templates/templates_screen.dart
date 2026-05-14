import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum _TemplateSortOption {
  nameAsc,
  nameDesc,
  categoryAsc,
  categoryDesc,
  newest,
  oldest,
}

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({required this.title, super.key});

  final String title;

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedTemplateIds = {};
  _TemplateSortOption _sortOption = _TemplateSortOption.categoryAsc;
  int _pageIndex = 0;
  int _pageSize = 10;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final templates = ref.watch(templatesProvider);
    return PageScaffold(
      title: widget.title,
      expandContent: true,
      actions: [
        IconButton.filledTonal(
          tooltip: l10n.createTemplate,
          onPressed: () => _showTemplateDialog(context, ref),
          icon: const Icon(Icons.add),
        ),
        const SizedBox(width: 8),
      ],
      child: templates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.noTemplates));
          }
          // Keep the data pipeline explicit: search narrows the full catalog,
          // sort defines display order, then pagination limits what the table
          // renders for performance.
          final filtered = _filterTemplates(items, _query);
          final sorted = _sortTemplates(filtered, _sortOption);
          final totalPages = _totalPages(sorted.length, _pageSize);
          final pageIndex = _pageIndex.clamp(0, totalPages - 1);
          final pageItems = _pageItems(sorted, pageIndex, _pageSize);
          _selectedTemplateIds.removeWhere(
            (id) => !items.any((template) => template.id == id),
          );
          return Column(
            children: [
              _TemplateTableToolbar(
                searchController: _searchController,
                query: _query,
                pageSize: _pageSize,
                currentPage: pageIndex + 1,
                totalPages: totalPages,
                totalItems: sorted.length,
                onSearchChanged: (value) => setState(() {
                  _query = value;
                  _pageIndex = 0;
                }),
                onClearSearch: () => setState(() {
                  _searchController.clear();
                  _query = '';
                  _pageIndex = 0;
                }),
                onPageSizeChanged: (value) => setState(() {
                  _pageSize = value;
                  _pageIndex = 0;
                }),
                onPreviousPage: pageIndex == 0
                    ? null
                    : () => setState(() {
                          _pageIndex = pageIndex - 1;
                        }),
                onNextPage: pageIndex >= totalPages - 1
                    ? null
                    : () => setState(() {
                          _pageIndex = pageIndex + 1;
                        }),
                onDeleteSelected: _selectedTemplateIds.isEmpty
                    ? null
                    : () async {
                        final confirmed = await _confirmDelete(
                          context,
                          count: _selectedTemplateIds.length,
                        );
                        if (!confirmed) {
                          return;
                        }
                        final ids = Set<String>.from(_selectedTemplateIds);
                        setState(_selectedTemplateIds.clear);
                        await ref
                            .read(templatesProvider.notifier)
                            .deleteMany(ids);
                      },
              ),
              const SizedBox(height: 8),
              if (sorted.isEmpty)
                Expanded(
                  child: Center(child: Text(l10n.noTemplateSearchResults)),
                )
              else
                Expanded(
                  child: _TemplatesTable(
                    templates: pageItems,
                    rowOffset: pageIndex * _pageSize,
                    sortOption: _sortOption,
                    selectedTemplateIds: _selectedTemplateIds,
                    onTogglePageSelection: () =>
                        _togglePageSelection(pageItems),
                    onSortByName: () => _setSort(
                      _sortOption == _TemplateSortOption.nameAsc
                          ? _TemplateSortOption.nameDesc
                          : _TemplateSortOption.nameAsc,
                    ),
                    onSortByCategory: () => _setSort(
                      _sortOption == _TemplateSortOption.categoryAsc
                          ? _TemplateSortOption.categoryDesc
                          : _TemplateSortOption.categoryAsc,
                    ),
                    onSortByUpdatedAt: () => _setSort(
                      _sortOption == _TemplateSortOption.newest
                          ? _TemplateSortOption.oldest
                          : _TemplateSortOption.newest,
                    ),
                    onToggleSelected: _toggleTemplateSelection,
                    onEdit: (template) => _showTemplateDialog(
                      context,
                      ref,
                      template: template,
                    ),
                    onDelete: (template) async {
                      final confirmed = await _confirmDelete(context, count: 1);
                      if (confirmed) {
                        await ref
                            .read(templatesProvider.notifier)
                            .delete(template.id);
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<AiTemplate> _filterTemplates(List<AiTemplate> templates, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return templates;
    }

    return templates.where((template) {
      final searchableText = [
        template.name,
        template.description,
        template.category,
        template.promptInstruction,
        template.outputFormat,
        template.languagePreference,
      ].join(' ').toLowerCase();
      return searchableText.contains(normalizedQuery);
    }).toList();
  }

  List<AiTemplate> _sortTemplates(
    List<AiTemplate> templates,
    _TemplateSortOption sortOption,
  ) {
    final sorted = List<AiTemplate>.from(templates);
    int byName(AiTemplate a, AiTemplate b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    }

    int byCategory(AiTemplate a, AiTemplate b) {
      final categoryCompare =
          a.category.toLowerCase().compareTo(b.category.toLowerCase());
      return categoryCompare == 0 ? byName(a, b) : categoryCompare;
    }

    sorted.sort((a, b) {
      return switch (sortOption) {
        _TemplateSortOption.nameAsc => byName(a, b),
        _TemplateSortOption.nameDesc => byName(b, a),
        _TemplateSortOption.categoryAsc => byCategory(a, b),
        _TemplateSortOption.categoryDesc => byCategory(b, a),
        _TemplateSortOption.newest => b.updatedAt.compareTo(a.updatedAt),
        _TemplateSortOption.oldest => a.updatedAt.compareTo(b.updatedAt),
      };
    });
    return sorted;
  }

  int _totalPages(int totalItems, int pageSize) {
    if (totalItems == 0) {
      return 1;
    }
    return ((totalItems + pageSize - 1) / pageSize).floor();
  }

  List<AiTemplate> _pageItems(
    List<AiTemplate> templates,
    int pageIndex,
    int pageSize,
  ) {
    final start = pageIndex * pageSize;
    final end = (start + pageSize).clamp(0, templates.length);
    return templates.sublist(start, end);
  }

  void _toggleTemplateSelection(AiTemplate template) {
    setState(() {
      if (_selectedTemplateIds.contains(template.id)) {
        _selectedTemplateIds.remove(template.id);
      } else {
        _selectedTemplateIds.add(template.id);
      }
    });
  }

  void _togglePageSelection(List<AiTemplate> pageItems) {
    setState(() {
      final pageIds = pageItems.map((template) => template.id).toSet();
      // The header checkbox works on the visible page only, matching the
      // pagination scope and avoiding accidental deletion of hidden rows.
      final allSelected =
          pageIds.isNotEmpty && pageIds.every(_selectedTemplateIds.contains);
      if (allSelected) {
        _selectedTemplateIds.removeAll(pageIds);
      } else {
        _selectedTemplateIds.addAll(pageIds);
      }
    });
  }

  void _setSort(_TemplateSortOption sortOption) {
    setState(() {
      _sortOption = sortOption;
      _pageIndex = 0;
    });
  }

  Future<bool> _confirmDelete(
    BuildContext context, {
    required int count,
  }) async {
    final l10n = AppLocalizations.of(context);
    // Template deletion is destructive and can include multiple selected rows,
    // so every delete path routes through this confirmation dialog.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteTemplatesMessage(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.delete),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _showTemplateDialog(
    BuildContext context,
    WidgetRef ref, {
    AiTemplate? template,
  }) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: template?.name ?? '');
    final description =
        TextEditingController(text: template?.description ?? '');
    final category = TextEditingController(text: template?.category ?? '');
    final prompt =
        TextEditingController(text: template?.promptInstruction ?? '');
    final example = TextEditingController(text: template?.exampleInput ?? '');
    final output = TextEditingController(text: template?.outputFormat ?? '');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            template == null ? l10n.createTemplate : l10n.editTemplate,
          ),
          content: SizedBox(
            width: 720,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _field(context, name, l10n.templateName),
                    _field(context, description, l10n.description),
                    _field(context, category, l10n.category),
                    _field(context, prompt, l10n.promptInstruction, lines: 5),
                    _field(context, example, l10n.exampleInput, lines: 3),
                    _field(context, output, l10n.outputFormat, lines: 4),
                    if (template != null) ...[
                      const SizedBox(height: 4),
                      _TemplateMetadata(
                        label: l10n.createdAt,
                        value: _formatDateTime(template.createdAt),
                      ),
                      const SizedBox(height: 8),
                      _TemplateMetadata(
                        label: l10n.updatedAt,
                        value: _formatDateTime(template.updatedAt),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final now = DateTime.now();
                ref.read(templatesProvider.notifier).save(
                      AiTemplate(
                        id: template?.id ?? const Uuid().v4(),
                        name: name.text.trim(),
                        description: description.text.trim(),
                        category: category.text.trim(),
                        promptInstruction: prompt.text.trim(),
                        exampleInput: example.text.trim(),
                        outputFormat: output.text.trim(),
                        languagePreference: template?.languagePreference ??
                            'English or Thai based on user input',
                        createdAt: template?.createdAt ?? now,
                        updatedAt: now,
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    name.dispose();
    description.dispose();
    category.dispose();
    prompt.dispose();
    example.dispose();
    output.dispose();
  }

  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String label, {
    int lines = 1,
  }) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        minLines: lines,
        maxLines: lines + 2,
        validator: (value) =>
            value == null || value.trim().isEmpty ? l10n.requiredField : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.year}-$month-$day $hour:$minute';
}

class _TemplateMetadata extends StatelessWidget {
  const _TemplateMetadata({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _TemplateTableToolbar extends StatelessWidget {
  const _TemplateTableToolbar({
    required this.searchController,
    required this.query,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onPageSizeChanged,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onDeleteSelected,
  });

  final TextEditingController searchController;
  final String query;
  final int pageSize;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<int> onPageSizeChanged;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onDeleteSelected;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 920;
            if (!wide) {
              // Mobile keeps the same controls as desktop but compresses them
              // into two short rows so the table remains the primary content.
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        labelText: l10n.searchTemplates,
                        prefixIcon: const Icon(Icons.search, size: 18),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: l10n.cancel,
                                onPressed: onClearSearch,
                                icon: const Icon(Icons.close, size: 18),
                              ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 76,
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFD8DEE8),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: pageSize,
                            isExpanded: true,
                            items: [10, 20, 50, 100]
                                .map(
                                  (size) => DropdownMenuItem(
                                    value: size,
                                    child: Text('$size'),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                onPageSizeChanged(value);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.templatePageStatus(
                              currentPage,
                              totalPages,
                              totalItems,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _CompactToolbarButton(
                        tooltip: l10n.previousPage,
                        onPressed: onPreviousPage,
                        icon: Icons.chevron_left,
                      ),
                      const SizedBox(width: 4),
                      _CompactToolbarButton(
                        tooltip: l10n.nextPage,
                        onPressed: onNextPage,
                        icon: Icons.chevron_right,
                      ),
                      const SizedBox(width: 4),
                      _CompactToolbarButton(
                        tooltip: l10n.delete,
                        onPressed: onDeleteSelected,
                        icon: Icons.delete_outline,
                      ),
                    ],
                  ),
                ],
              );
            }

            final controls = [
              SizedBox(
                width: wide ? 360 : constraints.maxWidth,
                height: 44,
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    labelText: l10n.searchTemplates,
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
              SizedBox(
                width: 118,
                height: 44,
                child: DropdownButtonFormField<int>(
                  initialValue: pageSize,
                  decoration: InputDecoration(
                    labelText: l10n.pageSize,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  items: [10, 20, 50, 100]
                      .map(
                        (size) => DropdownMenuItem(
                          value: size,
                          child: Text('$size'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onPageSizeChanged(value);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 44,
                child: Center(
                  child: Text(
                    l10n.templatePageStatus(
                      currentPage,
                      totalPages,
                      totalItems,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: l10n.previousPage,
                onPressed: onPreviousPage,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton.filledTonal(
                tooltip: l10n.nextPage,
                onPressed: onNextPage,
                icon: const Icon(Icons.chevron_right),
              ),
              FilledButton.icon(
                onPressed: onDeleteSelected,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: Text(l10n.delete),
              ),
            ];

            return Row(
              children: [
                controls[0],
                const SizedBox(width: 8),
                controls[1],
                const Spacer(),
                controls[2],
                const SizedBox(width: 8),
                controls[3],
                const SizedBox(width: 8),
                controls[4],
                const SizedBox(width: 8),
                controls[5],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TemplatesTable extends StatelessWidget {
  const _TemplatesTable({
    required this.templates,
    required this.rowOffset,
    required this.sortOption,
    required this.selectedTemplateIds,
    required this.onTogglePageSelection,
    required this.onSortByName,
    required this.onSortByCategory,
    required this.onSortByUpdatedAt,
    required this.onToggleSelected,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AiTemplate> templates;
  final int rowOffset;
  final _TemplateSortOption sortOption;
  final Set<String> selectedTemplateIds;
  final VoidCallback onTogglePageSelection;
  final VoidCallback onSortByName;
  final VoidCallback onSortByCategory;
  final VoidCallback onSortByUpdatedAt;
  final ValueChanged<AiTemplate> onToggleSelected;
  final ValueChanged<AiTemplate> onEdit;
  final ValueChanged<AiTemplate> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth =
            constraints.maxWidth < 1080 ? 1080.0 : constraints.maxWidth;
        return Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  _TemplateTableHeader(
                    templates: templates,
                    selectedTemplateIds: selectedTemplateIds,
                    sortOption: sortOption,
                    onTogglePageSelection: onTogglePageSelection,
                    onSortByName: onSortByName,
                    onSortByCategory: onSortByCategory,
                    onSortByUpdatedAt: onSortByUpdatedAt,
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: templates.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final template = templates[index];
                        return _TemplateTableRow(
                          rowNumber: rowOffset + index + 1,
                          template: template,
                          selected: selectedTemplateIds.contains(template.id),
                          onToggleSelected: () => onToggleSelected(template),
                          onEdit: () => onEdit(template),
                          onDelete: () => onDelete(template),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompactToolbarButton extends StatelessWidget {
  const _CompactToolbarButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        fixedSize: const Size.square(36),
        minimumSize: const Size.square(36),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: 20),
    );
  }
}

class _TemplateTableHeader extends StatelessWidget {
  const _TemplateTableHeader({
    required this.templates,
    required this.selectedTemplateIds,
    required this.sortOption,
    required this.onTogglePageSelection,
    required this.onSortByName,
    required this.onSortByCategory,
    required this.onSortByUpdatedAt,
  });

  final List<AiTemplate> templates;
  final Set<String> selectedTemplateIds;
  final _TemplateSortOption sortOption;
  final VoidCallback onTogglePageSelection;
  final VoidCallback onSortByName;
  final VoidCallback onSortByCategory;
  final VoidCallback onSortByUpdatedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
        );
    final selectedOnPage = templates
        .where((template) => selectedTemplateIds.contains(template.id))
        .length;
    final allSelected =
        templates.isNotEmpty && selectedOnPage == templates.length;
    final checkboxValue = selectedOnPage == 0
        ? false
        : allSelected
            ? true
            : null;
    return Container(
      height: 44,
      color: const Color(0xFFF3F4F6),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Checkbox(
              tristate: true,
              value: checkboxValue,
              onChanged:
                  templates.isEmpty ? null : (_) => onTogglePageSelection(),
            ),
          ),
          const SizedBox(
            width: 52,
            child: Text('#'),
          ),
          Expanded(
            flex: 3,
            child: _SortableHeaderCell(
              label: l10n.templateName,
              active: sortOption == _TemplateSortOption.nameAsc ||
                  sortOption == _TemplateSortOption.nameDesc,
              ascending: sortOption == _TemplateSortOption.nameAsc,
              onTap: onSortByName,
              style: style,
            ),
          ),
          Expanded(
            flex: 2,
            child: _SortableHeaderCell(
              label: l10n.category,
              active: sortOption == _TemplateSortOption.categoryAsc ||
                  sortOption == _TemplateSortOption.categoryDesc,
              ascending: sortOption == _TemplateSortOption.categoryAsc,
              onTap: onSortByCategory,
              style: style,
            ),
          ),
          Expanded(flex: 5, child: Text(l10n.description, style: style)),
          Expanded(
            flex: 2,
            child: _SortableHeaderCell(
              label: l10n.updatedAt,
              active: sortOption == _TemplateSortOption.newest ||
                  sortOption == _TemplateSortOption.oldest,
              ascending: sortOption == _TemplateSortOption.oldest,
              onTap: onSortByUpdatedAt,
              style: style,
            ),
          ),
          const SizedBox(width: 104),
        ],
      ),
    );
  }
}

class _SortableHeaderCell extends StatelessWidget {
  const _SortableHeaderCell({
    required this.label,
    required this.active,
    required this.ascending,
    required this.onTap,
    required this.style,
  });

  final String label;
  final bool active;
  final bool ascending;
  final VoidCallback onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            active
                ? ascending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward
                : Icons.unfold_more,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _TemplateTableRow extends StatelessWidget {
  const _TemplateTableRow({
    required this.rowNumber,
    required this.template,
    required this.selected,
    required this.onToggleSelected,
    required this.onEdit,
    required this.onDelete,
  });

  final int rowNumber;
  final AiTemplate template;
  final bool selected;
  final VoidCallback onToggleSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onToggleSelected,
      child: Container(
        color: selected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : null,
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: Checkbox(
                value: selected,
                onChanged: (_) => onToggleSelected(),
              ),
            ),
            SizedBox(
              width: 52,
              child: Text(
                '$rowNumber',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                template.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(template.category),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                template.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _formatDateTime(template.updatedAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 104,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: l10n.edit,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 20),
                  ),
                  IconButton(
                    tooltip: l10n.delete,
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
