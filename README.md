# IIS Troubleshooting

A collection of scripts to troubleshoot common IIS permissions and configuration issues on Windows.

## Scripts

| File | Description |
|------|-------------|
| `troubleshoot-iis.ps1` | PowerShell script with colored output, error handling, and folder validation |
| `troubleshoot-iis.bat` | Batch script for Windows Command Prompt |

## What It Does

1. **Check IIS version** - Queries the registry to display the installed IIS version.
2. **Take ownership** - Recursively takes ownership of ScriptLog folders (`public/log`, `public/cache`, `public/themes`, `admin/plugins`).
3. **Grant Administrator full control** - Applies `(OI)(CI)F` permissions to Administrators.
4. **Remove read-only attribute** - Strips the read-only flag recursively.
5. **Grant AppPool modify access** - Gives `(OI)(CI)M` permissions to `IIS AppPool\Scriptlog`.
6. **Restart IIS** - Runs `iisreset` to apply all changes.

## Usage

### PowerShell (Run as Administrator)

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\troubleshoot-iis.ps1
```

### Command Prompt (Run as Administrator)

```cmd
troubleshoot-iis.bat
```

> **Note:** Both scripts **must be run as Administrator** for `takeown`, `icacls`, and `iisreset` to work.

## Requirements

- Windows Server / Windows 10+
- IIS installed with ScriptLog deployed at `C:\inetpub\wwwroot\scriptlog`
- Administrator privileges

## License

[CC0 1.0 Universal (Public Domain)](LICENSE)
