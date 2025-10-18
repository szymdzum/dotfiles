# Gemini CLI Extensions

Gemini CLI extensions package prompts, MCP servers, and custom commands into a user-friendly format, expanding the capabilities of Gemini CLI and enabling sharing.

## Extension Management

A suite of tools is available using `gemini extensions` commands for managing extensions.

### Installing

To install an extension, use the `gemini extensions install` command with either a GitHub URL or a local path to the extension's directory.

```bash
gemini extensions install https://github.com/your-org/your-extension
gemini extensions install ./path/to/your-local-extension
```

### Uninstalling

To uninstall an extension, use the `gemini extensions uninstall` command followed by the extension's name.

```bash
gemini extensions uninstall your-extension-name
```

### Disabling and Enabling

Extensions can be disabled or enabled globally or for specific workspaces.

```bash
# Disable globally
gemini extensions disable your-extension-name

# Enable globally
gemini extensions enable your-extension-name

# Disable for the current workspace
gemini extensions disable your-extension-name --scope=workspace

# Enable for the current workspace
gemini extensions enable your-extension-name --scope=workspace
```

### Updating

Update extensions installed from a local path or Git repository.

```bash
# Update a specific extension
gemini extensions update your-extension-name

# Update all installed extensions
gemini extensions update --all
```

## Extension Creation

Commands are provided to simplify extension development.

### Create Boilerplate

Generate a new extension from examples using `gemini extensions new`.

```bash
gemini extensions new path/to/your-new-extension example-type
```

Replace `example-type` with a template name (e.g., `typescript`, `javascript`).

### Link Local Extension

Create a symbolic link from the extension installation directory to a development path using `gemini extensions link`. This avoids frequent updates during testing.

```bash
gemini extensions link ./path/to/your-development-extension
```

## How It Works

Gemini CLI loads extensions from `~/.gemini/extensions` on startup.

### `gemini-extension.json`

This file configures the extension, including its name, version, MCP servers, context file name, and tools to exclude.

```json
{
  "name": "my-extension",
  "version": "0.1.0",
  "description": "My first Gemini CLI extension.",
  "mcpServers": [
    {
      "name": "my-custom-server",
      "command": "node",
      "args": ["./dist/server.js"]
    }
  ],
  "contextFileName": "GEMINI.md",
  "excludeTools": ["some-tool-to-exclude"]
}
```

### Custom Commands

Extensions can provide custom commands by placing TOML files in a `commands/` subdirectory within the extension's root.

**Example `commands/my-command.toml`:**

```toml
name = "my-command"
description = "A custom command from my extension"
command = "echo 'Hello from my custom command!'"
```

### Conflict Resolution

Extension commands have the lowest precedence. If a conflict occurs with user or project commands, the extension command is renamed with an extension prefix (e.g., `/gcp.deploy` if the extension is `gcp`).

### Variables

Variable substitution is supported in `gemini-extension.json` for dynamic paths like `${extensionPath}` (the root directory of the extension) and `${workspacePath}` (the current workspace directory).
