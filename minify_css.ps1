
$inputFile = "e:\InclamUpdate\InclamWebsite\css\main.css"
$outputFile = "e:\InclamUpdate\InclamWebsite\css\main.min.css"

if (Test-Path $inputFile) {
    Write-Host "Reading $inputFile..."
    $css = Get-Content -Path $inputFile -Raw

    # Remove comments
    $css = $css -replace '/\*[\s\S]*?\*/', ''
    
    # Remove extra whitespace
    $css = $css -replace '\s+', ' '
    
    # Remove space around delimiters
    $css = $css -replace ' ?([{};,:]) ?', '$1'
    
    # Remove final semicolon in block
    $css = $css -replace ';\}', '}'

    $css = $css.Trim()

    $css | Set-Content -Path $outputFile -Encoding UTF8
    Write-Host "Minified CSS saved to $outputFile"
} else {
    Write-Host "File $inputFile not found!"
}
