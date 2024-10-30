#!/bin/bash

# Function to display usage information
show_usage() {
    echo "Usage: $0 <sourceDir> <destinationDir> [outputFormat]"
    echo "Example: $0 /path/to/source /path/to/destination wav"
    echo "Supported formats: wav, flac, aiff, raw, au"
    exit 1
}

# Display usage if help command or wrong arguments
if [[ "$1" == "-h" || "$1" == "--help" || "$#" -lt 2 ]]; then
    show_usage
fi

# Parameters
sourceDir="$1"           # Source directory containing module files
destinationDir="$2"      # Destination directory for converted files
outputFormat="${3:-wav}" # Desired output format (default is "wav")

# Ensure openmpt123 is available
if ! command -v openmpt123 &> /dev/null; then
    echo "modconvert - Error: openmpt123 is not available. Please ensure it is installed and in your PATH."
    exit 1
fi

# Check if source directory exists
if [ ! -d "$sourceDir" ]; then
    echo "modconvert - Error: Source directory '$sourceDir' does not exist."
    exit 1
fi

# Create destination directory if it does not exist
if [ ! -d "$destinationDir" ]; then
    mkdir -p "$destinationDir"
fi

# Define all supported module file extensions
modExtensions=("mod" "it" "xm" "s3m" "mptm" "stm" "med" "669" "mtm" "far" "ult" "ptm" "ams" "amf" "dmf" "dbm" "okt" "psm" "mt2" "umx")

# Loop through each file in the source directory with specified extensions
for extension in "${modExtensions[@]}"; do
    for file in "$sourceDir"/*.$extension; do
        # Check if file exists to prevent errors in case of no matches
        [ -e "$file" ] || continue

        # Define output filename with the desired format
        outputFile="$destinationDir/$(basename "${file%.*}").$outputFormat"

        # Convert the file
        echo "modconvert - Converting $(basename "$file") to $outputFormat..."
        openmpt123 --output "$outputFile" "$file"

        if [ $? -ne 0 ]; then
            echo "modconvert - Error: Failed to convert $(basename "$file")"
        fi
    done
done

echo "modconvert - Conversion complete!"