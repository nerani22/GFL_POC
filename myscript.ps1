# myscript.ps1 - POC Windows script

Write-Host "===== POC Script: Basic System Check ====="
Write-Host "Host: $env:COMPUTERNAME"
Write-Host "OS Version: $(Get-ComputerInfo | Select-Object -ExpandProperty WindowsProductName) $(Get-ComputerInfo | Select-Object -ExpandProperty WindowsVersion)"
Write-Host "Kernel: $(Get-CimInstance Win32_OperatingSystem).Version"
Write-Host "Uptime: $(New-TimeSpan -Start (Get-CimInstance Win32_OperatingSystem).LastBootUpTime -End (Get-Date))"

Write-Host "`n===== Resource Usage ====="
Write-Host "Memory (Total/Available):"
Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize,FreePhysicalMemory

Write-Host "`nDisk Usage:"
Get-PSDrive -PSProvider FileSystem | Select-Object Name,Used,Free,Root

Write-Host "`n===== Top CPU processes (5) ====="
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table -Property ID,ProcessName,CPU,WS

Write-Host "`n===== Connectivity Check ====="
try {
    Test-Connection -ComputerName 8.8.8.8 -Count 2 -ErrorAction Stop | ForEach-Object { Write-Host "$($_.Address) reachable" }
} catch {
    Write-Host "Internet: FAILED (ping 8.8.8.8)"
}

Write-Host "`n===== POC Script Completed ====="
