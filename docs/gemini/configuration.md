# Gemini CLI Configuration

The Gemini CLI is highly configurable, allowing you to tailor its behavior to your specific needs and workflow. Configuration can be managed through a `settings.json` file, environment variables, or command-line flags.

## Configuration File (`settings.json`)

The primary way to configure the Gemini CLI is through a `settings.json` file. This file is typically located in `~/.gemini/settings.json` (on Linux/macOS) or `%APPDATA%\Gemini CLI\settings.json` (on Windows).

### Structure

The `settings.json` file is a JSON object that can contain various top-level keys, each representing a different aspect of the CLI's configuration.

```json
{
  "model": {
    "name": "gemini-pro",
    "temperature": 0.7
  },
  "tools": {
    "allowed": [
      "read_file",
      "write_file",
      "run_shell_command"
    ],
    "autoAccept": true
  },
  "context": {
    "fileName": ["README.md", "GEMINI.md"],
    "discoveryMaxDirs": 100
  },
  "ui": {
    "hideBanner": true
  }
}
```

### Common Configuration Options

#### `model`

Settings related to the AI model used by the CLI.

*   `name` (string): The name of the AI model to use (e.g., `"gemini-pro"`, `"gemini-flash"`).
*   `temperature` (number): Controls the randomness of the model's output. Higher values (e.g., 0.8) make the output more creative, while lower values (e.g., 0.2) make it more focused.
*   `maxOutputTokens` (number): The maximum number of tokens the model can generate in a single response.

#### `tools`

Settings related to the tools the Gemini CLI can use.

*   `allowed` (array of strings): A list of tools that the CLI is permitted to use. This is a critical security setting. Examples: `"read_file"`, `"write_file"`, `"run_shell_command"`, `"google_web_search"`. You can also specify specific commands for `run_shell_command` (e.g., `"run_shell_command(git status)"`).
*   `autoAccept` (boolean): If `true`, the CLI will automatically accept tool calls without prompting for user confirmation. Use with caution.
*   `useRipgrep` (boolean): If `true`, the CLI will use `ripgrep` for file content searches if available.

#### `context`

Settings related to how the CLI manages and provides context to the AI model.

*   `fileName` (array of strings): A list of filenames that are always loaded into the model's context. Useful for project-specific `README.md` or `GEMINI.md` files.
*   `discoveryMaxDirs` (number): The maximum number of directories to scan when discovering context files.
*   `fileFiltering`:
    *   `respectGitIgnore` (boolean): If `true`, respects `.gitignore` rules when discovering files.
    *   `respectGeminiIgnore` (boolean): If `true`, respects `.geminiignore` rules.

#### `ui`

Settings related to the user interface of the CLI.

*   `hideBanner` (boolean): If `true`, hides the initial welcome banner.
*   `hideTips` (boolean): If `true`, hides helpful tips.
*   `showCitations` (boolean): If `true`, displays citations for generated content.

## Environment Variables

Many configuration options can also be set using environment variables. This is useful for temporary overrides or for setting sensitive information (like API keys) without hardcoding them in `settings.json`.

Environment variables typically follow an uppercase convention, often prefixed with `GEMINI_CLI_`.

*   `GEMINI_CLI_MODEL_NAME`: Overrides `model.name`.
*   `GEMINI_CLI_API_KEY`: Sets the API key for authentication.
*   `GEMINI_CLI_TOOLS_ALLOWED`: Overrides `tools.allowed` (comma-separated list).

## Command-Line Flags

For one-off changes or specific command invocations, you can use command-line flags. These take precedence over environment variables and `settings.json`.

```bash
gemini chat --model gemini-flash --temperature 0.9 "What's up?"
```

## Precedence

Configuration settings are applied in the following order of precedence (from lowest to highest):

1.  Default values
2.  `settings.json`
3.  Environment variables
4.  Command-line flags

This means that a command-line flag will override an environment variable, which will override a setting in `settings.json`, and so on.

## Example Workflow

1.  **Global `settings.json`:** Set your preferred default model and allowed tools.
2.  **Environment Variable:** Override the API key for a specific session or CI/CD pipeline.
3.  **Command-Line Flag:** Temporarily use a different model for a single query.
