import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({required this.title, super.key});

  final String title;

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedTemplateIds = {};
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
          final filtered = _filterTemplates(items, _query);
          _selectedTemplateIds.removeWhere(
            (id) => !items.any((template) => template.id == id),
          );
          return Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {
                  _query = value;
                }),
                decoration: InputDecoration(
                  labelText: l10n.searchTemplates,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: l10n.cancel,
                          onPressed: () => setState(() {
                            _searchController.clear();
                            _query = '';
                          }),
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              _TemplateSelectionBar(
                selectedCount: _selectedTemplateIds.length,
                totalCount: filtered.length,
                onSelectAll: filtered.isEmpty
                    ? null
                    : () => setState(() {
                          _selectedTemplateIds.addAll(
                            filtered.map((template) => template.id),
                          );
                        }),
                onClearSelection: _selectedTemplateIds.isEmpty
                    ? null
                    : () => setState(_selectedTemplateIds.clear),
                onDeleteSelected: _selectedTemplateIds.isEmpty
                    ? null
                    : () async {
                        final ids = Set<String>.from(_selectedTemplateIds);
                        setState(_selectedTemplateIds.clear);
                        await ref
                            .read(templatesProvider.notifier)
                            .deleteMany(ids);
                      },
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                Expanded(
                  child: Center(child: Text(l10n.noTemplateSearchResults)),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final template = filtered[index];
                      final selected =
                          _selectedTemplateIds.contains(template.id);
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: selected,
                            onChanged: (value) => setState(() {
                              if (value ?? false) {
                                _selectedTemplateIds.add(template.id);
                              } else {
                                _selectedTemplateIds.remove(template.id);
                              }
                            }),
                          ),
                          title: Text(template.name),
                          subtitle: Text(
                            '${template.category} - ${template.description}',
                          ),
                          selected: selected,
                          onTap: () => setState(() {
                            if (selected) {
                              _selectedTemplateIds.remove(template.id);
                            } else {
                              _selectedTemplateIds.add(template.id);
                            }
                          }),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                tooltip: l10n.edit,
                                onPressed: () => _showTemplateDialog(
                                  context,
                                  ref,
                                  template: template,
                                ),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                tooltip: l10n.delete,
                                onPressed: () => ref
                                    .read(templatesProvider.notifier)
                                    .delete(template.id),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
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

  Future<void> _showTemplateDialog(
    BuildContext context,
    WidgetRef ref, {
    AiTemplate? template,
  }) async {
    final l10n = AppLocalizations.of(context);
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: template?.name ?? '');
    final description = TextEditingController(text: template?.description ?? '');
    final category = TextEditingController(text: template?.category ?? '');
    final prompt = TextEditingController(text: template?.promptInstruction ?? '');
    final example = TextEditingController(text: template?.exampleInput ?? '');
    final output = TextEditingController(text: template?.outputFormat ?? '');
    final language = TextEditingController(
      text: template?.languagePreference ?? 'English or Thai based on user input',
    );

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
                    _field(context, language, l10n.languagePreference),
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
                        languagePreference: language.text.trim(),
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
    language.dispose();
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

class _TemplateSelectionBar extends StatelessWidget {
  const _TemplateSelectionBar({
    required this.selectedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.onDeleteSelected,
  });

  final int selectedCount;
  final int totalCount;
  final VoidCallback? onSelectAll;
  final VoidCallback? onClearSelection;
  final VoidCallback? onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.selectedTemplates(selectedCount),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: totalCount == 0 ? null : onSelectAll,
              icon: const Icon(Icons.select_all),
              label: Text(l10n.selectAll),
            ),
            TextButton.icon(
              onPressed: onClearSelection,
              icon: const Icon(Icons.clear),
              label: Text(l10n.clearSelection),
            ),
            FilledButton.icon(
              onPressed: onDeleteSelected,
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.delete),
            ),
          ],
        ),
      ),
    );
  }
}
