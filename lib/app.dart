import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/core/theme/app_theme.dart';
import 'package:devpilotai/presentation/providers/app_providers.dart';
import 'package:devpilotai/presentation/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevPilotApp extends ConsumerWidget {
  const DevPilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevPilotAI',
      theme: AppTheme.light,
      locale: Locale(language.code),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}
