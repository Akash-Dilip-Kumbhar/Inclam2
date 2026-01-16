$searchDir = "e:\InclamUpdate\InclamWebsite"

# The target string to replace (mangled character)
$target = "Inclam â€“ Indian Classical Music Platform"
# The replacement string (correct en-dash) - using ASCII hyphen if encoding is tricky, or just standard dash
$replacement = "Inclam - Indian Classical Music Platform" 

# Or if you strictly want the en-dash but PowerShell is fighting encoding:
# We can use the unicode escape or just ensuring the file is saved/read correctly. 
# For safety in this environment, I'll use a standard hyphen first as requested in the diff example, 
# OR I can try to use the specific char `–` again but being careful with the script encoding.
# The user request specifically asked for `–` (en-dash) in the second part (copied from user request).
# Let's try to set the replacement carefully.

$replacement = "Inclam – Indian Classical Music Platform"

Get-ChildItem -Path $searchDir -Filter *.html -Recurse | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw -Encoding UTF8
    
    if ($content.Contains($target)) {
        $newContent = $content.Replace($target, $replacement)
        Set-Content -Path $_.FullName -Value $newContent -Encoding UTF8
        Write-Host "Fixed title in: $($_.Name)"
    }
}
