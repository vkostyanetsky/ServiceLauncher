Param (
    [switch]$elevated,
    [switch]$start,
    [switch]$stop
)

function Test-Admin {

    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    
}

If (($start) -eq $false -and ($stop) -eq $false) {

    exit
    
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

$ListPath = Split-Path $script:MyInvocation.MyCommand.Path -Parent
$ListPath = "$ListPath\Services.txt"

If ($start) {

    Get-Content $ListPath | Get-Service -Name {$_} | Where-Object {$_.status -eq 'stopped'} | Start-Service -pass
    IISRESET /start
    
}
Else {

    Get-Content $ListPath | Get-Service -Name {$_} | Where-Object {$_.status -eq 'running'} | Stop-Service -pass
    IISRESET /stop    
    
}