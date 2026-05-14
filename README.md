# DevPilotAI

DevPilotAI is a cross-platform Flutter app for creating AI templates and generating structured results from user input. It supports Android, iOS, and Web, with Thai and English localization.

## Project Overview

DevPilotAI is an AI template and skill generator workspace designed for developer-focused workflows. The app helps developers, QA engineers, and product teams turn requirements, API details, logs, code review topics, and release information into structured AI-assisted outputs.

The core idea is reusable prompting. Instead of typing a new prompt every time, users create and manage AI templates, choose the best template for the task, add their own context, preview the final prompt, and generate a formatted result through an OpenAI-compatible API.

## Interview Summary

This project demonstrates practical AI integration in a real application, not just a chatbot UI. It combines template management, prompt composition, local-first history, multilingual support, responsive layouts, and clean architecture.

Key points to explain in an interview:

- Built with Flutter for Web, Android, and iOS from one codebase.
- Uses Clean Architecture to separate UI, business logic, repositories, and data sources.
- Uses Riverpod as the state management and dependency composition layer.
- Uses Hive for local storage of templates, history, language, and provider settings.
- Integrates with an OpenAI-compatible Chat Completions API.
- Supports Thai and English localization through ARB files.
- Provides developer template packs for API review, pull requests, logs, security, performance, and unit testing.

## Why This Project Matters

DevPilotAI focuses on repeated engineering work where AI can save time and improve consistency. It is useful for tasks such as:

- Clarifying requirements before implementation.
- Generating test cases and edge cases.
- Reviewing API specs.
- Analyzing error logs.
- Preparing pull request descriptions.
- Building security and performance review checklists.
- Drafting release notes.

The main value is making AI output reusable, searchable, and easier to standardize across a team.

## Features

- Thai and English UI with runtime language switching
- AI template CRUD with seeded templates and developer template packs
- Template search, category grouping, table sorting, pagination, row numbers, and multi-select delete
- Split generator screen combining a selected template prompt with long user input
- Prompt preview before sending requests to the AI provider
- OpenAI-compatible API integration with configurable provider settings
- Local history with copy, delete, search, template filter, category filter, and date filter
- Responsive mobile and desktop UI
- Collapsible desktop navigation rail for full-width workspaces
- Versioned release notes in the Settings page
- Basic unit tests for template seeding and prompt composition

## Architecture Overview

The project follows a Clean Architecture style:

```text
presentation -> domain -> data
```

- `presentation`: Flutter screens, widgets, and Riverpod controllers.
- `domain`: core entities, repository contracts, and use cases.
- `data`: Hive local storage, API services, data models, and repository implementations.
- `core`: app configuration and generated localization classes.

Riverpod acts as the composition root. UI screens depend on providers, providers connect to repositories, and repositories talk to local storage or the OpenAI-compatible API service.

The prompt generation flow is:

```text
Selected template + user input
        |
BuildPrompt use case
        |
AiRepository
        |
OpenAiApiService
        |
Generated result
        |
Saved to local history
```

## Demo Flow

Use this flow when presenting the project:

1. Open the Templates page and show the developer template packs.
2. Search, sort, paginate, and group templates by category.
3. Open the Generator page.
4. Select a template such as API Spec Reviewer or Security Review Checklist.
5. Paste a requirement, API spec, error log, or code review context.
6. Show the prompt preview and generated markdown result.
7. Open History and filter results by keyword, template, category, or date.
8. Open Settings to show language switching, API settings, app version, and release notes.

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
