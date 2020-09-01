$listPath = Split-Path $script:MyInvocation.MyCommand.Path -Parent
$listPath = "$listPath\Services.txt"

$firstService       = Get-Content -Path $listPath -TotalCount 1 | Get-Service -Name {$_}
$firstServiceName   = $firstService.DisplayName

If (($firstService.status) -eq "stopped") {
    $text = "down."
}
Else {
    $text = "up!"
}

"$firstServiceName is currently $($text)`n"

pause