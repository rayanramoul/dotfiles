import os, sys, json, unicodedata

P = "/home/rayanramoul/MegaDrive/SkyrimModding/Skyrim Thana Khan Modspack v8.4"
MODS = os.path.join(P, "mods")
APPLY = "--apply" in sys.argv

# '°' is only ever decorative in separator names; '=' keeps them visually distinct
# and is legal on both Windows and Linux.
EXTRA = {"°": "=", "œ": "oe", "’": "'"}

def ascii_name(n):
    out = []
    for ch in n:
        if ord(ch) < 128:
            out.append(ch); continue
        if ch in EXTRA:
            out.append(EXTRA[ch]); continue
        d = unicodedata.normalize("NFKD", ch)
        s = "".join(c for c in d if not unicodedata.combining(c))
        out.append(s if s.isascii() and s else "_")
    return "".join(out)

names = os.listdir(MODS)
existing = set(names)
mapping, collisions = {}, []
for n in sorted(names):
    if all(ord(c) < 128 for c in n):
        continue
    new = ascii_name(n)
    if not new.isascii():
        collisions.append((n, new, "still non-ascii")); continue
    if new in existing or new in mapping.values():
        collisions.append((n, new, "collides with existing")); continue
    mapping[n] = new

print(f"folders to rename : {len(mapping)}")
print(f"collisions        : {len(collisions)}")
for a, b, why in collisions:
    print(f"   !! {a!r} -> {b!r} ({why})")
print("\nsample renames:")
for a, b in list(mapping.items())[:6]:
    print(f"   {a}\n     -> {b}")

if not APPLY:
    print("\n(dry run — nothing changed)")
    sys.exit(0)
if collisions:
    print("\nABORT: collisions present"); sys.exit(1)

with open(os.path.join(P, "_ascii_rename_map.json"), "w", encoding="utf-8") as fh:
    json.dump(mapping, fh, ensure_ascii=False, indent=1)

for old, new in mapping.items():
    os.rename(os.path.join(MODS, old), os.path.join(MODS, new))
print(f"\nrenamed {len(mapping)} folders")

profdir = os.path.join(P, "profiles")
for prof in os.listdir(profdir):
    f = os.path.join(profdir, prof, "modlist.txt")
    if not os.path.isfile(f):
        continue
    raw = open(f, "rb").read().decode("utf-8")
    lines = raw.split("\r\n")
    changed = 0
    for i, l in enumerate(lines):
        if l[:1] in "+-" and l[1:] in mapping:
            lines[i] = l[0] + mapping[l[1:]]; changed += 1
    open(f, "wb").write("\r\n".join(lines).encode("utf-8"))
    print(f"  {prof}: rewrote {changed} entries")
