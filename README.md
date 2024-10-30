# mod-converter
Script to convert tracker music modules to various audio formats.

There is both a Powershell and Shell script version so all platforms should be supported.

## Usage
```sh
./modconvert.[ps1|sh] --sourceDir "path/to/my/modules" --destinationDir "where/i/want/my/wavs/to/go" --outputFormat wav
```
Be sure to change the extension to either `ps1` or `sh` depending on your Operating System.

### Supported Output Formats
* `wav`
* `flac`
* `aiff`
* `raw`
* `au`

## Requirements
* [openmpt123](https://lib.openmpt.org/libopenmpt/download)
