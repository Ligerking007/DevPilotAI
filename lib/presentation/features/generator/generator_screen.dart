import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/ai_template.dart';
import 'package:devpilotai/domain/entities/generate_request.dart';
import 'package:devpilotai/domain/usecases/build_prompt.dart';
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
  void initState() {
    super.initState();
    _inputController.addListener(_refreshPromptPreview);
  }

  @override
  void dispose() {
    _inputController.removeListener(_refreshPromptPreview);
    _inputController.dispose();
    super.dispose();
  }

  void _refreshPromptPreview() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(templatesProvider);
    final generator = ref.watch(generatorControllerProvider);

    return PageScaffold(
      title: widget.title,
      expandContent: true,
      child: templates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) {
          _selectedTemplate ??= items.isEmpty ? null : items.first;
          return LayoutBuilder(
            builder: (context, constraints) {
              // The generator becomes a side-by-side workspace on desktop and
              // stacks panels on smaller screens without changing the workflow.
              final wide = constraints.maxWidth >= 900;
              final input = _InputPanel(
                templates: items,
                selectedTemplate: _selectedTemplate,
                inputController: _inputController,
                isLoading: generator.isLoading,
                fillHeight: wide,
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
                selectedTemplate: _selectedTemplate,
                userInput: _inputController.text,
                output: generator.output,
                error: generator.error,
                isLoading: generator.isLoading,
                fillHeight: wide,
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: input,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: result,
                    ),
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
    required this.fillHeight,
    required this.onTemplateChanged,
    required this.onGenerate,
  });

  final List<AiTemplate> templates;
  final AiTemplate? selectedTemplate;
  final TextEditingController inputController;
  final bool isLoading;
  final bool fillHeight;
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
            if (fillHeight)
              Expanded(child: _CommandInput(controller: inputController))
            else
              SizedBox(
                height: 360,
                child: _CommandInput(controller: inputController),
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
    required this.selectedTemplate,
    required this.userInput,
    required this.output,
    required this.error,
    required this.isLoading,
    required this.fillHeight,
  });

  final AiTemplate? selectedTemplate;
  final String userInput;
  final String output;
  final String? error;
  final bool isLoading;
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = error ?? output;
    // Preview uses the same prompt builder as the API request so users see the
    // exact structure that will be sent for generation.
    final preview = selectedTemplate == null
        ? ''
        : BuildPrompt()(
            GenerateRequest(
              template: selectedTemplate!,
              userInput: userInput.trim().isEmpty ? '...' : userInput.trim(),
            ),
          );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              initiallyExpanded: true,
              title: Text(
                l10n.promptPreview,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(
                    preview,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
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
            else if (fillHeight)
              Expanded(
                child: SingleChildScrollView(
                  child: MarkdownBody(data: text),
                ),
              )
            else
              MarkdownBody(data: text),
          ],
        ),
      ),
    );
  }
}

class _CommandInput extends StatelessWidget {
  const _CommandInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      expands: true,
      minLines: null,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        labelText: l10n.userCommand,
        hintText: l10n.userCommandHint,
        alignLabelWithHint: true,
      ),
    );
  }
}
