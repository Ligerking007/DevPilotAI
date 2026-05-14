import 'package:devpilotai/core/config/app_config.dart';
import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/domain/entities/ai_provider_settings.dart';
import 'package:devpilotai/domain/entities/app_language.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({required this.title, super.key});

  final String title;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _provider;
  late final TextEditingController _apiKey;
  late final TextEditingController _baseUrl;
  late final TextEditingController _model;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsControllerProvider);
    _provider = TextEditingController(text: settings.provider);
    _apiKey = TextEditingController(text: settings.apiKey);
    _baseUrl = TextEditingController(text: settings.baseUrl);
    _model = TextEditingController(text: settings.model);
  }

  @override
  void dispose() {
    _provider.dispose();
    _apiKey.dispose();
    _baseUrl.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(languageControllerProvider);

    return PageScaffold(
      title: widget.title,
      expandContent: true,
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.appBrand),
              subtitle: Text(
                l10n.appVersionLabel(
                  AppConfig.appVersion,
                  AppConfig.appBuildNumber,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<AppLanguage>(
                    segments: [
                      ButtonSegment(
                        value: AppLanguage.english,
                        label: Text(l10n.english),
                      ),
                      ButtonSegment(
                        value: AppLanguage.thai,
                        label: Text(l10n.thai),
                      ),
                    ],
                    selected: {language},
                    onSelectionChanged: (selection) => ref
                        .read(languageControllerProvider.notifier)
                        .setLanguage(selection.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.apiSettings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  // This screen writes provider settings to local Hive storage.
                  // Use a backend proxy or secure storage before shipping real
                  // production keys to end users.
                  _field(_provider, l10n.provider),
                  _field(_apiKey, l10n.apiKey, obscure: true),
                  _field(_baseUrl, l10n.baseUrl),
                  _field(_model, l10n.model),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .save(
                              AiProviderSettings(
                                provider: _provider.text.trim(),
                                apiKey: _apiKey.text.trim(),
                                baseUrl: _baseUrl.text.trim(),
                                model: _model.text.trim(),
                              ),
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.saved)),
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ReleaseNotesSection(
            icon: Icons.new_releases_outlined,
            title: l10n.releaseNotesTitle,
            intro: l10n.releaseNotesIntro,
            releases: [
              _ReleaseNote(
                version: l10n.releaseVersion100Title,
                subtitle: l10n.releaseVersion100Date,
                bullets: [
                  l10n.releaseVersion100Templates,
                  l10n.releaseVersion100Generator,
                  l10n.releaseVersion100History,
                  l10n.releaseVersion100Settings,
                  l10n.releaseVersion100DeveloperPacks,
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoSection(
            icon: Icons.code_outlined,
            title: l10n.developerMessageTitle,
            intro: l10n.developerMessageIntro,
            bullets: [
              l10n.developerMessageFeatures,
              l10n.developerMessageBenefits,
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _ReleaseNote {
  const _ReleaseNote({
    required this.version,
    required this.subtitle,
    required this.bullets,
  });

  final String version;
  final String subtitle;
  final List<String> bullets;
}

class _ReleaseNotesSection extends StatelessWidget {
  const _ReleaseNotesSection({
    required this.icon,
    required this.title,
    required this.intro,
    required this.releases,
  });

  final IconData icon;
  final String title;
  final String intro;
  final List<_ReleaseNote> releases;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoHeader(icon: icon, title: title),
            const SizedBox(height: 12),
            Text(intro),
            const SizedBox(height: 12),
            ...releases.map((release) => _ReleaseNoteBlock(release: release)),
          ],
        ),
      ),
    );
  }
}

class _ReleaseNoteBlock extends StatelessWidget {
  const _ReleaseNoteBlock({required this.release});

  final _ReleaseNote release;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                release.version,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                release.subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              ...release.bullets.map((text) => _InfoBullet(text: text)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.intro,
    required this.bullets,
  });

  final IconData icon;
  final String title;
  final String intro;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoHeader(icon: icon, title: title),
            const SizedBox(height: 12),
            Text(intro),
            const SizedBox(height: 12),
            ...bullets.map((text) => _InfoBullet(text: text)),
          ],
        ),
      ),
    );
  }
}

class _InfoHeader extends StatelessWidget {
  const _InfoHeader({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

class _InfoBullet extends StatelessWidget {
  const _InfoBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
