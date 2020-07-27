$listPath = Split-Path $script:MyInvocation.MyCommand.Path -Parent
$listPath = "$listPath\Services.txt"

$firstService       = Get-Content -Path $listPath -TotalCount 1 | Get-Service -Name {$_}
$firstServiceName   = $firstService.DisplayName

If (($firstService.status) -eq "stopped") {
    $text = "$firstServiceName is currently down."
}
Else {
    $text = "$firstServiceName is currently up!"
}

Add-Type -AssemblyName System.Windows.Forms

$global:balmsg = New-Object System.Windows.Forms.NotifyIcon

$path = (Get-Process -id $pid).Path
$balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)

$balmsg.BalloonTipTitle = "Service Launcher"

$balmsg.BalloonTipText = $text
$balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info

$balmsg.Visible = $true

$balmsg.ShowBalloonTip(10000)