# Ripgrep Configuration

Optimized ripgrep settings for development workflow.

## Configuration File

**Location:** `ripgrep/ripgreprc`
**Loaded via:** `RIPGREP_CONFIG_PATH` environment variable (set in `shell/modules/tools.zsh`)

## Key Optimizations

### Performance
- `--max-columns=300` - Limits line length for faster processing
- `--max-columns-preview` - Shows truncated lines with indicators
- `--threads=0` - Uses all available CPU cores (automatic)
- `--sort=path` - Consistent, predictable output ordering

### Smart Searching
- `--smart-case` - Case-insensitive unless uppercase letters are used
- `--hidden` - Search hidden files (still respects `.gitignore`)
- `--follow` - Follow symbolic links

### Default Exclusions
Beyond `.gitignore`, automatically excludes:
- Build artifacts: `dist/`, `build/`, `.next/`, `.nuxt/`
- Dependencies: `node_modules/`
- Minified files: `*.min.js`, `*.min.css`
- Lock files: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
- System files: `.DS_Store`

### Custom File Types
Optimized for modern web development:
- `--type=web` - HTML, CSS, SCSS, SASS, LESS
- `--type=js` - JS, JSX, MJS, CJS
- `--type=ts` - TS, TSX, MTS, CTS
- `--type=config` - JSON, TOML, YAML, INI, CONF
- `--type=astro` - Astro components
- `--type=vue` - Vue components
- `--type=svelte` - Svelte components

## Usage Examples

```bash
# Search with custom file type
rg "useState" --type=ts

# Search excluding certain patterns (in addition to defaults)
rg "TODO" --glob='!test/*'

# Search only in specific file types
rg "function" --type=js --type=ts

# Override config settings (command-line args take precedence)
rg "pattern" --case-sensitive  # Overrides --smart-case from config

# Disable config temporarily
rg "pattern" --no-config
```

## Testing Configuration

```bash
# See what config is loaded
rg --debug "pattern" 2>&1 | head -20

# Check if RIPGREP_CONFIG_PATH is set
echo $RIPGREP_CONFIG_PATH

# Verify config file location
cat $RIPGREP_CONFIG_PATH
```

## Documentation

- [Official Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)
- [Configuration File Format](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file)
