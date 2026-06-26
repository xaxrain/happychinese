
function Copy-WithIncrement {
    param (
        [string]$FilePath
    )

    $directory = Split-Path $FilePath
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
    $extension = [System.IO.Path]::GetExtension($FilePath)

    $i = 2
    do {
        $newName = "$fileName$i$extension"
        $newPath = Join-Path $directory $newName
        $i++
    } while (Test-Path $newPath)

    Copy-Item $FilePath $newPath

    Write-Host "✅ Created: $newName"
}

# Example usage:
Copy-WithIncrement "HC2-1review2_drop.html"
