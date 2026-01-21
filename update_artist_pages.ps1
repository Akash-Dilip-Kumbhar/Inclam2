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

function Fix-Mojibake($content) {
    $replacements = @{
        'â—' = '●';
        'â–¼' = '▼';
        'â€“' = '–';
        'â†’' = '→';
        'â–²' = '▲';
        'Â©' = '©';
        'Ã©' = 'é';
        'Ã ' = 'à';
        'â‚¬' = '€'
    }
    foreach ($old in $replacements.Keys) {
        $content = $content.Replace($old, $replacements[$old])
    }
    return $content
}

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

    # Meta Tags
    $metaTags = @"
    <meta name="description" content="$description">
    <meta name="keywords" content="$artistName, Indian Classical Music, Vocalist, Raaga, Inclam$($if($raagaKeywords){", $raagaKeywords"})">
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
    
    # Update Profile Image Alt - handling case where alt might be anything
    $content = [regex]::Replace($content, '(<div class="article__artist">\s*<img src=".*?" alt=")(.*?)(")', { 
        param($m) 
        $m.Groups[1].Value + "$artistName - Indian Classical Vocalist" + $m.Groups[3].Value 
    })

    # Fix Mojibake and Copyright
    $content = Fix-Mojibake $content
    $content = $content -replace '© INCLAM, 2022', '© Inclam 2024'

    Set-Content $filepath $content -Encoding UTF8
    Write-Host "Updated $filename"
}

$files = Get-ChildItem "Artist_*.html"
foreach ($file in $files) {
    Update-File $file.FullName
}
