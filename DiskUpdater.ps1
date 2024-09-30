########################################################
# Script to Initialize a new Storage on a Computer/VM  #
# Written by Carl Schaeffer                            #
#          Updated: 13.09.2024 by Carl Schaeffer       #
########################################################

# Get the list of disks
$Disks = Get-Disk

# List of available drive letters
$DriveLetters = 69..90 | ForEach-Object { [char]$_ } # Start from 'E' to 'Z'

# Initialize counters for drive letters and labels
$DriveLetterIndex = 0
$LabelIndex = 1

# Loop through each disk and print the disk number
foreach ($Disk in $Disks) {
    if ($Disk.PartitionStyle -eq 'RAW') {
        # Select the uninitialized disk
        $DiskNumber = $Disk.Number

        # Initialize the selected disk
        Initialize-Disk -Number $DiskNumber -PartitionStyle MBR

        # Sleeptimer against error
        Start-Sleep -Seconds 5

        # Get the first Driveletter of the List of $DriveLetters
        $DriveLetter = $DriveLetters[$DriveLetterIndex]

        # Create a new partition on the initialized disk using the maximum available size
        New-Partition -DiskNumber $DiskNumber -UseMaximumSize -DriveLetter $DriveLetter
        
        # Sleeptimer against error
        Start-Sleep -Seconds 5

        # Create the filesystem label
        $FileSystemLabel = "Daten" + "{0:D2}" -f $LabelIndex

        # Format the new partition with NTFS file system and assign the available drive letter with the label
        Format-Volume -DriveLetter $DriveLetter -FileSystem NTFS -NewFileSystemLabel $FileSystemLabel

        # Increment the drive letter and label indices
        $DriveLetterIndex++
        $LabelIndex++
    }
}
