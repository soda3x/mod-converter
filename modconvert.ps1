param (
    [string]$sourceDir,            # Source directory containing module files
    [string]$destinationDir,       # Destination directory for converted files
    [string]$outputFormat = "wav"  # Desired output format (e.g., "wav", "flac", "aiff")
)

# Function to display usage information
function Show-Usage {
    Write-Host "Usage: .\modconvert.ps1 -sourceDir <source directory> -destinationDir <destination directory> [-outputFormat <format>]"
    Write-Host "Example: .\modconvert.ps1 -sourceDir C:\modules -destinationDir C:\converted -outputFormat flac"
    Write-Host "Supported formats: wav, flac, aiff, raw, au"
    exit 1
}

# Display usage if help command or wrong arguments
if ($sourceDir -eq "" -or $destinationDir -eq "" -or $sourceDir -eq "-help" -or $sourceDir -eq "--help") {
    Show-Usage
}

# Ensure openmpt123 is available
if (!(Get-Command openmpt123 -ErrorAction SilentlyContinue)) {
    Write-Host "modconvert - Error: openmpt123 is not available. Please ensure it is installed and in your PATH."
    exit 1
}

if (!(Test-Path -Path $sourceDir)) {
    Write-Host "modconvert - Error: Source directory '$($sourceDir)' does not exist."
    exit 1
}

if (!(Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir | Out-Null
}

# Define all supported module file extensions
$modExtensions = @("*.mod", "*.it", "*.xm", "*.s3m", "*.mptm", "*.stm", "*.med", "*.669", "*.mtm", "*.far", "*.ult", "*.ptm", "*.ams", "*.amf", "*.dmf", "*.dbm", "*.okt", "*.psm", "*.mt2", "*.umx")

# Loop through each file in the source directory with specified extensions
foreach ($extension in $modExtensions) {
    $files = Get-ChildItem -Path $sourceDir -Filter $extension
    foreach ($file in $files) {
        # Define output filename with the desired format
        $outputFile = Join-Path -Path $destinationDir -ChildPath ($file.BaseName + ".$outputFormat")

        # Convert the file
        Write-Host "modconvert - Converting $($file.Name) to $outputFormat..."
        & openmpt123 --output "$outputFile" "$($file.FullName)"
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "modconvert - Error: Failed to convert $($file.Name)"
        }
    }
}

Write-Host "modconvert - Conversion complete!"