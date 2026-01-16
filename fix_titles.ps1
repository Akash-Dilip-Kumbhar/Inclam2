$searchDir = "e:\InclamUpdate\InclamWebsite"

# The target string to replace (mangled character)
$target = "Inclam â€“ Indian Classical Music Platform"
# The replacement string (correct en-dash)
$replacement = "Inclam – Indian Classical Music Platform"

Get-ChildItem -Path $searchDir -Filter *.html -Recurse | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw -Encoding UTF8
    
    if ($content -match [regex]::Escape($target)) {
        $newContent = $content -replace [regex]::Escape($target), $replacement
        Set-Content -Path $_.FullName -Value $newContent -Encoding UTF8
        Write-Host "Fixed title in: $($_.Name)"
    }
}
