import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({required this.title, super.key});

  final String title;

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  final _inputController = TextEditingController();
  AiTemplate? _selectedTemplate;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(templatesProvider);
    final generator = ref.watch(generatorControllerProvider);

    return PageScaffold(
      title: widget.title,
      child: templates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          _selectedTemplate ??= items.isEmpty ? null : items.first;
          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final input = _InputPanel(
                templates: items,
                selectedTemplate: _selectedTemplate,
                inputController: _inputController,
                isLoading: generator.isLoading,
                onTemplateChanged: (template) => setState(() {
                  _selectedTemplate = template;
                }),
                onGenerate: () {
                  final template = _selectedTemplate;
                  final input = _inputController.text.trim();
                  if (template == null || input.isEmpty) {
                    return;
                  }
                  ref.read(generatorControllerProvider.notifier).generate(
                        template: template,
                        userInput: input,
                      );
                },
              );
              final result = _ResultPanel(
                output: generator.output,
                error: generator.error,
                isLoading: generator.isLoading,
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: input),
                    const SizedBox(width: 16),
                    Expanded(child: result),
                  ],
                );
              }
              return ListView(
                children: [
                  input,
                  const SizedBox(height: 16),
                  result,
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _InputPanel extends StatelessWidget {
  const _InputPanel({
    required this.templates,
    required this.selectedTemplate,
    required this.inputController,
    required this.isLoading,
    required this.onTemplateChanged,
    required this.onGenerate,
  });

  final List<AiTemplate> templates;
  final AiTemplate? selectedTemplate;
  final TextEditingController inputController;
  final bool isLoading;
  final ValueChanged<AiTemplate?> onTemplateChanged;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<AiTemplate>(
              initialValue: selectedTemplate,
              items: templates
                  .map(
                    (template) => DropdownMenuItem(
                      value: template,
                      child: Text(template.name),
                    ),
                  )
                  .toList(),
              onChanged: onTemplateChanged,
              decoration: InputDecoration(labelText: l10n.selectTemplate),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: inputController,
              minLines: 12,
              maxLines: 18,
              decoration: InputDecoration(
                labelText: l10n.userCommand,
                hintText: l10n.userCommandHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: isLoading ? null : onGenerate,
              icon: isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bolt),
              label: Text(isLoading ? l10n.loading : l10n.generate),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.output,
    required this.error,
    required this.isLoading,
  });

  final String output;
  final String? error;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = error ?? output;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.result,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: l10n.copy,
                  onPressed: text.isEmpty
                      ? null
                      : () => Clipboard.setData(ClipboardData(text: text)),
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const LinearProgressIndicator()
            else if (text.isEmpty)
              Text(l10n.emptyResult)
            else if (error != null)
              Text(
                text,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else
              MarkdownBody(data: text),
          ],
        ),
      ),
    );
  }
}
