$ErrorActionPreference = "Stop"

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) {
        throw "FALLO: $Message"
    }
}

$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("proyecto-bootstrap-" + [guid]::NewGuid().ToString("N"))
$toolkitRoot = Join-Path $testRoot "toolkit"
$projectsRoot = Join-Path $testRoot "projects"
$projectName = "bootstrap-regression"
$projectPath = Join-Path $projectsRoot $projectName

try {
    New-Item -ItemType Directory -Path $toolkitRoot, $projectsRoot -Force | Out-Null
    Copy-Item (Join-Path $PSScriptRoot "..\proyecto.ps1") $toolkitRoot
    Copy-Item (Join-Path $PSScriptRoot "..\HELP.txt") $toolkitRoot
    Copy-Item (Join-Path $PSScriptRoot "..\config") $toolkitRoot -Recurse
    Copy-Item (Join-Path $PSScriptRoot "..\standards") $toolkitRoot -Recurse
    Copy-Item (Join-Path $PSScriptRoot "..\templates") $toolkitRoot -Recurse
    Copy-Item (Join-Path $PSScriptRoot "..\prompts") $toolkitRoot -Recurse

    @{ projects_root = $projectsRoot } |
        ConvertTo-Json |
        Set-Content (Join-Path $toolkitRoot "config\toolkit.json") -Encoding UTF8

    $cli = Join-Path $toolkitRoot "proyecto.ps1"
    & $cli init $projectName 6>&1 | Out-Null

    $pendingContext = Get-Content (Join-Path $projectPath "CONTEXT.md") -Raw
    Assert-True ($pendingContext -match '(?im)^\*\*Estado:\*\*\s*PENDIENTE\s*$') "CONTEXT.md debe comenzar con el bootstrap PENDIENTE."

    $pendingOutput = (& $cli valida $projectName 6>&1) -join [Environment]::NewLine
    Assert-True ($pendingOutput -match '(?m)^# Bootstrap inicial de Proyecto\r?$') "valida debe emitir el prompt mientras el estado sea PENDIENTE."
    Assert-True ($pendingOutput -match '(?m)^  \*\*Estado:\*\* COMPLETADO\r?$') "el prompt debe exigir el marcador estructurado exacto."
    Assert-True ($pendingOutput -match 'no sustituyas.+frase narrativa equivalente') "el prompt debe prohibir reemplazar el marcador por texto narrativo."

    $completedContext = $pendingContext -replace '(?im)^\*\*Estado:\*\*\s*PENDIENTE\s*$', '**Estado:** COMPLETADO'
    $completedContext += "`r`nContexto consolidado que debe preservarse.`r`n"
    Set-Content (Join-Path $projectPath "CONTEXT.md") $completedContext -Encoding UTF8

    $completedOutput = (& $cli valida $projectName 6>&1) -join [Environment]::NewLine
    Assert-True ($completedOutput -notmatch '(?m)^# Bootstrap inicial de Proyecto\r?$') "valida no debe volver a emitir el prompt con el marcador COMPLETADO."
    Assert-True ($completedOutput -match 'VALIDO - Cumple Proyecto 0\.2\.2') "valida debe continuar con la validación estructural normal."

    $finalContext = Get-Content (Join-Path $projectPath "CONTEXT.md") -Raw
    Assert-True ($finalContext -match '(?m)^Contexto consolidado que debe preservarse\.\r?$') "el contexto consolidado debe permanecer intacto."

    Write-Output "OK - Regresión de cierre de bootstrap validada."
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        $resolvedTestRoot = (Resolve-Path -LiteralPath $testRoot).Path
        $resolvedTempRoot = (Resolve-Path -LiteralPath ([System.IO.Path]::GetTempPath())).Path
        if ($resolvedTestRoot.StartsWith($resolvedTempRoot, [System.StringComparison]::OrdinalIgnoreCase) -and
            (Split-Path -Leaf $resolvedTestRoot).StartsWith("proyecto-bootstrap-")) {
            Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
        }
    }
}
