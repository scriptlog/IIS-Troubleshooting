Write-Host "=== IIS Troubleshooting Script (PowerShell) ===" -ForegroundColor Cyan

Write-Host "`n[1] Cek versi IIS..." -ForegroundColor Yellow
try {
    $iisVersion = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\InetStp" -Name "VersionString" -ErrorAction Stop
    Write-Host "IIS Version: $($iisVersion.VersionString)" -ForegroundColor Green
} catch {
    Write-Host "IIS tidak terdeteksi atau registry tidak ditemukan." -ForegroundColor Red
}

$basePath = "C:\inetpub\wwwroot\scriptlog"
$folders = @(
    "public\log",
    "public\cache",
    "public\themes",
    "admin\plugins"
)

Write-Host "`n[2] Ambil alih kepemilikan folder..." -ForegroundColor Yellow
foreach ($folder in $folders) {
    $fullPath = Join-Path $basePath $folder
    if (Test-Path $fullPath) {
        takeown /f $fullPath /r /d y
    } else {
        Write-Host "Folder tidak ditemukan: $fullPath" -ForegroundColor Red
    }
}

Write-Host "`n[3] Grant full control ke Administrator..." -ForegroundColor Yellow
foreach ($folder in $folders) {
    $fullPath = Join-Path $basePath $folder
    if (Test-Path $fullPath) {
        icacls $fullPath /grant "Administrators:(OI)(CI)F"
    }
}

Write-Host "`n[4] Hapus atribut read-only..." -ForegroundColor Yellow
foreach ($folder in $folders) {
    $fullPath = Join-Path $basePath $folder
    if (Test-Path $fullPath) {
        attrib -r $fullPath /s /d
    }
}

Write-Host "`n[5] Grant Modify ke App Pool Scriptlog..." -ForegroundColor Yellow
foreach ($folder in $folders) {
    $fullPath = Join-Path $basePath $folder
    if (Test-Path $fullPath) {
        icacls $fullPath /grant "IIS AppPool\Scriptlog:(OI)(CI)M"
    }
}

Write-Host "`n[6] Restart IIS..." -ForegroundColor Yellow
iisreset

Write-Host "`n=== Selesai ===" -ForegroundColor Cyan
