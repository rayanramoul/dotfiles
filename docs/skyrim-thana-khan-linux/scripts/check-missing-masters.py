import os, struct

PACK = "/home/rayanramoul/MegaDrive/SkyrimModding/Skyrim Thana Khan Modspack v8.4"
GAME = "/home/rayanramoul/MegaDrive/SteamLibrary/steamapps/common/Skyrim Special Edition/Data"
PROF = os.path.join(PACK, "profiles", "01 - Ecran standard")

enabled = [l.strip()[1:] for l in open(os.path.join(PROF,"plugins.txt"),encoding="utf-8-sig")
           if l.strip().startswith("*")]

prio = [l.rstrip("\n")[1:] for l in open(os.path.join(PROF,"modlist.txt"),encoding="utf-8-sig")
        if l.startswith("+")]
prio.reverse()

index = {}
for m in prio:
    d = os.path.join(PACK,"mods",m)
    try:
        for f in os.listdir(d):
            if f.lower().endswith((".esp",".esm",".esl")):
                index[f.lower()] = os.path.join(d,f)
    except OSError: pass
OV=os.path.join(PACK,"overwrite")
for f in os.listdir(OV):
    if f.lower().endswith((".esp",".esm",".esl")):
        index[f.lower()]=os.path.join(OV,f)
for f in os.listdir(GAME):
    if f.lower().endswith((".esp",".esm",".esl")):
        index.setdefault(f.lower(), os.path.join(GAME,f))

IMPLICIT = {"skyrim.esm","update.esm","dawnguard.esm","hearthfires.esm","dragonborn.esm",
            "_resourcepack.esl","ccbgssse001-fish.esm","ccbgssse025-advdsgs.esm",
            "ccbgssse037-curios.esl","ccqdrsse001-survivalmode.esl"}
present_enabled = {n.lower() for n in enabled if n.lower() in index}
present_enabled |= {k for k in index if k in IMPLICIT}

def masters(path):
    out=[]
    with open(path,"rb") as fh:
        hdr=fh.read(24)
        if hdr[:4]!=b"TES4": return out
        size=struct.unpack("<I",hdr[4:8])[0]
        data=fh.read(size)
    off=0
    while off+6<=len(data):
        typ=data[off:off+4]; sz=struct.unpack("<H",data[off+4:off+6])[0]; off+=6
        if typ==b"MAST":
            out.append(data[off:off+sz].split(b"\x00")[0].decode("cp1252","replace"))
        off+=sz
    return out

broken=[]
for name in enabled:
    p=index.get(name.lower())
    if not p: continue
    try: ms=masters(p)
    except Exception: continue
    miss=[m for m in ms if m.lower() not in present_enabled]
    if miss: broken.append((name,miss))

print(f"enabled plugins present on disk: {len(present_enabled)}")
print(f"plugins with MISSING masters   : {len(broken)}")
print()
if broken:
    print("*** THESE BREAK THE MAIN MENU ***")
    for n,ms in broken[:30]:
        print(f"  {n}")
        for m in ms: print(f"      needs -> {m}")
else:
    print("all masters resolve correctly")
