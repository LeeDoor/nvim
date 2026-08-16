# Neovim Offline Backup

## Linux

Create archive:

```bash
./scripts/make-nvim-offline-archive.sh
```

Create archive with optional state:

```bash
NVIM_INCLUDE_STATE=1 ./scripts/make-nvim-offline-archive.sh
```

Restore archive:

```bash
./scripts/restore-nvim-offline-archive.sh /path/to/nvim-offline.tar.gz
```

Verify:

```bash
nvim +checkhealth
```

## Windows

Create archive:

```powershell
.\scripts\make-nvim-offline-archive.ps1
```

Create archive with optional state:

```powershell
.\scripts\make-nvim-offline-archive.ps1 -IncludeState
```

Restore archive:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\restore-nvim-offline-archive.ps1 -ArchivePath C:\path\to\nvim-offline.zip
```

Verify:

```vim
:checkhealth
```

## Platform-specific rebuilds

Rebuild on the target platform:

- Tree-sitter parsers
- Mason packages
- Native plugin build outputs

For this config, the main items are:

- `clangd`
- `lua-language-server`
- `stylua`
- `shfmt`
- `marksman`
- `markdownlint-cli2`
- `codelldb`
- Tree-sitter parsers for the languages you use

## Common errors

`Config directory not found`

- `~/.config/nvim` or `%LOCALAPPDATA%\nvim` is missing
- Run the archive script on the machine that has the config

`Data directory not found`

- `~/.local/share/nvim` or `%LOCALAPPDATA%\nvim-data` is missing
- Install and run Neovim once, then rerun the archive script

`Archive not found`

- The path passed to the restore script is wrong

`ExecutionPolicy` blocks PowerShell

- Run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

`Plugin not found`, `module not found`, or `command not found`

- The archive is missing `lazy` or `mason` contents
- Recreate the archive on the source machine

`Parser not found` or Treesitter errors

- The archive is missing `site/parser`
- Recreate the archive on the source machine

`Binary incompatible` or load failures on Windows

- The archive was built on the wrong OS or architecture
- Recreate the archive on the target platform
