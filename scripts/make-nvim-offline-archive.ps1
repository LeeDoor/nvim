param(
  [string]$OutputArchive = "",
  [switch]$IncludeState
)

$ErrorActionPreference = "Stop"

function Show-Usage {
  @"
Usage: .\make-nvim-offline-archive.ps1 [-OutputArchive path] [-IncludeState]

Creates an offline Neovim archive for Windows.

Included by default:
  `$env:LOCALAPPDATA\nvim
  `$env:LOCALAPPDATA\nvim-data\lazy
  `$env:LOCALAPPDATA\nvim-data\mason
  `$env:LOCALAPPDATA\nvim-data\site\parser
  `$env:LOCALAPPDATA\nvim-data\site\parser-info

Optional state:
  -IncludeState also includes:
    `$env:LOCALAPPDATA\nvim-data\snacks
    `$env:LOCALAPPDATA\nvim-data\scratch

Environment overrides:
  NVIM_CONFIG_DIR   Config directory, default: `$env:LOCALAPPDATA\nvim
  NVIM_DATA_DIR     Data directory, default: `$env:LOCALAPPDATA\nvim-data
"@
}

if ($args -contains "-h" -or $args -contains "--help") {
  Show-Usage
  exit 0
}

$configDir = if ($env:NVIM_CONFIG_DIR) { $env:NVIM_CONFIG_DIR } else { Join-Path $env:LOCALAPPDATA "nvim" }
$dataDir = if ($env:NVIM_DATA_DIR) { $env:NVIM_DATA_DIR } else { Join-Path $env:LOCALAPPDATA "nvim-data" }

if (-not (Test-Path $configDir)) {
  throw "Config directory not found: $configDir"
}

if (-not (Test-Path $dataDir)) {
  throw "Data directory not found: $dataDir"
}

if ([string]::IsNullOrWhiteSpace($OutputArchive)) {
  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $OutputArchive = Join-Path $env:USERPROFILE "nvim-offline-$stamp.zip"
}

$staging = Join-Path ([System.IO.Path]::GetTempPath()) ("nvim-offline-" + [guid]::NewGuid().ToString())
$stagingRoot = Join-Path $staging "root"

New-Item -ItemType Directory -Force -Path $stagingRoot | Out-Null

$targets = @(
  @{ Source = $configDir; Relative = ".config\nvim" },
  @{ Source = (Join-Path $dataDir "lazy"); Relative = ".local\share\nvim\lazy" },
  @{ Source = (Join-Path $dataDir "mason"); Relative = ".local\share\nvim\mason" },
  @{ Source = (Join-Path $dataDir "site\parser"); Relative = ".local\share\nvim\site\parser" },
  @{ Source = (Join-Path $dataDir "site\parser-info"); Relative = ".local\share\nvim\site\parser-info" }
)

if ($IncludeState -or $env:NVIM_INCLUDE_STATE -eq "1") {
  $snacks = Join-Path $dataDir "snacks"
  $scratch = Join-Path $dataDir "scratch"
  if (Test-Path $snacks) {
    $targets += @{ Source = $snacks; Relative = ".local\share\nvim\snacks" }
  }
  if (Test-Path $scratch) {
    $targets += @{ Source = $scratch; Relative = ".local\share\nvim\scratch" }
  }
}

foreach ($item in $targets) {
  if (-not (Test-Path $item.Source)) {
    continue
  }
  $dest = Join-Path $stagingRoot $item.Relative
  New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
  Copy-Item -Path $item.Source -Destination $dest -Recurse -Force
}

if (Test-Path $OutputArchive) {
  Remove-Item $OutputArchive -Force
}

Compress-Archive -Path (Join-Path $stagingRoot "*") -DestinationPath $OutputArchive
Remove-Item $staging -Recurse -Force

Write-Host "Created archive: $OutputArchive"
