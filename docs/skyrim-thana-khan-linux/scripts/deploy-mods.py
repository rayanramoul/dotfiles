import os, sys, json, time

PACK = "/home/rayanramoul/MegaDrive/SkyrimModding/Skyrim Thana Khan Modspack v8.4"
DATA = "/home/rayanramoul/MegaDrive/SteamLibrary/steamapps/common/Skyrim Special Edition/Data"
PROFILE = "01 - Ecran standard"
APPLY = "--apply" in sys.argv

SKIP_FILES = {"meta.ini"}
SKIP_EXT = (".mohidden",)

def mod_order():
    """MO2 modlist.txt is highest-priority-first; deploy lowest first so higher wins."""
    p = os.path.join(PACK, "profiles", PROFILE, "modlist.txt")
    raw = open(p, "rb").read().decode("utf-8")
    mods = [l[1:] for l in raw.split("\r\n") if l.startswith("+")]
    mods = [m for m in mods if not m.endswith("_separator")]
    mods.reverse()
    return mods

# Case-insensitive index of what exists in Data: lower(relpath) -> real relpath
ci = {}
def build_index():
    for root, dirs, files in os.walk(DATA):
        rel = os.path.relpath(root, DATA)
        rel = "" if rel == "." else rel
        for d in dirs:
            r = os.path.join(rel, d) if rel else d
            ci[r.lower()] = r
        for f in files:
            r = os.path.join(rel, f) if rel else f
            ci[r.lower()] = r

def resolve(rel):
    """Map a mod-relative path onto existing Data casing, component by component."""
    parts = rel.split(os.sep)
    out = []
    for i, part in enumerate(parts):
        probe = os.sep.join(out + [part]).lower()
        hit = ci.get(probe)
        out.append(os.path.basename(hit) if hit else part)
    return os.sep.join(out)

def main():
    mods = mod_order()
    sources = [(m, os.path.join(PACK, "mods", m)) for m in mods]
    sources.append(("<overwrite>", os.path.join(PACK, "overwrite")))  # highest priority

    build_index()
    original = set(ci)          # everything that was in Data before we started
    deployed, overwrote_mod, overwrote_orig, skipped = 0, 0, 0, 0
    manifest = []
    t0 = time.time()

    for name, src in sources:
        if not os.path.isdir(src):
            continue
        for root, dirs, files in os.walk(src):
            rel_dir = os.path.relpath(root, src)
            rel_dir = "" if rel_dir == "." else rel_dir
            for f in files:
                if f in SKIP_FILES or f.endswith(SKIP_EXT):
                    skipped += 1; continue
                rel = os.path.join(rel_dir, f) if rel_dir else f
                target_rel = resolve(rel)
                target = os.path.join(DATA, target_rel)
                exists = target_rel.lower() in ci
                if exists:
                    if target_rel.lower() in original: overwrote_orig += 1
                    else: overwrote_mod += 1
                if APPLY:
                    os.makedirs(os.path.dirname(target), exist_ok=True)
                    if os.path.lexists(target):
                        os.unlink(target)
                    os.link(os.path.join(root, f), target)
                    # register new dirs/file into the case index
                    acc = []
                    for part in target_rel.split(os.sep):
                        acc.append(part); ci[os.sep.join(acc).lower()] = os.sep.join(acc)
                    manifest.append(target_rel)
                else:
                    acc = []
                    for part in target_rel.split(os.sep):
                        acc.append(part); ci.setdefault(os.sep.join(acc).lower(), os.sep.join(acc))
                deployed += 1
        if APPLY and deployed and deployed % 50000 < 1000:
            print(f"   ... {deployed:,} files ({time.time()-t0:.0f}s)", flush=True)

    print(f"mods deployed        : {len(sources)}")
    print(f"files to link        : {deployed:,}")
    print(f"  overwriting a mod  : {overwrote_mod:,}   (normal - MO2 conflict wins)")
    print(f"  overwriting vanilla: {overwrote_orig:,}")
    print(f"MO2 metadata skipped : {skipped:,}")
    print(f"elapsed              : {time.time()-t0:.0f}s")
    if APPLY:
        with open(os.path.join(PACK, "_deploy_manifest.json"), "w") as fh:
            json.dump(manifest, fh)
        print(f"manifest written     : {len(manifest):,} entries")
    else:
        print("\n(dry run - nothing changed)")

main()
