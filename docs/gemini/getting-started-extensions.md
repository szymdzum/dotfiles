# Getting Started with Gemini CLI Extensions

This guide will walk you through the process of creating a Gemini CLI extension.

## Prerequisites

Before you begin, ensure you have the following:

*   **Gemini CLI Installed:** Make sure you have the Gemini CLI installed and configured.
*   **Node.js and npm:** Basic familiarity with Node.js and npm (or yarn/pnpm) is helpful, as extensions are typically written in TypeScript.
*   **Git:** Familiarity with Git for version control.

## 1. Create a New Extension

The easiest way to start is by generating a new extension from a template.

```bash
gemini extensions new my-first-extension --template=typescript
```

This command will create a new directory named `my-first-extension` with a basic TypeScript extension structure.

## 2. Explore the Extension Structure

Navigate into your new extension directory:

```bash
cd my-first-extension
```

You'll find the following key files:

*   `gemini-extension.json`: This is the manifest file for your extension. It defines its name, version, and other metadata.
*   `src/index.ts`: This is the main entry point for your extension's logic.
*   `commands/example.toml`: An example custom command definition.
*   `package.json`: Standard Node.js project file for dependencies.
*   `tsconfig.json`: TypeScript configuration.

## 3. Build and Link for Local Development

To test your extension locally, you need to build it and then link it to your Gemini CLI installation.

```bash
npm install
npm run build
gemini extensions link .
```

*   `npm install`: Installs the necessary Node.js dependencies.
*   `npm run build`: Compiles your TypeScript code into JavaScript.
*   `gemini extensions link .`: Creates a symbolic link from your development directory to the Gemini CLI's extension directory (`~/.gemini/extensions`). This allows you to make changes and test them without constantly reinstalling.

## 4. Add a Custom Command

Extensions can define custom commands that users can execute directly from the Gemini CLI.

Open `commands/example.toml` and you'll see a basic command definition. You can modify this or create new `.toml` files in the `commands/` directory.

**Example `commands/my-command.toml`:**

```toml
name = "my-command"
description = "A custom command from my extension"
command = "echo 'Hello from my custom command!'"
```

After saving your `.toml` file, you might need to restart the Gemini CLI or run `gemini extensions update my-first-extension` for the new command to be recognized.

## 5. Provide Context to the Model

Extensions can provide persistent context to the Gemini model. This is done by placing a `GEMINI.md` file in your extension's root directory.

**Example `GEMINI.md` in your extension:**

```markdown
# My First Extension Context

This extension provides tools for managing my project.

## Commands

*   `my-command`: Does something useful.
```

The content of this `GEMINI.md` will be automatically loaded into the Gemini model's context whenever your extension is active.

## 6. Integrate Custom Tools

Extensions can expose custom tools that the Gemini model can use. These are defined in your `src/index.ts` file.

**Example `src/index.ts`:**

```typescript
import { Extension } from '@gemini-cli/extension';

export default class MyExtension extends Extension {
  async activate() {
    this.registerTool({
      name: 'myCustomTool',
      description: 'A tool that does something custom.',
      parameters: {
        type: 'object',
        properties: {
          input: { type: 'string', description: 'Some input for the tool.' },
        },
        required: ['input'],
      },
      async execute(args: { input: string }) {
        return `Custom tool executed with input: ${args.input}`;
      },
    });
  }
}
```

After building your extension (`npm run build`), the `myCustomTool` will be available to the Gemini model, provided it's allowed in your main `gemini/settings.json`.

## 7. Release Your Extension

Once your extension is ready, you can share it with others.

*   **Git Repository:** Users can install your extension directly from a Git repository:
    ```bash
gemini extensions install https://github.com/your-username/my-first-extension
    ```
*   **GitHub Releases:** You can also package your extension and attach it to a GitHub Release.
