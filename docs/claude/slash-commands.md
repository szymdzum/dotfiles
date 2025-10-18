# Slash Commands

Claude Code supports slash commands, which are special commands that start with a `/` (forward slash). These commands allow you to perform specific actions, configure Claude Code, or interact with its features directly from the chat interface.

## How Slash Commands Work

When you type a slash command in the Claude Code chat interface, it is interpreted as an instruction to perform a specific action rather than a message to the AI model. Claude Code processes the command, executes the associated logic, and then provides feedback or performs the requested operation.

## Built-in Slash Commands

Claude Code comes with several built-in slash commands for common tasks:

*   `/help`: Displays a list of available slash commands and their descriptions.
*   `/settings`: Opens the settings editor for Claude Code.
*   `/reset`: Resets the current conversation context.
*   `/undo`: Undoes the last action performed by Claude Code.
*   `/redo`: Redoes the last undone action.
*   `/save [filename]`: Saves the current conversation transcript to a file. If no filename is provided, it saves to a default location.
*   `/load [filename]`: Loads a conversation transcript from a file.
*   `/skills`: Manages custom skills (see [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills)).
*   `/statusline`: Configures the custom status line (see [Status Line Configuration](https://docs.claude.com/en/docs/claude-code/statusline)).
*   `/explain [code]`: Explains a given piece of code.
*   `/refactor [code]`: Refactors a given piece of code.
*   `/test [code]`: Generates tests for a given piece of code.
*   `/debug [code]`: Helps debug a given piece of code.

## Custom Slash Commands

You can also define your own custom slash commands to automate repetitive tasks or integrate with external tools. Custom slash commands are defined in your `.claude/settings.json` file.

### Defining a Custom Command

To define a custom slash command, add a `commands` section to your `.claude/settings.json`:

```json
{
  "commands": [
    {
      "name": "my-custom-command",
      "description": "A custom command that says hello.",
      "command": "echo 'Hello from custom command!'"
    },
    {
      "name": "open-project",
      "description": "Opens a project in VS Code.",
      "command": "code ~/Projects/my-project",
      "parameters": {
        "type": "object",
        "properties": {
          "project_name": {"type": "string", "description": "The name of the project to open.", "default": "my-default-project"}
        }
      }
    }
  ]
}
```

*   `name`: The name of your slash command (e.g., `/my-custom-command`).
*   `description`: A brief description of what the command does. This will appear in the `/help` output.
*   `command`: The shell command to execute when the slash command is invoked.
*   `parameters` (optional): A JSON Schema defining the arguments your command accepts. Claude Code will prompt the user for these arguments if they are not provided.

### Using Custom Commands

Once defined, you can use your custom slash commands directly in the chat:

```
/my-custom-command
/open-project --project_name my-new-project
```

## Best Practices

*   **Clear Names:** Choose descriptive names for your slash commands.
*   **Concise Descriptions:** Provide clear and concise descriptions so users understand what each command does.
*   **Parameter Validation:** Use `parameters` to guide users and ensure valid input.
*   **Error Handling:** Ensure your underlying `command` handles errors gracefully.

## Troubleshooting

*   **Command not found:** Check your `.claude/settings.json` for typos. Ensure the `commands` section is correctly formatted.
*   **Command not executing:** Verify that the `command` specified is executable in your shell environment. Check for correct paths and permissions.
