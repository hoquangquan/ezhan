import zipfile
import re
import os

apk_path = r"D:\ESATECH_TEST\New AGV\Update\Update\E300XDY-3.3.48.apk"
extract_dir = r"D:\ESATECH_TEST\New AGV\apk_extract"

if not os.path.exists(extract_dir):
    os.makedirs(extract_dir)

print(f"Extracting APK...")
try:
    with zipfile.ZipFile(apk_path, 'r') as zip_ref:
        zip_ref.extractall(extract_dir)
except Exception as e:
    print(f"Failed to extract APK: {e}")
    exit(1)

def extract_strings(file_path, min_length=4):
    with open(file_path, 'rb') as f:
        data = f.read()
    
    # Very basic string extraction for ASCII and UTF-8
    pattern = re.compile(b'[ -~]{' + str(min_length).encode() + b',}')
    matches = pattern.findall(data)
    return [m.decode('ascii', errors='ignore') for m in matches]

print("Searching for map/export related keywords in DEX files...")
keywords = ['export', 'xuất', 'map', 'path', 'sdcard', 'ezhan', 'backup', 'json']

found_strings = set()
for root, dirs, files in os.walk(extract_dir):
    for file in files:
        if file.endswith('.dex'):
            file_path = os.path.join(root, file)
            strings = extract_strings(file_path)
            for s in strings:
                s_lower = s.lower()
                if any(k in s_lower for k in keywords):
                    if len(s) < 100:  # Avoid huge strings
                        found_strings.add(s)

print("\n--- Potential File Paths or Keys Found ---")
path_related = [s for s in found_strings if '/' in s and ('sdcard' in s.lower() or 'ezhan' in s.lower() or 'map' in s.lower())]
for p in path_related[:30]:
    print(p)

print("\n--- Potential Export/Backup Features Found ---")
feature_related = [s for s in found_strings if 'export' in s.lower() or 'backup' in s.lower()]
for f in feature_related[:30]:
    print(f)
