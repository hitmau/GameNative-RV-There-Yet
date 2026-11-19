param(
    [string]$SourcePath = 'D:\SteamLibrary\steamapps\common\Ride',
    [string]$DeviceSerial,
    [string]$ApkPath = (Join-Path $PSScriptRoot '..\app\build\outputs\apk\modern\rvthereyet\app-modern-rvthereyet.apk'),
    [double]$RuntimeReserveGiB = 5,
    [switch]$SkipAppInstall,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

$resolvedSource = (Resolve-Path -LiteralPath $SourcePath).Path
$resolvedApk = $null
if (-not $SkipAppInstall) {
    $resolvedApk = (Resolve-Path -LiteralPath $ApkPath).Path
}
$requiredRelativeFiles = @(
    'Ride\Binaries\Win64\Ride-Win64-Shipping.exe',
    'Ride\Content\Paks\Ride-Windows.ucas',
    'Ride\Content\Paks\Ride-Windows.utoc',
    'Engine\Binaries'
)

foreach ($relativePath in $requiredRelativeFiles) {
    $requiredPath = Join-Path $resolvedSource $relativePath
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "A instalação não parece completa: falta $requiredPath"
    }
}

$adbPath = Join-Path $env:LOCALAPPDATA 'Android\Sdk\platform-tools\adb.exe'
if (-not (Test-Path -LiteralPath $adbPath)) {
    throw "ADB não encontrado em $adbPath. Instale o Android SDK Platform Tools ou ajuste o caminho no script."
}

$deviceOutput = & $adbPath devices -l
if ($LASTEXITCODE -ne 0) {
    throw 'Falha ao consultar dispositivos ADB.'
}
$connected = @(
    $deviceOutput | Select-Object -Skip 1 | Where-Object { $_ -match '^\S+\s+device\b' }
)
if ($DeviceSerial) {
    $connected = @($connected | Where-Object { ($_ -split '\s+')[0] -eq $DeviceSerial })
}

if (-not $WhatIf -and $connected.Count -ne 1) {
    throw "Conecte exatamente um aparelho Android autorizado por ADB. Dispositivos prontos: $($connected.Count)."
}
$serial = if ($connected.Count -eq 1) { ($connected[0] -split '\s+')[0] } else { '(a conectar)' }

$sourceBytes = (Get-ChildItem -LiteralPath $resolvedSource -File -Recurse -Force |
    Measure-Object -Property Length -Sum).Sum
$sourceGiB = [math]::Round($sourceBytes / 1GB, 2)
$minimumFreeBytes = [long]($sourceBytes * 2 + ($RuntimeReserveGiB * 1GB))
$minimumFreeGiB = [math]::Round($minimumFreeBytes / 1GB, 2)
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$remoteParent = "/sdcard/Download/RVThereYet-Import-$timestamp"
$remoteGame = "$remoteParent/Ride"

$deviceFreeGiB = $null
if ($connected.Count -eq 1) {
    $dfOutput = & $adbPath -s $serial shell df -k /sdcard
    if ($LASTEXITCODE -ne 0) {
        throw 'Não foi possível consultar o espaço livre no Android.'
    }
    $dfRow = $dfOutput | Where-Object { $_ -match '^\S+\s+\d+\s+\d+\s+\d+\s+\d+%' } | Select-Object -Last 1
    if (-not $dfRow) {
        throw "A resposta de df do Android não pôde ser interpretada: $($dfOutput -join ' | ')"
    }
    $dfColumns = $dfRow.Trim() -split '\s+'
    $availableBytes = [long]$dfColumns[3] * 1KB
    $deviceFreeGiB = [math]::Round($availableBytes / 1GB, 2)
    if ($availableBytes -lt $minimumFreeBytes) {
        throw "Espaço insuficiente no Android: $deviceFreeGiB GiB livres; reserve pelo menos $minimumFreeGiB GiB para a cópia, a importação do app e uma margem de runtime ($RuntimeReserveGiB GiB)."
    }
}

Write-Host "Jogo: RV There Yet?"
Write-Host "Origem: $resolvedSource"
Write-Host "Tamanho estimado: $sourceGiB GiB"
Write-Host "Espaço recomendado para cópia + importação + margem de runtime: $minimumFreeGiB GiB"
Write-Host "Dispositivo: $serial"
if (-not $SkipAppInstall) {
    Write-Host "APK a instalar: $resolvedApk"
}
if ($null -ne $deviceFreeGiB) {
    Write-Host "Espaço livre detectado: $deviceFreeGiB GiB"
} else {
    Write-Host 'Espaço livre do Android não verificado (nenhum dispositivo conectado durante a prévia).'
}
Write-Host "Destino temporário: $remoteGame"
Write-Host 'O app copiará a pasta novamente durante a importação; reserve espaço para as duas cópias e para o runtime.'

if ($WhatIf) {
    Write-Host 'Prévia concluída; nenhum arquivo foi transferido.'
    return
}

& $adbPath -s $serial shell mkdir -p $remoteParent
if ($LASTEXITCODE -ne 0) {
    throw 'Não foi possível criar a pasta de transferência no Android.'
}

& $adbPath -s $serial push $resolvedSource $remoteParent
if ($LASTEXITCODE -ne 0) {
    throw 'A transferência ADB falhou. A pasta parcial foi mantida para inspeção; a origem no PC não foi alterada.'
}

$filesToVerify = @(
    'Ride/Binaries/Win64/Ride-Win64-Shipping.exe',
    'Ride/Content/Paks/Ride-Windows.ucas',
    'Ride/Content/Paks/Ride-Windows.utoc'
)
foreach ($relativePath in $filesToVerify) {
    $localPath = Join-Path $resolvedSource ($relativePath -replace '/', '\')
    $remotePath = "$remoteGame/$relativePath"
    $remoteBytesOutput = & $adbPath -s $serial shell "wc -c < '$remotePath'"
    if ($LASTEXITCODE -ne 0) {
        throw "Não foi possível verificar o tamanho remoto de $relativePath. A cópia foi mantida."
    }
    $remoteBytesText = ($remoteBytesOutput | Out-String).Trim()
    try {
        $remoteBytes = [long]::Parse($remoteBytesText, [Globalization.CultureInfo]::InvariantCulture)
    } catch {
        throw "Resposta de tamanho inválida para ${relativePath}: $remoteBytesText"
    }
    $localBytes = (Get-Item -LiteralPath $localPath).Length
    if ($remoteBytes -ne $localBytes) {
        throw "Tamanho diferente para ${relativePath}: PC=$localBytes, Android=$remoteBytes. A cópia foi mantida."
    }
}

Write-Host 'Transferência concluída; tamanho do executável e dos dois arquivos IoStore confirmado.'
Write-Host "No GameNative, importe a pasta: $remoteGame"
if (-not $SkipAppInstall) {
    & $adbPath -s $serial install -r $resolvedApk
    if ($LASTEXITCODE -ne 0) {
        throw "O jogo foi copiado, mas a instalação do APK falhou. A cópia permanece em $remoteGame."
    }
    $packagePath = & $adbPath -s $serial shell pm path app.gamenative.rvthereyet
    if ($LASTEXITCODE -ne 0 -or -not ($packagePath -match 'package:')) {
        throw "O APK foi enviado ao Android, mas o pacote app.gamenative.rvthereyet não foi confirmado."
    }
    Write-Host 'APK instalado como app separado; a instalação oficial e os dados existentes permanecem intactos.'
} else {
    Write-Host 'Instalação do APK ignorada por -SkipAppInstall.'
}
