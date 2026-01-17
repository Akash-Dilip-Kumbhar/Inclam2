$files = Get-ChildItem "Artist_*.html"

foreach ($file in $files) {
    if ($file.Name -eq "Artist_RaghunandanPanshikar.html") { continue }

    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Extract Correct Artist Name
    $basename = $file.BaseName
    $artistKey = $basename -replace "Artist_", ""
    # Use -creplace for case-sensitive replacement: lowercase followed by uppercase
    $artistName = $artistKey -creplace '([a-z])([A-Z])', '$1 $2' # e.g. AnkitaTambe -> Ankita Tambe
    
    # Also handle simpler case where no split needed or multiple splits?
    # RPKaramblekar -> RP Karamblekar?
    # RPKaramblekar -> R P Karamblekar?
    # Let's stick to the CamelCase split: [a-z][A-Z] is the standard boundary.
    # What about "RPKaramblekar"? "P" is Upper, "K" is Upper. No split there with [a-z][A-Z].
    # But "r" (last char of Karamblekar) is [a-z].
    # Wait, RPKaramblekar. R(Upper)P(Upper)K(Upper)aramblekar.
    # We want "R P Karamblekar" or "R.P. Karamblekar"?
    # The filename is `Artist_RPKaramblekar.html`.
    # Let's assume standard CamelCase Names mostly.
    # If the previous script destroyed it to `R PK ar am bl ek ar`, we need to locate that bad string.

    # We know the bad string is inside <li style="color: #25a56a;"> ... </li>
    
    # Regex to find the bad breadcrumb item
    # It likely looks like: <li style="color: #25a56a;">[A-Za-z ]+</li>
    
    $pattern = '<li style="color: #25a56a;">(.*?)</li>'
    if ($content -match $pattern) {
        $currentNameInFile = $matches[1]
        
        if ($currentNameInFile -ne $artistName) {
            Write-Host "Fixing $($file.Name): '$currentNameInFile' -> '$artistName'"
            $newContent = $content.Replace($matches[0], '<li style="color: #25a56a;">' + $artistName + '</li>')
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        } else {
            Write-Host "$($file.Name) is already correct: $artistName"
        }
    } else {
        Write-Host "Could not find breadcrumb artist item in $($file.Name)"
    }
}
