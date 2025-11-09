Param(
    [Parameter(Position = 0)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$RootDir = Split-Path -Parent $PSScriptRoot
$ConfigFile = Join-Path $RootDir 'config/ai-config.yaml'
$RouteScript = Join-Path $RootDir 'devops/route.sh'

function Get-ConfigValue($Key) {
    if (-not (Test-Path $ConfigFile)) {
        return $null
    }
    $line = Get-Content $ConfigFile | Where-Object { $_ -match "^$Key:\s*(.*)$" } | Select-Object -First 1
    if ($null -ne $line) {
        $value = $line -replace "^$Key:\s*", ''
        return $value.Trim('"')
    }
    return $null
}

$DefaultEngine = Get-ConfigValue 'engine'
if ([string]::IsNullOrWhiteSpace($DefaultEngine)) { $DefaultEngine = 'auto' }
$DefaultHistory = Get-ConfigValue 'history_policy'
if ([string]::IsNullOrWhiteSpace($DefaultHistory)) { $DefaultHistory = 'strict' }
$DefaultDecision = Get-ConfigValue 'decision_mode'
if ([string]::IsNullOrWhiteSpace($DefaultDecision)) { $DefaultDecision = 'DE ACORDO' }

if (-not $Command) {
    Write-Host "Uso: ./ai.ps1 <init|run> [opções]"
    exit 64
}

switch ($Command.ToLower()) {
    'init' {
        New-Item -ItemType Directory -Path (Join-Path $RootDir '.runs') -Force | Out-Null
        New-Item -ItemType Directory -Path (Join-Path $RootDir '.devops') -Force | Out-Null
        Write-Host "AI Orchestrator Suite v2 inicializado. Engine padrão: $DefaultEngine."
    }
    'run' {
        if ($Args.Count -lt 2) {
            Write-Error "Informe agente e task." -ErrorAction Stop
        }
        $Agent = $Args[0]
        $Task = $Args[1]
        $Engine = $DefaultEngine
        $History = $DefaultHistory
        $Decision = $DefaultDecision
        $Extra = $null
        $Positionals = @()

        for ($i = 2; $i -lt $Args.Count; $i++) {
            $arg = $Args[$i]
            if ($arg -like '--engine=*') {
                $Engine = $arg.Split('=')[1]
            } elseif ($arg -like '--history=*') {
                $History = $arg.Split('=')[1]
            } elseif ($arg -like '--decision=*') {
                $Decision = $arg.Substring($arg.IndexOf('=') + 1)
            } elseif ($arg -eq '--extra') {
                $i++
                if ($i -lt $Args.Count) { $Extra = $Args[$i] }
            } else {
                $Positionals += $arg
            }
        }

        $bash = Get-Command bash -ErrorAction SilentlyContinue
        if (-not $bash) {
            Write-Error "bash não encontrado no PATH. Instale Git Bash ou WSL." -ErrorAction Stop
        }

        $routeArgs = @("$RouteScript", "--engine=$Engine", "--history=$History", "--decision=$Decision", '--', 'run', $Agent, $Task)
        if ($Extra) {
            $routeArgs += @('--context', $Extra)
        }
        if ($Positionals.Count -gt 0) {
            $routeArgs += $Positionals
        }

        & $bash $routeArgs
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    }
    Default {
        Write-Error "Comando '$Command' não reconhecido."
        exit 64
    }
}
