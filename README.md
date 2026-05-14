# DevPilotAI

DevPilotAI is a cross-platform Flutter app for creating AI templates and generating structured results from user input. It supports Android, iOS, and Web, with Thai and English localization.

## Features

- Thai and English UI with runtime language switching
- AI template CRUD with seeded templates
- Main generator screen combining a selected template prompt with user input
- OpenAI-compatible API integration
- Configurable provider settings
- Local history with copy and delete actions
- Responsive mobile and desktop UI
- Basic unit tests for template seeding and prompt composition

## Setup

1. Install Flutter SDK.
2. From this directory, run:

```sh
flutter pub get
flutter gen-l10n
```

3. Optional: generate native platform runner files if they are missing:

```sh
flutter create --platforms android,ios,web .
```

4. Configure API values using `--dart-define` or in the app settings screen:

```sh
flutter run -d chrome \
  --dart-define=OPENAI_API_KEY=sk-your-key \
  --dart-define=OPENAI_BASE_URL=https://api.openai.com/v1 \
  --dart-define=OPENAI_MODEL=gpt-4o-mini
```

## Run

```sh
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

## Test

```sh
flutter test
```

## Project Structure

```text
lib/
  core/             app config, theme, localization output
  data/             local storage, API data sources, repositories
  domain/           entities, repository contracts, use cases
  presentation/     screens, providers, widgets
  l10n/             English and Thai ARB localization files
test/               unit tests
```

## Implementation Steps

1. Initialize local storage in `main.dart`.
2. Load app language and AI provider settings through Riverpod controllers.
3. Seed default AI templates on first launch.
4. Select a template and enter a user command on the generator screen.
5. Combine template instructions, output format, language preference, and input.
6. Send the request to the OpenAI-compatible chat completions API.
7. Render markdown output and save the generated result to local history.
8. Manage templates, history, language, and API settings from their tabs.

## OpenAI Integration

The app sends requests to an OpenAI-compatible chat completions endpoint:

```text
POST {baseUrl}/chat/completions
Authorization: Bearer {apiKey}
```

The selected template prompt is used as the system message and the user's command is used as the user message.

<img width="1350" height="702" alt="image" src="https://github.com/user-attachments/assets/b9358d45-c08d-41b9-9370-c7d140a9c34d" />
<img width="1348" height="694" alt="image" src="https://github.com/user-attachments/assets/03f071b2-9ad4-4fb3-8d71-a9ab53946cca" />
<img width="361" height="716" alt="image" src="https://github.com/user-attachments/assets/85c51268-9dfb-4b85-9347-01054bd8d899" />



