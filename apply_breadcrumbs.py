import glob
import os
import re

def insert_space(text):
    # Insert space before capital letters, except the first one
    return re.sub(r"(\w)([A-Z])", r"\1 \2", text)

def apply_breadcrumb():
    files = glob.glob("Artist_*.html")
    
    for file_path in files:
        # Skip if already done (though the check inside handles it too)
        # if file_path == "Artist_RaghunandanPanshikar.html":
        #     continue

        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        if "<!-- Breadcrumb -->" in content:
            print(f"Skipping {file_path}, breadcrumb already present.")
            continue

        # Extract Artist Name from filename
        # Artist_AnkitaTambe.html -> AnkitaTambe
        basename = os.path.splitext(file_path)[0]
        artist_key = basename.replace("Artist_", "")
        artist_name = insert_space(artist_key)

        print(f"Processing {file_path} -> Artist: {artist_name}")

        breadcrumb_html = f"""
                    <!-- Breadcrumb -->
                    <ul style="display: flex; list-style: none; padding: 0; margin-bottom: 20px; font-size: 14px; color: #bbb;">
                        <li><a href="index.html" style="color: #bbb; text-decoration: none;">Home</a></li>
                        <li style="margin: 0 8px;">/</li>
                        <li><a href="artists.html" style="color: #bbb; text-decoration: none;">Artists</a></li>
                        <li style="margin: 0 8px;">/</li>
                        <li style="color: #25a56a;">{artist_name}</li>
                    </ul>
                    <!-- end breadcrumb -->
"""
        
        # Target string to replace
        target = '<div class="article article--page">'
        
        # We need to ensure we are replacing the one inside <div class="col-12">
        # But usually there is only one article--page per artist page.
        
        if target in content:
            new_content = content.replace(target, breadcrumb_html + "                    " + target, 1)
            
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print(f"Updated {file_path}")
        else:
            print(f"Warning: Could not find insertion point in {file_path}")

if __name__ == "__main__":
    # Change to directory
    os.chdir(r"e:\InclamUpdate\InclamWebsite")
    apply_breadcrumb()
