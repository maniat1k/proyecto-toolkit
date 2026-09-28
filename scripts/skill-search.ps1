param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Query
)

$ErrorActionPreference = "Stop"

$results = @()
$tokens = @(
    $Query.ToLowerInvariant() -split "\s+" |
    Where-Object { $_ }
)

function Add-Candidate {
    param(
        [string]$Name,
        [string]$Description,
        [string]$Source,
        [string]$SourceUrl
    )

    if (!$Name -or !$Description) {
        return
    }

    $nameLower = $Name.ToLowerInvariant()
    $descriptionLower = $Description.ToLowerInvariant()
    $score = 0

    foreach ($token in $tokens) {
        if ($nameLower -eq $token) {
            $score += 10
        }
        elseif ($nameLower -like "*$token*") {
            $score += 5
        }

        if ($descriptionLower -like "*$token*") {
            $score += 2
        }
    }

    if ($score -gt 0) {
        $script:results += [pscustomobject]@{
            SCORE       = $score
            NAME        = $Name
            DESCRIPTION = $Description
            SOURCE      = $Source
            SOURCE_URL  = $SourceUrl
        }
    }
}

# ----------------------------------------------------------------------
# Provider 1: GitHub Awesome Copilot
# ----------------------------------------------------------------------

$awesomeRepository = "github/awesome-copilot"
$awesomeIndexUrl = "https://raw.githubusercontent.com/$awesomeRepository/main/docs/README.skills.md"

try {
    $content = (
        Invoke-WebRequest `
            -Uri $awesomeIndexUrl `
            -UseBasicParsing `
            -TimeoutSec 15
    ).Content

    foreach ($line in ($content -split "`n")) {
        if ($line -match "\[([^\]]+)\]\(([^)]+)\)") {
            $name = $matches[1].Trim()

            $clean = (
                $line `
                    -replace "<br\s*/?>", " " `
                    -replace "``[^``]+``", " " `
                    -replace "\[([^\]]+)\]\([^)]+\)", '$1' `
                    -replace "\|", " " `
                    -replace "\s+", " "
            ).Trim()

            $description = (
                $clean -replace [regex]::Escape($name), ""
            ).Trim(" ", "-", "|")

            if (!$description) {
                $description = "Skill: " + ($name -replace "-", " ")
            }

            Add-Candidate `
                -Name $name `
                -Description $description `
                -Source "github-awesome-copilot" `
                -SourceUrl "https://github.com/$awesomeRepository"
        }
    }
}
catch {
    Write-Warning "No fue posible consultar GitHub Awesome Copilot: $($_.Exception.Message)"
}

# ----------------------------------------------------------------------
# Provider 2: Anthropic Skills
# ----------------------------------------------------------------------

$anthropicRepository = "anthropics/skills"
$anthropicTreeUrl = "https://api.github.com/repos/$anthropicRepository/git/trees/main?recursive=1"

try {
    $headers = @{
        "User-Agent" = "proyecto-toolkit"
        "Accept"     = "application/vnd.github+json"
    }

    $tree = Invoke-RestMethod `
        -Uri $anthropicTreeUrl `
        -Headers $headers `
        -TimeoutSec 15

    $skillFiles = @(
        $tree.tree |
        Where-Object {
            $_.type -eq "blob" -and
            $_.path -match '^skills/[^/]+/SKILL\.md$'
        }
    )

    foreach ($skillFile in $skillFiles) {
        try {
            $rawUrl = "https://raw.githubusercontent.com/$anthropicRepository/main/$($skillFile.path)"

            $skillContent = (
                Invoke-WebRequest `
                    -Uri $rawUrl `
                    -UseBasicParsing `
                    -TimeoutSec 15
            ).Content

            if ($skillContent -match '(?ms)^---\s*\r?\n(.*?)\r?\n---') {
                $frontmatter = $matches[1]

                $name = $null
                $description = $null

                if ($frontmatter -match '(?m)^name:\s*(.+?)\s*$') {
                    $name = $matches[1].Trim().Trim('"').Trim("'")
                }

                if ($frontmatter -match '(?m)^description:\s*(.+?)\s*$') {
                    $description = $matches[1].Trim().Trim('"').Trim("'")
                }

                if ($name -and $description) {
                    Add-Candidate `
                        -Name $name `
                        -Description $description `
                        -Source "anthropic" `
                        -SourceUrl "https://github.com/$anthropicRepository/blob/main/$($skillFile.path)"
                }
            }
        }
        catch {
            Write-Warning "No fue posible leer Anthropic Skill $($skillFile.path): $($_.Exception.Message)"
        }
    }
}
catch {
    Write-Warning "No fue posible consultar Anthropic Skills: $($_.Exception.Message)"
}

# ----------------------------------------------------------------------
# Resultado común
# ----------------------------------------------------------------------

if (!$results) {
    Write-Host "Sin resultados para: $Query"
    exit 0
}

$results |
    Sort-Object @{ Expression = "SCORE"; Descending = $true }, NAME |
    Group-Object NAME |
    ForEach-Object {
        $_.Group | Select-Object -First 1
    } |
    Sort-Object @{ Expression = "SCORE"; Descending = $true }, NAME |
    Select-Object -First 10 `
        NAME,
        @{
            Name = "DESCRIPTION"
            Expression = {
                $prefix = switch ($_.SOURCE) {
                    "github-awesome-copilot" { "[cop]" }
                    "anthropic"              { "[cla]" }
                    default                  { "[???]" }
                }

                "$prefix $($_.DESCRIPTION)"
            }
        } |
    Format-Table -Wrap -AutoSize