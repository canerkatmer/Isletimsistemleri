New-Item -Path "C:\" -Name "LOGS" -ItemType "directory"
$trigger = New-JobTrigger -At "22/01/2021 16:22" -RepetitionInterval (New-TimeSpan -Minutes 1) -RepeatIndefinitely $true
$A = New-ScheduledJobOption -RunElevated
$is={

$cr = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
   $tarih = Get-Date -Format "HH mm ss dddd MM/dd/yyyy"
    $tut = Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | 
    Where-Object {$_.Name -notmatch "^(idle|_total|system)$" -and $_.PercentProcessorTime -gt 40} |
    Format-Table -Autosize -Property @{Name = "CPU"; Expression = {[int]($_.PercentProcessorTime/$cr)}}, Name, @{Name = "PID"; Expression = {$_.IDProcess}},@{"Name" = "WSP(MB)"; Expression = {[int]($_.WorkingSetPrivate/1mb)}}

  $tut | Out-File -FilePath C:\LOGS\$tarih.txt
}

Register-ScheduledJob "Final" -Trigger $trigger -ScheduledJobOption $A -ScriptBlock $is

#tarih kısmını ayarlamayı unutmayın ^^
#Unregister-ScheduledJob 'Final'
