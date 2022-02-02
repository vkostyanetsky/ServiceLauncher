Param (
    [switch]$elevated,
    [string]$path
)

function Test-Admin {

    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    
}

# check for privileges

If ((Test-Admin) -eq $false) {

    If ($elevated) {
    
        # tried to elevate, did not work, aborting
        
    } 
    Else {
            
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated -path {1}' -f ($myinvocation.MyCommand.Definition, $path))
        
    }

    exit
    
}

# set manual mode for an each service given

Get-Content $path | Get-Service -Name {$_} | Where-Object {$_.StartupType -ne 'Manual'} | Set-Service -StartupType Manual