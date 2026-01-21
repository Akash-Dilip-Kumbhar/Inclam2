$processedFiles = @(
    "Artist_AnkitaTambe.html",
    "Artist_AnuradhaKuber.html",
    "Artist_ArtiKundalkar.html",
    "Artist_BhagyeshMarathe.html",
    "Artist_ChinmayeeAthale.html",
    "Artist_JayantKaijkar.html",
    "Artist_KomalSane.html",
    "Artist_MaheshKale.html"
)

$webRoot = "https://inclam.com/"

function Update-File($filepath) {
    $filename = [System.IO.Path]::GetFileName($filepath)
    if ($processedFiles -contains $filename) {
        Write-Host "Skipping $filename (already processed manually)"
        return
    }

    $content = Get-Content $filepath -Raw -Encoding UTF8
    
    if ($content -match 'og:type') {
        Write-Host "Skipping $filename (already has OG tags)"
        return
    }

    # Extract Artist Name
    $artistName = "Indian Classical Artist"
    if ($content -match '<h1>\s*(.*?)\s*</h1>') {
        $artistName = $Matches[1].Trim()
        $artistName = $artistName -replace '<[^>]+>', ''
    }

    # Extract Profile Image
    $profileImg = "img/logo/Inclam.png"
    if ($content -match '<div class="article__artist">\s*<img src="(.*?)"') {
        $profileImg = $Matches[1].Trim()
    }

    # Extract Raagas
    $raagas = [regex]::Matches($content, '<h3 class="live__title">\s*(.*?)\s*</h3>') | ForEach-Object { $_.Groups[1].Value.Trim() }
    $raagaKeywords = $raagas -join ", "
    
    # Generate Description
    $description = "$artistName - Indian Classical Vocalist. Explore soulful Raaga performances"
    if ($raagas.Count -gt 0) {
        $description += " including $($raagas[0])"
    }
    $description += " on Inclam."

    # Prepare Keywords
    $keywords = "$artistName, Indian Classical Music, Vocalist, Raaga, Inclam"
    if ($raagaKeywords) {
        $keywords += ", $raagaKeywords"
    }

    # Meta Tags
    $metaTags = @"
    <meta name="description" content="$description">
    <meta name="keywords" content="$keywords">
    <meta name="author" content="Probus Software">
    <title>$artistName - Indian Classical Vocalist | Inclam</title>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="$webRoot$filename">
    <meta property="og:title" content="$artistName - Indian Classical Vocalist | Inclam">
    <meta property="og:description" content="$description">
    <meta property="og:image" content="$webRoot$profileImg">
"@

    # Update Content
    $content = $content -replace '<meta name="description" content=".*?">', ''
    $content = $content -replace '<meta name="keywords" content=".*?">', ''
    $content = $content -replace '<meta name="author" content=".*?">', ''
    $content = $content -replace '<title>.*?</title>', $metaTags

    $content = $content -replace 'alt="Logo"', 'alt="Inclam Logo"'
    
    # Update Profile Image Alt
    $content = [regex]::Replace($content, '(<div class="article__artist">\s*<img src=".*?" alt=")(.*?)(")', { 
        param($m) 
        $m.Groups[1].Value + "$artistName - Indian Classical Vocalist" + $m.Groups[3].Value 
    })
    
    # Update Raaga Image Alts
    # Using regex to find the album cover 
    $content = [regex]::Replace($content, '(<div class="album__cover">\s*<img src="RAAGAS/Artist-thumb/.*? webp?"\s*alt=")(.*?)(")', { 
        param($m)
        $m.Groups[1].Value + "$artistName - RAAGA PERFORMANCE" + $m.Groups[3].Value
    })

    # Fix Mojibake - Using explicit char codes to avoid script encoding issues
    # â— (0xE2 0x97 0x8F) -> ●
    $badBlackCircle = [string][char]0xE2 + [string][char]0x97 + [string][char]0x8F
    $content = $content.Replace($badBlackCircle, "●")
    
    # â–¼ (0xE2 0x96 0xBC) -> ▼
    $badTriangle = [string][char]0xE2 + [string][char]0x96 + [string][char]0xBC
    $content = $content.Replace($badTriangle, "▼")

    # â€“ (0xE2 0x80 0x93) -> –
    $badDash = [string][char]0xE2 + [string][char]0x80 + [string][char]0x93
    $content = $content.Replace($badDash, "–")
    
    # â†’ (0xE2 0x86 0x92) -> →
    $badArrow = [string][char]0xE2 + [string][char]0x86 + [string][char]0x92
    $content = $content.Replace($badArrow, "→")

    # Copyright Fix
    $content = $content -replace '© INCLAM, 2022', '© Inclam 2024'
    # Check for mojibake copyright Â©
    $badCopyright = [string][char]0xC2 + [string][char]0xA9
    if ($content.Contains($badCopyright)) {
        $content = $content.Replace($badCopyright, "©")
    }

    Set-Content $filepath $content -Encoding UTF8
    Write-Host "Updated $filename"
}

$files = Get-ChildItem "Artist_*.html"
foreach ($file in $files) {
    Update-File $file.FullName
}
