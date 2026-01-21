
$directory = "e:\InclamUpdate\InclamWebsite"
$files = Get-ChildItem -Path $directory -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    if ($content -match 'href="css/main.css"') {
        Write-Host "Updating $($file.Name)"
        $content = $content -replace 'href="css/main.css"', 'href="css/main.min.css"'
        $content | Set-Content -Path $file.FullName -Encoding UTF8
    }
}
Write-Host "CSS references updated."
