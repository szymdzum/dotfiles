# 🚀 Dotfiles Project Overview for Gemini CLI

This `GEMINI.md` file provides a comprehensive overview of the `dotfiles` repository, designed to serve as instructional context for the Gemini CLI. This project manages personal development environment configurations, including shell settings, editor configurations, and utility tool setups.

## 🎯 Project Purpose

The primary goal of this repository is to centralize, version control, and easily deploy a consistent and optimized development environment across different machines. It focuses on:

*   **Shell Configuration (Zsh):** Providing a modular, performant, and feature-rich Zsh setup with custom aliases, functions, and lazy-loaded tools.
*   **Editor Configuration (Zed):** Customizing the Zed editor for an efficient coding workflow, including keybindings, settings, and task definitions.
*   **Tool Configurations:** Managing configurations for essential development tools like `ripgrep`, `codex`, and the `Gemini CLI` itself.
*   **Secret Management:** Implementing a secure strategy for handling sensitive information (API keys, tokens) without committing them to version control.

## 📂 Architecture Overview

The `dotfiles` project utilizes a **symlink-based configuration system**. Configuration files within this repository are symbolically linked to their expected locations in the home directory (`~`) or `.config` directories. This allows for easy version control and deployment.

### Key Directories and Their Contents:

*   `shell/`: Contains the modular Zsh configuration.
    *   `.zshrc`: The main entry point, orchestrating the loading of various modules.
    *   `modules/`: Individual Zsh modules (e.g., `core.zsh`, `aliases.zsh`, `performance.zsh`, `tools.zsh`, `prompt.zsh`, `functions.zsh`).
*   `zed/`: Zed editor configuration files.
    *   `settings.json`: Core editor settings.
    *   `keymap.json`: Custom keybindings.
    *   `tasks.json`: Development tasks for Zed.
*   `ripgrep/`: Configuration for the `ripgrep` search tool.
    *   `ripgreprc`: Custom `ripgrep` settings, including performance optimizations, smart-case, hidden file search, and custom file type definitions.
*   `gemini/`: Configuration for the Gemini CLI.
    *   `settings.json`: Gemini CLI settings, including tool permissions and context management.
*   `codex/`: Configuration for the Codex CLI.
    *   `config.toml`: Codex CLI configuration, defining model behavior, shell environment policy, and sandbox permissions.
*   `docs/`: Documentation files.
    *   `SECRETS.md`: A comprehensive guide to secret management within this dotfiles setup.
    *   `gemini/`: Contains fetched documentation for the Gemini CLI (extensions, configuration, etc.).
*   `CLAUDE.md`: Guidance and context for the Claude Code AI assistant.
*   `WARP.md`: Guidance and context for the WARP terminal.

### Installation Flow:

The `install.sh` script automates the deployment process:

1.  **Backup:** Creates timestamped backups of existing configuration files.
2.  **Symlink Creation:** Removes old symlinks (if any) and creates new symbolic links from the `dotfiles` repository to the appropriate system locations (e.g., `~/.zshrc`, `~/.config/zed/settings.json`).
3.  **Secret Symlinks:** Creates convenience symlinks within the `dotfiles` directory (e.g., `env.secrets`, `zshrc.local`) that point to actual secret files in the home directory. These convenience symlinks are git-ignored.

## 🛠️ Key Features and Configurations

### Shell (.zshrc)

*   **Modular Design:** Configuration is split into small, focused modules for better organization and maintainability.
*   **Performance Optimizations:** Lazy loading for tools like NVM and PyEnv, cached completions, and disabled expensive Oh-My-Zsh features ensure fast shell startup.
*   **Modern `ls`:** Uses `eza` for colorized, icon-rich file listings with Git status and directory grouping.
*   **Custom Aliases & Functions:** A rich set of aliases for file operations, directory navigation, system information, and development shortcuts.
*   **Secret Loading:** Automatically sources `~/.env.secrets`, `~/.zshrc.local`, and `~/.zshrc.work` if they exist, allowing for secure, untracked environment variables and machine-specific configurations.

### Editor (Zed)

*   **Optimized Settings:** `zed/settings.json` configures Zed for a focused development experience, including manual save/format, Deno LSP integration, and UI preferences.
*   **Custom Keybindings:** `zed/keymap.json` defines personalized keyboard shortcuts.
*   **Development Tasks:** `zed/tasks.json` can define project-specific tasks.

### Ripgrep

*   **AI-Optimized Search:** `ripgrep/ripgreprc` includes settings like `--max-depth=15`, `--dfa-size-limit=1G`, `--smart-case`, `--hidden`, and `--follow`.
*   **Custom File Types:** Extensive `--type-add` definitions for modern web development languages (e.g., `web`, `js`, `ts`, `astro`, `vue`, `svelte`, `config`, `shell`, `docker`, `env`, `markdown`).

### Gemini CLI

*   **Tool Access:** `gemini/settings.json` explicitly allows `read_file`, `list_files`, `write_file`, `replace`, `google_web_search`, and specific `git` commands, enabling comprehensive interaction with the codebase and external resources.
*   **Model Efficiency:** Configured for `gemini-2.5-flash` with shell output efficiency and tool output summarization.

### Codex CLI

*   **Model Configuration:** `codex/config.toml` sets `model = "gpt-5-codex"`, `model_reasoning_effort = "high"`.
*   **Enhanced Capabilities:** Enables web search by default (`search = true`), allows full command execution in the workspace (`sandbox_mode = "workspace-write"`), and configures network access for the sandbox.

### Secret Management

*   **Comprehensive Guide:** `docs/SECRETS.md` details the strategy for managing secrets using `.env.secrets`, `.zshrc.local`, and `.zshrc.work` files, which are loaded by `.zshrc` but are git-ignored.
*   **Security Best Practices:** Includes recommendations for file permissions, regular audits, and optional Git hooks to prevent accidental secret commits.
*   **Convenience Symlinks:** `install.sh` creates symlinks like `env.secrets` within the `dotfiles` directory for easy editing of secret files.

## 🚀 Usage and Development Workflow

### Installation

To set up the dotfiles on a new machine:

```bash
# Clone the repository
git clone <repository-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles

# Run the installation script
./install.sh
```

### Updating

To pull the latest changes and re-apply symlinks:

```bash
cd ~/Developer/dotfiles
git pull
./install.sh # Re-run to update symlinks
```

### Modifying Configurations

*   **Shell:** Edit the relevant module file in `shell/modules/`. After changes, run `source ~/.zshrc` or use the `reload` alias.
*   **Editor (Zed):** Edit files directly in the `zed/` directory. Changes apply immediately due to symlinks.
*   **Secrets:** Edit `env.secrets`, `zshrc.local`, or `zshrc.work` via the convenience symlinks in the `dotfiles` directory. Refer to `docs/SECRETS.md` for details.

### Testing Changes

*   **Shell Syntax Check:** `zsh -n shell/.zshrc`
*   **Isolated Shell Function Test:** `zsh -c "source shell/.zshrc && <command>"`
*   **JSON Validation:** `python3 -m json.tool <file>` (e.g., `zed/settings.json`)

## 🤝 Contributing

Feel free to suggest improvements or report issues. When adding new configurations, update `install.sh` if new symlinks are needed, and document the changes in `README.md` and potentially `CLAUDE.md` or `WARP.md`.
