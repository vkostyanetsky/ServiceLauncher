Param (
    [switch]$elevated,
    [switch]$start,
    [switch]$stop,
    [string]$path
)

function Test-Admin {

    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    
}

# decide what to do (no parameters given)

If (($start) -eq $false -and ($stop) -eq $false) {

    $firstService = Get-Content -Path $path -TotalCount 1 | Get-Service -Name {$_}
    
    If (($firstService.status) -eq "stopped") {
        $start = $true
    }
    Else {
        $stop = $true
    }
    
}

# check for privileges

If ((Test-Admin) -eq $false) {

    If ($elevated) {
    
        # tried to elevate, did not work, aborting
        
    } 
    Else {
    
        $action = $(If ($start) {"start"} Else {"stop"})
        
            
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated -{1} -path {2}' -f ($myinvocation.MyCommand.Definition, $action, $path))
        
    }

    exit
    
}

# to be, or not to be, that is the question

If ($start) {

    Get-Content $path | Get-Service -Name {$_} | Where-Object {$_.status -eq 'stopped'} | Start-Service -pass
    
}
Else {

    Get-Content $path | Get-Service -Name {$_} | Where-Object {$_.status -eq 'running'} | Stop-Service -pass
    
}