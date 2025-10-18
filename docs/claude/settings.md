# Claude Code settings

Claude Code's behavior can be customized through its `settings.json` file, located at `~/.claude/settings.json`.

## Configuration File (`settings.json`)

The `settings.json` file is a JSON object that allows you to configure various aspects of Claude Code, including model behavior, tool usage, context management, and UI preferences.

### Structure

```json
{
  "model": {
    "name": "claude-3-opus-20240229",
    "temperature": 0.7,
    "maxOutputTokens": 2000
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
    "fileName": ["README.md", "CLAUDE.md"],
    "discoveryMaxDirs": 100
  },
  "ui": {
    "hideBanner": true
  },
  "skills": [
    // Skill definitions
  ],
  "commands": [
    // Custom command definitions
  ]
}
```

### Common Configuration Options

#### `model`

Settings related to the AI model used by Claude Code.

*   `name` (string): The name of the AI model to use (e.g., `"claude-3-opus-20240229"`, `"claude-3-sonnet-20240229"`).
*   `temperature` (number): Controls the randomness of the model's output. Higher values (e.g., 0.8) make the output more creative, while lower values (e.g., 0.2) make it more focused.
*   `maxOutputTokens` (number): The maximum number of tokens the model can generate in a single response.

#### `tools`

Settings related to the tools Claude Code can use.

*   `allowed` (array of strings): A list of tools that Claude Code is permitted to use. This is a critical security setting. Examples: `"read_file"`, `"write_file"`, `"run_shell_command"`, `"google_web_search"`. You can also specify specific commands for `run_shell_command` (e.g., `"run_shell_command(git status)"`).
*   `autoAccept` (boolean): If `true`, Claude Code will automatically accept tool calls without prompting for user confirmation. Use with caution.
*   `useRipgrep` (boolean): If `true`, Claude Code will use `ripgrep` for file content searches if available.

#### `context`

Settings related to how Claude Code manages and provides context to the AI model.

*   `fileName` (array of strings): A list of filenames that are always loaded into the model's context. Useful for project-specific `README.md` or `CLAUDE.md` files.
*   `discoveryMaxDirs` (number): The maximum number of directories to scan when discovering context files.
*   `fileFiltering`:
    *   `respectGitIgnore` (boolean): If `true`, respects `.gitignore` rules when discovering files.
    *   `respectClaudeIgnore` (boolean): If `true`, respects `.claudeignore` rules.

#### `ui`

Settings related to the user interface of Claude Code.

*   `hideBanner` (boolean): If `true`, hides the initial welcome banner.
*   `hideTips` (boolean): If `true`, hides helpful tips.
*   `showCitations` (boolean): If `true`, displays citations for generated content.

#### `skills`

An array of skill definitions. Each skill is a Python function that Claude Code can call to perform specific actions. See [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills) for more details.

#### `commands`

An array of custom command definitions. These allow you to define your own slash commands to automate repetitive tasks or integrate with external tools. See [Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands) for more details.

## Environment Variables

Many configuration options can also be set using environment variables. This is useful for temporary overrides or for setting sensitive information (like API keys) without hardcoding them in `settings.json`.

Environment variables typically follow an uppercase convention, often prefixed with `CLAUDE_CODE_`.

*   `CLAUDE_CODE_MODEL_NAME`: Overrides `model.name`.
*   `CLAUDE_CODE_API_KEY`: Sets the API key for authentication.
*   `CLAUDE_CODE_TOOLS_ALLOWED`: Overrides `tools.allowed` (comma-separated list).

## Command-Line Flags

For one-off changes or specific command invocations, you can use command-line flags. These take precedence over environment variables and `settings.json`.

```bash
claude chat --model claude-3-sonnet --temperature 0.9 "What's up?"
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
