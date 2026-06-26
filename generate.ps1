# Ask user input
$NewName = Read-Host "Enter the new name (e.g. HC-1)"

# Get current script directory (VERY important fix)
$BasePath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Source folder inside current directory
$SourceFolder = Join-Path $BasePath "template"

# Get all template files
Get-ChildItem -Path $SourceFolder -Filter "*.html" | ForEach-Object {

    # Full path of source file
    $sourceFile = $_.FullName

    # New filename
    $NewFileName = ($_.Name -replace "(?i)template", $NewName)

    # Output path (same folder as script)
    $destinationFile = Join-Path $BasePath $NewFileName

    # Copy file
    Copy-Item $sourceFile $destinationFile -Force

    # Read content
    $content = Get-Content $destinationFile -Raw

    # Replace content
    $content = $content -replace "(?i)%Template%", $NewName
    $content = $content -replace "(?i)template", $NewName

    # Fix title (use real HTML tags, not &lt;)
    $content = $content -replace "<title>.*?</title>", "<title>$NewName</title>"

    # Save file
    Set-Content $destinationFile $content
}

Write-Host "✅ Files generated for $NewName in $BasePath"