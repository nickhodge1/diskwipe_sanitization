$disks                      = Get-Disk
$global:DISKPART_SCRIPT     = "unattend.txt"
$global:disk_Id_To_Sanitize = "xxx"
$global:number_Of_Passes    = 0
$confirm_To_Sanitize        = $null
$disk_IDs                   = [System.Collections.ArrayList]@()
$SYSTEM_DRIVE               = $Env:Systemdrive

Function gather-Input-From-User() {
    clear
    Write-Host
    Write-Host "----------------------------------- Disk Information -----------------------------------"
    Write-Host

    foreach ($disk in $disks) {
        Write-Host "Disk ID:        $($disk.Number)" -ForegroundColor Red
        Write-Host "Disk Name:      $($disk.FriendlyName)"
        Write-Host "Disk Size:      $($disk.Size / 1GB) GB"
        Write-Host "Disk Partition: $($disk.PartitionStyle)"
        Write-Host
        $disk_IDs.Add($disk.Number) | Out-Null
    }

    Write-Host "----------------------------------------------------------------------------------------"

    if (($disks.Count -lt 2) -or ($disks.Count -eq $null)) {
         Write-Host "This system has less than 2 disks attached to it. Quitting to avoid wiping the USB drive" -BackgroundColor Black -ForegroundColor Red
         exit
    }

    do {
        Write-Host "Enter the Disk ID for the disk you want to sanitize." -BackgroundColor Black -ForegroundColor Yellow
        $user_Input = Read-Host
        $global:disk_Id_To_Sanitize = $user_Input

        if (-Not ($disk_IDs -contains $global:disk_Id_To_Sanitize)) {
            Clear
            Write-Host "Invalid Disk ID entered. See valid Disk IDs below:" -BackgroundColor Black -ForegroundColor DarkYellow
            Write-Host "----------------------------------- Disk Information -----------------------------------"
            foreach ($disk in $disks) {
                Write-Host "Disk ID:        $($disk.Number)" -ForegroundColor Red
                Write-Host "Disk Name:      $($disk.FriendlyName)"
                Write-Host "Disk Size:      $($disk.Size / 1GB) GB"
                Write-Host "Disk Partition: $($disk.PartitionStyle)"
                Write-Host
            }
            Write-Host "----------------------------------------------------------------------------------------"
        }
    } while (-Not ($disk_IDs -contains $global:disk_Id_To_Sanitize))

    Clear
    do {
        Write-Host "Enter the desired number of passes.`nEach pass will 'zero' the drive. (Recommended 10)" -BackgroundColor Black -ForegroundColor Yellow
        $user_Input = Read-Host
        try {
            $global:number_Of_Passes = [int]$user_Input
        } catch {
            $global:number_Of_Passes = 0
        }
    } while ($global:number_Of_Passes -lt 1 -or $global:number_Of_Passes -gt 99)

    Clear
    do {
        Write-Host "----------------------------------- Disk Information -----------------------------------"
        foreach ($disk in $disks) {
            Write-Host "Disk ID:        $($disk.Number)"
            Write-Host "Disk Name:      $($disk.FriendlyName)"
            Write-Host "Disk Size:      $($disk.Size / 1GB) GB"
            Write-Host "Disk Partition: $($disk.PartitionStyle)"
            Write-Host
        }
        Write-Host "----------------------------------------------------------------------------------------"
        Write-Host "`t`t`tDisk to sanitize: $($global:disk_Id_To_Sanitize) (Disk Number/ID)" -ForegroundColor Cyan
        Write-Host "`t`t`tNumber of passes: $($global:number_Of_Passes)"    -ForegroundColor Cyan
        Write-Host
        Write-Host "Please review your selection above. Type 'confirm' to sanitize." -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "WARNING. After confirm, all data on disk will be lost. `nPress Ctrl+C if you wish to abort." -BackgroundColor Black -ForegroundColor Red
        $confirm_To_Sanitize = Read-Host
    } while ($confirm_To_Sanitize -ne 'confirm')
}

Function zero-With-Diskpart() {
    Remove-Item -Path "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Force -ErrorAction SilentlyContinue
    "sel disk $global:disk_Id_To_Sanitize" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    "clean all" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    "exit" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    diskpart /s "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)"
}

Function final-Disk-Setup() {
    Remove-Item -Path "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Force -ErrorAction SilentlyContinue
    "sel disk $global:disk_Id_To_Sanitize" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    "create partition primary" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    "format fs=ntfs quick" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    "assign letter j" | Out-File "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)" -Append -Encoding ascii
    diskpart /s "$($SYSTEM_DRIVE)\$($global:DISKPART_SCRIPT)"
}

# Script execution flow
gather-Input-From-User

for ($i = 1; $i -le $global:number_Of_Passes; $i++) {
    zero-With-Diskpart
}

final-Disk-Setup
