#---------------------------------------------------
# AWS Route53 DNS Record Backup
# 
# Backup will create a directory structure and json 
# representation of hosted zones
#
# -------------------------------------------------- 

# Get current working directory
$currentDirectoryPath = Convert-Path .
$backupDirectoryPath = $currentDirectoryPath + "\" + $(get-date -f yyyyMMdd-hhmmss)
$backupDirectoryHostedZonesPath = $backupDirectoryPath + "\hostedzone"

# Create directory w/date time stamp
New-Item -ItemType Directory -Force -Path $backupDirectoryPath
New-Item -ItemType Directory -Force -Path $backupDirectoryHostedZonesPath

# Get All Route 53 Zones
$hostedZones = Get-R53HostedZones -Region us-east-1
# Dump All Route 53 Zones to JSON File w/Date Stamp
ConvertTo-Json -InputObject $hostedZones | Out-File $($backupDirectoryPath  + "\hostedZones.json")

Foreach ($i in $hostedZones)
{
    $hostedZoneRecordSet = (Get-R53ResourceRecordSet -Region us-east-1  -Id $i.Id).ResourceRecordSets

    # Not realistic but there at least 4 levels exist so go big or go home
    ConvertTo-Json -Depth 25 -InputObject $hostedZoneRecordSet | Out-File $($backupDirectoryPath + $i.Id + ".json")
}