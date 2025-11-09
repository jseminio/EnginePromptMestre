Param(
    [string]$Target
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplateRoot = Split-Path -Parent $ScriptDir
if (-not $Target) {
    $Target = (Get-Location).Path
}

$Destination = Join-Path $Target 'ai_orchestrator_suite_v3'

Write-Host "Detectando sistema operacional..." -NoNewline
Write-Host " $([System.Environment]::OSVersion.VersionString)"

if ($TemplateRoot -eq $Destination) {
    Write-Host "Template já está no destino ($Destination). Nenhuma cópia necessária."
    exit 0
}

if (Test-Path $Destination) {
    Write-Host "Estrutura já existente em $Destination."
} else {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
    Copy-Item -Path $TemplateRoot -Destination $Destination -Recurse -Force
    Write-Host "Estrutura criada em $Destination."
}

Write-Host "Próximos passos:" 
Write-Host "  1. Set-Location $Target"
Write-Host "  2. .\\ai_orchestrator_suite_v3\\devops\\ai.ps1 init (ou ./devops/ai.sh init via Git Bash)"
Write-Host "  3. Ajuste config/ai-config.yaml conforme necessário."
