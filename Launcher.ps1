Param (
    [switch]$elevated,
    [switch]$start,
    [switch]$stop
)

function Test-Admin {

    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    
}

$listPath = Split-Path $script:MyInvocation.MyCommand.Path -Parent
$listPath = "$listPath\Services.txt"

If (($start) -eq $false -and ($stop) -eq $false) {

    $firstService = Get-Content -Path $listPath -TotalCount 1 | Get-Service -Name {$_}
    
    If (($firstService.status) -eq "stopped") {
        $start = $true
    }
    Else {
        $stop = $true
    }
    
}

If ((Test-Admin) -eq $false) {

    If ($elevated) {
    
        # tried to elevate, did not work, aborting
        
    } 
    Else {
    
        $action = $(If ($start) {"start"} Else {"stop"})
            
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated -{1}' -f ($myinvocation.MyCommand.Definition, $action))
        
    }

    exit
    
}

If ($start) {

    Get-Content $listPath | Get-Service -Name {$_} | Where-Object {$_.status -eq 'stopped'} | Start-Service -pass
    
}
Else {

    Get-Content $listPath | Get-Service -Name {$_} | Where-Object {$_.status -eq 'running'} | Stop-Service -pass
    
}