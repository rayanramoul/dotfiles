import os, struct, collections

PACK = "/home/rayanramoul/MegaDrive/SkyrimModding/Skyrim Thana Khan Modspack v8.4"
GAME = "/home/rayanramoul/MegaDrive/SteamLibrary/steamapps/common/Skyrim Special Edition/Data"
PROF = os.path.join(PACK, "profiles", "01 - Écran standard")

enabled = []
for line in open(os.path.join(PROF, "plugins.txt"), encoding="utf-8-sig"):
    line = line.strip()
    if line.startswith("*"):
        enabled.append(line[1:])

# MO2 priority: modlist.txt is highest-priority-first
prio = []
for line in open(os.path.join(PROF, "modlist.txt"), encoding="utf-8-sig"):
    line = line.rstrip("\n")
    if line.startswith("+"):
        prio.append(line[1:])
prio.reverse()  # lowest -> highest, so later wins

index = {}
for m in prio:
    d = os.path.join(PACK, "mods", m)
    try:
        for f in os.listdir(d):
            if f.lower().endswith((".esp", ".esm", ".esl")):
                index[f.lower()] = os.path.join(d, f)
    except OSError:
        pass
# vanilla / game Data has lowest priority
for f in os.listdir(GAME):
    if f.lower().endswith((".esp", ".esm", ".esl")):
        index.setdefault(f.lower(), os.path.join(GAME, f))

full, light, missing = [], [], []
for name in enabled:
    p = index.get(name.lower())
    if not p:
        missing.append(name); continue
    try:
        with open(p, "rb") as fh:
            hdr = fh.read(12)
        flags = struct.unpack("<I", hdr[8:12])[0]
    except Exception:
        missing.append(name); continue
    (light if (flags & 0x200) else full).append(name)

print(f"enabled plugins : {len(enabled)}")
print(f"  ESL-flagged (light, FE space, cap 4096): {len(light)}")
print(f"  FULL slots     (cap 255)              : {len(full)}")
print(f"  not found on disk                     : {len(missing)}")
print()
if len(full) > 254:
    print(f"*** OVER THE LIMIT by {len(full)-254} — plugins past #254 are silently dropped ***")
    print("first dropped:", full[254:258])
else:
    print(f"full-slot usage OK ({len(full)}/254)")
print()
for n in ("Dismembering Framework.esm",):
    where = "light" if n in light else "full" if n in full else "MISSING"
    print(f"{n}: {where}")
    if n in full:
        print("   full-slot index:", full.index(n))
if missing:
    print("\nfirst 15 not found on disk:")
    for m in missing[:15]:
        print("  ", m)
