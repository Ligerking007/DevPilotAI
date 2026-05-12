import 'package:devpilotai/core/localization/app_localizations.dart';
import 'package:devpilotai/presentation/features/generator/generator_screen.dart';
import 'package:devpilotai/presentation/features/history/history_screen.dart';
import 'package:devpilotai/presentation/features/settings/settings_screen.dart';
import 'package:devpilotai/presentation/features/templates/templates_screen.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      GeneratorScreen(title: l10n.generator),
      TemplatesScreen(title: l10n.templates),
      HistoryScreen(title: l10n.history),
      SettingsScreen(title: l10n.settings),
    ];

    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.auto_awesome_outlined),
        selectedIcon: const Icon(Icons.auto_awesome),
        label: l10n.generator,
      ),
      NavigationDestination(
        icon: const Icon(Icons.dashboard_customize_outlined),
        selectedIcon: const Icon(Icons.dashboard_customize),
        label: l10n.templates,
      ),
      NavigationDestination(
        icon: const Icon(Icons.history_outlined),
        selectedIcon: const Icon(Icons.history),
        label: l10n.history,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return Scaffold(
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  extended: constraints.maxWidth >= 1100,
                  selectedIndex: _index,
                  onDestinationSelected: (value) => setState(() {
                    _index = value;
                  }),
                  labelType: constraints.maxWidth >= 1100
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: destination.icon,
                          selectedIcon: destination.selectedIcon,
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                ),
              Expanded(child: pages[_index]),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (value) => setState(() {
                    _index = value;
                  }),
                  destinations: destinations,
                ),
        );
      },
    );
  }
}
