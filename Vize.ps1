$Processes = @{}
Get-Process  | ForEach-Object {
    $Processes[$_.Id] = $_
}

Get-NetTCPConnection | 
    Where-Object { $_.State } |
    Select-Object RemoteAddress,
        RemotePort,
        @{Name="PID";         Expression={ $_.OwningProcess }},
        @{Name="ProcessName"; Expression={ $Processes[[int]$_.OwningProcess].ProcessName }},
        @{Name="State"; Expression={ $_.State  }}|
    Sort-Object -Property ProcessName, UserName |
    Format-Table -AutoSize | Out-File C:\Temp\1231.txt -Encoding utf8
