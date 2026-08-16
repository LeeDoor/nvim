param(
  [string]$ArchivePath
)

$ErrorActionPreference = "Stop"

function Show-Usage {
  @"
Usage: .\restore-nvim-offline-archive.ps1 -ArchivePath path.zip

Restores an offline Neovim archive into the current Windows user profile.

Environment overrides:
  NVIM_CONFIG_DIR   Config directory, default: `$env:LOCALAPPDATA\nvim
  NVIM_DATA_DIR     Data directory, default: `$env:LOCALAPPDATA\nvim-data
"@
}

if ($ArchivePath -eq "-h" -or $ArchivePath -eq "--help") {
  Show-Usage
  exit 0
}

if ([string]::IsNullOrWhiteSpace($ArchivePath)) {
  Show-Usage
  exit 1
}

if (-not (Test-Path $ArchivePath)) {
  throw "Archive not found: $ArchivePath"
}

$configDir = if ($env:NVIM_CONFIG_DIR) { $env:NVIM_CONFIG_DIR } else { Join-Path $env:LOCALAPPDATA "nvim" }
$dataDir = if ($env:NVIM_DATA_DIR) { $env:NVIM_DATA_DIR } else { Join-Path $env:LOCALAPPDATA "nvim-data" }

$parent = Join-Path ([System.IO.Path]::GetTempPath()) ("nvim-restore-" + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Force -Path $parent | Out-Null

Expand-Archive -Path $ArchivePath -DestinationPath $parent -Force

$rootItems = @(
  @{ Source = Join-Path $parent ".config\nvim"; Destination = $configDir },
  @{ Source = Join-Path $parent ".local\share\nvim\lazy"; Destination = (Join-Path $dataDir "lazy") },
  @{ Source = Join-Path $parent ".local\share\nvim\mason"; Destination = (Join-Path $dataDir "mason") },
  @{ Source = Join-Path $parent ".local\share\nvim\site\parser"; Destination = (Join-Path $dataDir "site\parser") },
  @{ Source = Join-Path $parent ".local\share\nvim\site\parser-info"; Destination = (Join-Path $dataDir "site\parser-info") },
  @{ Source = Join-Path $parent ".local\share\nvim\snacks"; Destination = (Join-Path $dataDir "snacks") },
  @{ Source = Join-Path $parent ".local\share\nvim\scratch"; Destination = (Join-Path $dataDir "scratch") }
)

foreach ($item in $rootItems) {
  if (-not (Test-Path $item.Source)) {
    continue
  }
  New-Item -ItemType Directory -Force -Path (Split-Path $item.Destination -Parent) | Out-Null
  Copy-Item -Path $item.Source -Destination $item.Destination -Recurse -Force
}

Remove-Item $parent -Recurse -Force
Write-Host "Restored archive into: $env:LOCALAPPDATA"
