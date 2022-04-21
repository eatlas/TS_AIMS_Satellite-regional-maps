# The GIT repository for these maps does not include the source data as they
# are too large. This script downloads these source data files. Run this
# before opening the maps in QGIS.

# To run this script in Windows: Right-click on the script file and select
# 'Run with PowerShell'. If you are on Linux or Mac you may need to install
# Powershell first. You can also download the source data directly from the 
# URLs in this script using a web browser.

function download {
    param ([string]$url, [string]$dest)
    if (Test-Path($dest)) {
        Write-Host 'Skipping file '$dest', already downloaded' -ForegroundColor Yellow
    } else {
        Write-Host 'Downloading '$dest
        $tempdest = $dest + '.tmp'                  # Download to temporary file. If download is 
                                                    # interrupted we wont accidentally use partial file.
        $ProgressPreference = 'SilentlyContinue'    # Without this the download is very slow
                                                    # because it reports every downloaded byte.
                                                    # Downside is that no progress is provided.
        Invoke-WebRequest -Uri $url -OutFile $tempdest
        Move-Item $tempdest $dest                 # Download complete so set to final name
    }
    # If it is a zip file then unpack it in a directory
    if ([IO.Path]::GetExtension($dest) -eq '.zip') {
        Write-Host 'Unpacking '$dest' zip file'
        $zipfolder = (Get-Item $dest ).DirectoryName + '\' +(Get-Item $dest ).Basename
        Expand-Archive -LiteralPath $dest -DestinationPath $zipfolder
    }
}

# Dataset: Torres Strait clear sky, clear water Landsat 5 satellite composite (NERP TE 13.1 eAtlas, AIMS, source: NASA)
# Metadata: https://eatlas.org.au/data/uuid/71c8380e-4cdc-4544-98b6-8a5c328930ad

# Direct download source URL
$url1 = "https://nextcloud.eatlas.org.au/s/bNgyMjpxtY96jrN/download/TS_eAtlas_Clear-sky-Landsat.tif"
# Destation file
$dest1 = "data/TS_eAtlas_Clear-sky-Landsat.tif"
download $url1 $dest1


# Dataset: Complete Great Barrier Reef (GBR) Island and Reef Feature boundaries including Torres Strait Version 1b (NESP TWQ 3.13, AIMS, TSRA, GBRMPA)
# Metadata: https://eatlas.org.au/data/uuid/d2396b2c-68d4-4f4b-aab0-52f7bc4a81f5

# Direct download source URL
$url2 = "https://nextcloud.eatlas.org.au/s/xQ8neGxxCbgWGSd/download/TS_AIMS_NESP_Torres_Strait_Features_V1b_with_GBR_Features.zip"
# Destation file
$dest2 = "data/TS_AIMS_TS_Features.zip"
download $url2 $dest2

read-host 'Finished. Press ENTER to close...'
