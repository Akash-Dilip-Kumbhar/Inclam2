import os
import re

# Files already processed manually
PROCESSED_FILES = [
    "Artist_AnkitaTambe.html",
    "Artist_AnuradhaKuber.html",
    "Artist_ArtiKundalkar.html",
    "Artist_BhagyeshMarathe.html",
    "Artist_ChinmayeeAthale.html",
    "Artist_JayantKaijkar.html",
    "Artist_KomalSane.html",
    "Artist_MaheshKale.html"
]

WEB_ROOT = "https://inclam.com/"

def fix_mojibake(content):
    # Common mojibake found in the project
    replacements = {
        'â—': '●',
        'â–¼': '▼',
        'â€“': '–',
        'â†’': '→',
        'â–²': '▲',
        'Â©': '©',
        'Ã©': 'é',
        'Ã ': 'à',
        'â‚¬': '€',
    }
    for old, new in replacements.items():
        content = content.replace(old, new)
    return content

def update_file(filepath):
    filename = os.path.basename(filepath)
    if filename in PROCESSED_FILES:
        print(f"Skipping {filename} (already processed)")
        return

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Check if already has OG tags
    if 'og:type' in content:
        print(f"Skipping {filename} (already has OG tags)")
        return

    # Extract Artist Name
    artist_match = re.search(r'<h1>\s*(.*?)\s*</h1>', content, re.IGNORECASE | re.DOTALL)
    artist_name = artist_match.group(1).strip() if artist_match else "Indian Classical Artist"
    
    # Remove any tags from artist name
    artist_name = re.sub(r'<[^>]+>', '', artist_name)

    # Extract Profile Image
    img_match = re.search(r'<div class="article__artist">\s*<img src="(.*?)"', content, re.IGNORECASE | re.DOTALL)
    profile_img = img_match.group(1).strip() if img_match else "img/logo/Inclam.png"

    # Extract Raagas for keywords
    raagas = re.findall(r'<h3 class="live__title">\s*(.*?)\s*</h3>', content, re.IGNORECASE | re.DOTALL)
    raaga_list = [r.strip() for r in raagas]
    raaga_keywords = ", ".join(raaga_list) if raaga_list else ""

    # Generate Description
    description = f"{artist_name} - Indian Classical Vocalist. Explore soulful Raaga performances"
    if raaga_list:
        description += f" including {raaga_list[0]}"
    description += " on Inclam."

    # Construct Meta Tags
    meta_tags = f"""    <meta name="description" content="{description}">
    <meta name="keywords" content="{artist_name}, Indian Classical Music, Vocalist, Raaga, Inclam{', ' + raaga_keywords if raaga_keywords else ''}">
    <meta name="author" content="Probus Software">
    <title>{artist_name} - Indian Classical Vocalist | Inclam</title>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="{WEB_ROOT}{filename}">
    <meta property="og:title" content="{artist_name} - Indian Classical Vocalist | Inclam">
    <meta property="og:description" content="{description}">
    <meta property="og:image" content="{WEB_ROOT}{profile_img}">"""

    # Replace existing metadata
    # The existing metadata is usually between lines 7 and 10
    content = re.sub(r'<meta name="description" content=".*?">', '', content)
    content = re.sub(r'<meta name="keywords" content=".*?">', '', content)
    content = re.sub(r'<meta name="author" content=".*?">', '', content)
    content = re.sub(r'<title>.*?</title>', meta_tags, content, count=1)

    # Update Logo Alt Attributes
    content = content.replace('alt="Logo"', 'alt="Inclam Logo"')

    # Update Profile Image Alt
    content = re.sub(r'(<div class="article__artist">\s*<img src=".*?" alt=")(.*?)(")', fr'\1{artist_name} - Indian Classical Vocalist\3', content)

    # Update Raaga Alt Attributes
    # Find all Raaga images and update their alt tags
    # Usually: <div class="album__cover">\s*<img src="(.*?)"\s*alt="(.*?)"
    def raaga_alt_replacer(match):
        img_src = match.group(1)
        old_alt = match.group(2)
        # Try to find the title in the vicinity - this is hard with regex, let's just use artist name + raaga if possible
        # For simplicity, we'll just use descriptive generic alt if we can't find title
        return f'<img src="{img_src}" alt="{artist_name} Performance"'

    # Update Footer Copyright and fix mojibake
    content = fix_mojibake(content)
    content = content.replace('© INCLAM, 2022', '© Inclam 2024')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Updated {filename}")

def main():
    directory = "."
    for filename in os.listdir(directory):
        if filename.startswith("Artist_") and filename.endswith(".html"):
            update_file(os.path.join(directory, filename))

if __name__ == "__main__":
    main()
