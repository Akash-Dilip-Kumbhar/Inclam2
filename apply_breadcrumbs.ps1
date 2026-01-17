$files = Get-ChildItem "Artist_*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content -match "<!-- Breadcrumb -->") {
        Write-Host "Skipping $($file.Name), breadcrumb already present."
        continue
    }

    # Extract Artist Name
    # Artist_AnkitaTambe.html -> AnkitaTambe
    $basename = $file.BaseName
    $artistKey = $basename -replace "Artist_", ""
    # Insert space before capital letters
    $artistName = $artistKey -replace '(\w)([A-Z])', '$1 $2'

    Write-Host "Processing $($file.Name) -> Artist: $artistName"

    $breadcrumbHtml = @"
                    <!-- Breadcrumb -->
                    <ul style="display: flex; list-style: none; padding: 0; margin-bottom: 20px; font-size: 14px; color: #bbb;">
                        <li><a href="index.html" style="color: #bbb; text-decoration: none;">Home</a></li>
                        <li style="margin: 0 8px;">/</li>
                        <li><a href="artists.html" style="color: #bbb; text-decoration: none;">Artists</a></li>
                        <li style="margin: 0 8px;">/</li>
                        <li style="color: #25a56a;">$artistName</li>
                    </ul>
                    <!-- end breadcrumb -->
                    <div class="article article--page">
"@

    $target = '<div class="article article--page">'
    
    if ($content -match [regex]::Escape($target)) {
        $newContent = $content.Replace($target, $breadcrumbHtml)
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        Write-Host "Updated $($file.Name)"
    } else {
        Write-Host "Warning: Could not find insertion point in $($file.Name)"
    }
}
