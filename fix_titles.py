import os

search_dir = r"e:\InclamUpdate\InclamWebsite"
target = "Inclam â€“ Indian Classical Music Platform"
replacement = "Inclam – Indian Classical Music Platform"

for root, dirs, files in os.walk(search_dir):
    for filename in files:
        if filename.endswith(".html"):
            file_path = os.path.join(root, filename)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
                
                if target in content:
                    new_content = content.replace(target, replacement)
                    with open(file_path, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    print(f"Fixed title in: {filename}")
            except Exception as e:
                print(f"Error reading {filename}: {e}")
