# Thana Khan Modspack v8.4 on Linux (CachyOS)

Running a 1,800-mod Skyrim SE modlist under Proton. The pack is Windows-only by design and assumes
ENB; this documents every Linux-specific thing that breaks and the configuration that actually works.

**Status: playable.** Native 4K, 1,802 mods, 1,928 plugins, Community Shaders + Effects 11 doing the
post-processing ENB was meant to. Established empirically on one machine — RTX 5070 Ti (16 GB),
Ryzen 7 5700X3D, 62 GB RAM, driver 610.57.04, CachyOS/Hyprland. Paths are that machine's; adjust them.

---

## TL;DR

```bash
thana-khan-play      # launch (Proton 10 is the default; override with THANA_PROTON=9|11|ge)
thana-khan-status    # after it exits: how far it got, and why it stopped
```

**Never launch Skyrim from Steam** — it updates the game to 1.6.1170 and breaks SKSE.
Steam must be *running* though, or `steam_api64.dll` fails to init.

---

## The working configuration

| Component | Value | Why this one |
|---|---|---|
| Skyrim SE | **1.5.97.0** (`md5 3f1b530e…`) | what the pack's SKSE targets |
| Proton | **10** (prefix `10.1000-105`) | see [Proton choice](#why-proton-10-specifically) |
| Mod delivery | **hardlinked into `Data`** | no MO2, no usvfs |
| Animations | **OAR 3.2.0** | 2.3.6 crashes |
| Post-processing | **Community Shaders 1.8.3 + Effects 11** | ENB cannot work here |
| ENB | **off** (`d3d11.dll.enb-disabled`) | conflicts with CS; also broken under DXVK |
| Microsoft DLLs | **MSVC runtime, `d3dcompiler_47`, XAudio2** | Wine's builtins break OAR, CS shaders and all voices/music |
| Crash logs | **Crash Logger SSE** | the pack ships none |

Disabled on purpose: **Local Map Upgrade**, **DLSS/FSR/FG**. See [Known-broken](#known-broken).

---

## Layout

| What | Where |
|---|---|
| Game (pack's 1.5.97 build) | `~/MegaDrive/SteamLibrary/steamapps/common/Skyrim Special Edition` |
| Pristine copy of it (undo source) | `~/MegaDrive/SkyrimModding/Skyrim Special Edition` |
| Mods, 449 GB, 1,880 folders | `~/MegaDrive/SkyrimModding/Skyrim Thana Khan Modspack v8.4` |
| Proton prefix | `<library>/steamapps/compatdata/489830/pfx` |
| Native DLL stash | `~/MegaDrive/SkyrimModding/_msvc-native/` |
| Launchers | `~/.local/bin/thana-khan-{play,status}` |

Game and mods **must** be on the same filesystem — the deploy hardlinks, and across filesystems it
would duplicate ~272 GB. Both are `/dev/sda1` here.

---

## Setup, in order

### 1. Pin the game to 1.5.97 and lock Steam out

The pack needs **1.5.97.0**; Steam ships 1.6.1170 and updated it mid-setup once, breaking everything.
With Steam **closed**, set `"AutoUpdateBehavior" "1"` in `appmanifest_489830.acf`.

```bash
strings "$GAME/SkyrimSE.exe" | grep -oE '1\.[56]\.[0-9]+\.[0-9]+' | sort -u   # 1.5.97.0
md5sum "$GAME/SkyrimSE.exe"   # 3f1b530e51986d490d6724a56775cd8a
```

The game folder is the pack's own build copied wholesale over Steam's (17,967 files).

### 2. Strip Windows graphics wrappers

Proton supplies its own DXVK; the pack ships Windows builds that must not load:

```bash
for f in d3d8.dll d3d9.dll d3d10.dll d3d10_1.dll d3d10core.dll dxvk_config.dll; do
  mv "$GAME/$f" "$GAME/$f.win-dxvk-unused"
done
```

**Keep** `d3dx9_42.dll`, `tbb.dll`, `tbbmalloc.dll` (SSE Engine Fixes part 2), `binkw64.dll`,
`steam_api64.dll`, `skse64_*`.

### 3. Replace `dxvk.conf`

The pack's is tuned for Windows DXVK 1.10 and sets `enablePipelineCache=false` +
`enableGraphicsPipelineLibrary=false` — on Linux that recompiles every shader every session. Ten
other keys belong to DXVK-async forks and are silently ignored. Use [`config/dxvk.conf`](config/dxvk.conf).

Note `dxgi.maxDeviceMemory` does **not** cap anything — it only changes what DXVK *reports*.

### 4. Remove every non-ASCII character from mod folder names

**The worst Linux-specific bug.** MO2 2.5.2 under Proton reads `modlist.txt` as Latin-1 and writes it
back through a 7-bit codec that masks the high bit:

```
vêtements  ->  vC*tements     (ê = C3 AA -> 43 2A)
Écran      ->  C<TAB>cran     (É = C3 89 -> 43 09)
```

It then **disables every mod whose mangled name no longer matches a folder** — 1800 → 1713 mods and
1928 → 1632 plugins — and the game crashes after the splash with ~87 mods missing mid-load-order.

Wine is *not* at fault (`cmd /c chcp 65001 & dir` lists `HERBE BASSE DENSITÉ été` perfectly). Ruled
out and ineffective: `LANG`/`LC_ALL` pinning, unsetting `LC_ALL`, GE-Proton11-3, `Nls\CodePage` ACP=1252.

```bash
python3 scripts/deaccent-mod-folders.py            # dry run + collision check
python3 scripts/deaccent-mod-folders.py --apply    # 131 folders, reversible via _ascii_rename_map.json
```

Rename the profiles too (`01 - Écran standard` → `01 - Ecran standard`) — MO2 also cannot round-trip
`selected_profile=@ByteArray(01 - \xc3\x89\x63ran standard)` in its own ini.

**Verify after any MO2 run:** `grep -c '^+' modlist.txt` = 1802, `grep -cP '[\x80-\xff]'` = 0,
`grep -c '^\*' plugins.txt` = 1928. Pristine backups live in each profile
(`modlist.txt.bak-preTKfix`, `plugins.txt.2025_12_01_03_56_08`).

### 5. Deploy mods into `Data`, not through MO2's VFS

```bash
python3 scripts/deploy-mods.py --apply   # ~350k hardlinks, ~17s
```

Links every enabled mod plus `overwrite/` into `Data` in MO2 priority order (lowest first), folding
each path onto Data's existing casing so `Meshes/` and `meshes/` don't both appear. Costs no extra disk.

> **Deployment is one-way.** Disabling a mod and re-running does **not** remove its files — nothing
> re-provides those paths, so the old hardlinks survive. This silently defeats quality changes:
> swapping DynDOLOD/grass tiers left **46,981** stale files behind. To back a mod out, walk its tree
> and unlink any `Data` entry whose **inode matches** the mod's copy, then redeploy.

> **Never edit deployed files with `sed -i`, `>`, or anything that replaces the file.** Those write a
> new file and rename over the old one, which **breaks the hardlink**: `Data` diverges from the mod
> source, and the next deploy silently reverts your change. This cost me a wrong `ResolutionScale`
> that I "verified" before redeploying — the game then ran at 2688×1512 while the docs said 4K.
> Edit the **mod source** with an in-place rewrite (`open(p,"wb")` after reading, which keeps the
> inode) and it propagates to `Data` through the link. Confirm with
> `stat -c%i <source> <data-copy>` — the inodes must match.

Then point the game at the load order (`thana-khan-play` does this automatically for a fresh prefix):

```bash
cp "$PROFILE"/{plugins,loadorder}.txt "$PFX/drive_c/users/steamuser/AppData/Local/Skyrim Special Edition/"
cp "$PROFILE"/Skyrim*.ini "$PFX/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition/"
```

### 6. Open Animation Replacer must be ≥ 3.x

The pack ships **2.3.6**, which crashes inside `Parsing data\meshes for replacer mods...`
(`kMessage_DataLoaded`, plugin handle 102) as the main menu builds. Silent exit, no crash log.
**3.2.0 parses the same tree in 1,077 ms.**

Ruled out and ineffective on 2.3.6: usvfs (crashes identically when hardlinked), `bAsyncParsing=false`,
`bLoadDefaultBehaviorsInMainMenu=false`, deleting all 79 OAR `user.json` overrides, MAX_PATH, and even
**removing the entire animation tree** — it still crashed with nothing to parse.

### 7. Install Microsoft's MSVC runtime, HLSL compiler and XAudio2

**Three** Wine reimplementations are inadequate here. This is the single most recurring theme of the
whole setup — if something is broken in a way that makes no sense, check whether a Wine builtin DLL
is standing in for a Microsoft one:

**`concrt140.dll`** — OAR 3.x parses in parallel via the Concurrency Runtime; Wine's builtin lacks
`??0_TaskCollection@details@Concurrency@@QEAA@XZ` and **hard-aborts**.

**`d3dcompiler_47.dll`** — Wine's is **vkd3d-shader**, whose HLSL parser rejects the `namespace`
keyword: `E5000: syntax error, unexpected KW_NAMESPACE`. That fails ~3,400 of Community Shaders'
shaders. It is also why Local Map Upgrade died with `E5032: unable to unroll loop`.

**`xaudio2_*` / `xactengine3_7` / `x3daudio1_7` / `xapofx1_5`** — Skyrim stores **voices as `.fuz`
and music as `.xwm`, both xWMA-encoded**, while sound effects are plain WAV. Wine's XAudio2 cannot
decode xWMA, so you get effects but **no dialogue and no music**. The giveaway is that the audio
device is fine — `pactl list short sinks` shows the sink `RUNNING` with active streams — so it is a
codec problem, not a device one. Fix:

```bash
winetricks -q xact xact_x64      # 11 Microsoft audio DLLs
```

`winetricks vcrun2022` through Proton's wine **only installs the 32-bit half** — the x64 DLLs stay
Wine's. Extract them by hand:

```bash
cabextract -q ~/.cache/winetricks/vcrun2022/vc_redist.x64.exe   # cab a12 holds the amd64 set
cabextract -q -d out64 a12
for f in out64/*_amd64; do cp "$f" "$SYS32/$(basename "${f%_amd64}")"; done
winetricks -q d3dcompiler_47      # downloads Microsoft's 4.3 MB build
```

**Verifying these is the trap.** Wine's stubs are a *similar size* and still contain the symbol names
they don't implement, so `grep 'wine builtin'` and symbol checks both give false negatives — I shipped
a broken guard twice on that. Sizes: Microsoft `concrt140` = 324,208 B, `d3dcompiler_47` = 4,346,120 B
(Wine's is ~363 KB). The reliable discriminator is a **Microsoft marker count**:

```bash
strings -n6 X.dll | grep -ci microsoft    # 0 = Wine's, 30+ = Microsoft's
```

All 21 DLLs are stashed in `~/MegaDrive/SkyrimModding/_msvc-native/`; `thana-khan-play`
**byte-compares against the stash** and restores any that a prefix rebuild reverted.

**The registry overrides winetricks writes are outranked by the `WINEDLLOVERRIDES` Proton sets**, so
the launcher must export them explicitly — installing the DLLs alone is not enough. This caught me
on all three.

### 8. Community Shaders + Effects 11 instead of ENB

Install [Community Shaders](https://www.nexusmods.com/skyrimspecialedition/mods/86492) (Light Limit Fix
is bundled) and [Effects 11](https://www.nexusmods.com/skyrimspecialedition/mods/179824), which runs ENB
presets inside CS with built-in replacements for ENB Helper and ENB Extender. ENB must be **off** —
they both claim `d3d11.dll`.

CS requires 1.5.97 or latest AE (**not** 1.6.640), an NVIDIA 900-series+/DX11.1 GPU, and Win10-era
prefix (ours reports build 19045). The ~12 features CS logs as *"failed to load, feature disabled"* —
`Effects11`, `LinearLighting`, `HDRDisplay`, `Skylighting`, `WetnessEffects` … — are **separate
downloads**, not bugs.

**Then fix the preset's encrypted shaders.** Four `.fx` files in `enbseries/` start with magic bytes
`KIEFX` — encrypted for `KiENBExtender.dll`, an ENB-only decryptor. Effects 11 can never read them
(`error X3000: Illegal character in shader file`). Plain HLSL versions of the same four sit in the
**game root**; copy them over:

```bash
for f in enbadaptation enbbloom enbeffect enbeffectpostpass; do
  cp "$GAME/$f.fx" "$GAME/enbseries/$f.fx"      # originals backed up first
done
```

Two follow-ups, because the stock shaders aren't the ones the preset was written for:

- `UsePaletteTexture=false` in `enbseries.ini` — `enbpalette.bmp` is a LUT the stock shader applies differently
- **Park `enbseries/{enbeffect,enbbloom,enbadaptation,enbeffectpostpass}.fx.ini`** — these hold zangdar's
  saved UI variables (`Color Pipeline`, `Color Balance`, `Saturation`) for his *custom* shaders. Effects 11
  binds them by name to the stock shaders, producing a heavy lavender cast. Leave the other five
  `.fx.ini` alone — their shaders weren't swapped.

You get correct ENB-style tonemapping driven by the preset's weather settings, but not zangdar's
bespoke look. That is the ceiling: those shaders are encrypted and only ENB can decrypt them.

### 9. Install a crash logger before you need it

[Crash Logger SSE](https://www.nexusmods.com/skyrimspecialedition/mods/59818) (1.5.97/SE, no .NET).
The pack ships none, which is why every crash here was invisible and cost hours of elimination. The
first log it produced named the faulting DLL, source file, line and null register immediately.

---

## Why Proton 10 specifically

ENB and CS both allocate heavily, and DXVK's memory manager decides whether it fits.

| Proton | DXVK | Result |
|---|---|---|
| 9 | ~2.3 | ENB compiles, but VRAM peaks **14,313 MiB** → spills to RAM → ~1 fps |
| 11 | 2.7.1 | VRAM fine (**7,474**), but ENB's pixel shaders never compile (`dataps.enbc` absent) |
| **10** | between | **reaches gameplay** — `DataLoaded` ×126, saves load and write |

Prefixes **do not downgrade**; moving from 11 to 10 needs a fresh prefix. Park the old one
(`mv compatdata/489830 compatdata/489830.proton11-backup`) — and **copy the saves across**, they live
in `pfx/.../Documents/My Games/Skyrim Special Edition/{Saves,__MO_Saves}`. I stranded 30 save files
that way.

---

## Performance and VRAM

**16 GB is the binding constraint at 4K.** With CS + Effects 11 fully working, native 4K sat at
**15,844 / 16,303 MiB (97%)** — playable but ~460 MB from the cliff, and tipping over means ~1 fps
(the GPU alternates 100% / 10% while the driver spills over PCIe). Distinguishing a *hang* from a
*framerate collapse* needs a GPU trace, not a screenshot; that measurement is what finally cracked it.

Current settings keep 4K and cut quality instead:

| Setting | Value | Note |
|---|---|---|
| Textures | `02 - Textures hautes` | `01 - Ultra` is a 1-file placeholder — the base textures *are* ultra |
| DynDOLOD | `Bas` | Ultra is 99 GB on disk |
| Grass | `BASSE` ×4 seasons | biggest single win alongside shadows |
| `iShadowMapResolution` | **2048** | quadratic — 4× less than 4096 |
| Screen Space GI | off | CS's most expensive feature |
| `ResolutionScale` | 1.0 | native 4K retained |

If it's still tight: `fShadowDistance` (8145 is generous), more CS features off, textures → `moyennes`.
`ResolutionScale = 0.7` (renders 2688×1512, upscales) is the blunt fallback — it's what DLSS was doing
invisibly before it had to be removed.

**Audio.** Silent dialogue/music is a **codec** problem — see step 7, `winetricks xact xact_x64`.
Crackling or stuttering is a different problem: 21 sound mods including UHDAP (uncompressed) stream
off a **PNY CS900**, a DRAM-less SATA SSD at ~45 MB/s under load. `PULSE_LATENCY_MSEC=60` in the
launcher enlarges the buffer; the real fix is moving `Data` (272 GB) to NVMe, which needs the 214 GB
rar cleared first. Diagnose which you have: if `pactl list short sinks` shows the sink `RUNNING` with
active streams, the device is fine and it is codec or buffering, never hardware.

**Disk starvation looks exactly like a hang.** With a big copy running, the game sits in `D` state on
`folio_wait_bit_common` reading 0 B/s. `ionice` does nothing — the disk uses **mq-deadline**, not BFQ.
Suspend the competing job with `kill -STOP`.

---

## Known-broken

| Mod | Why |
|---|---|
| **DLSS / FSR / Frame Gen** | `SkyrimUpscaler.dll` crashes in `DualDXGISwapChainProxy::GetBuffer` — DXVK hands it a null. `mDLSSGEnabled=false` does **not** help: the proxy installs when the DLL loads, regardless. Must be disabled entirely (and its 11 deployed files unlinked). |
| **Local Map Upgrade** | Pixel shader hit `E5032: unable to unroll loop` in vkd3d-shader. **Worth retrying** — that was before Microsoft's `d3dcompiler_47` was installed, which may now compile it. |

**Crash when reloading a save (vanilla bug, not Linux-specific).** Signature:

```
EXCEPTION_ACCESS_VIOLATION at SkyrimSE.exe+02A0562   call [rax+0x08]
RAX = 0x74655364616F4C62      <- ASCII "bLoadSet", i.e. a string where a vtable belongs
RCX = "bLoadSettingsonReload:Maintenance"
stack: BSAnimationGraphManager, BShkbAnimationGraph "DefaultFemale", skeleton_female.nif
```

A [documented multi-threaded race](https://www.nexusmods.com/skyrim/mods/85443): one core reads
animation-graph data another core has not finished loading. Intermittent by nature, and a 1,800-mod
list makes it much likelier (longer loads, more data in flight). **Every relevant fix is already
enabled** — SSE Engine Fixes (incl. `bAnimationLoadSignedCrash`, `bCellInit`, `bClimateLoad`) and
PapyrusTweaks. No SSE mod fixes the race itself.

Mitigations, in order of cost: save often; **quit to the main menu before loading** rather than
loading over a running session; avoid repeated reloads in one sitting. If it becomes intolerable,
restricting the game to fewer cores during load (`taskset`) targets the race directly at the price of
slower loads — untested here.

**ENB itself is not viable.** It loads, initialises, compiles shaders and renders the main menu, then
leaks VRAM to 13–14.5 GB regardless of *every* lever: texture tier, render resolution (−64 % pixels
bought 7 %), per-frame effects, per-object loaders, `ShaderCache`, `SpeedHack`, `ENBLITE`,
`LinuxVersion=true`, proxy off, and four Proton versions. Consumption is invariant to everything ENB
exposes, i.e. a leak in the ENB↔DXVK path. Don't spend an evening on effect toggles as I did — measure
VRAM first. The wrapper is kept as `d3d11.dll.enb-disabled` if a future build ever fixes it.

---

## Diagnostics

`thana-khan-status` reports how far the last run got. Key signal:

| plugins `DataLoaded` | meaning |
|---|---|
| ~125 | full load, in-game |
| ~65 | the old OAR crash is back |

```bash
SKSE="$PFX/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition/SKSE"
grep -oE "sending message type [0-9]+" "$SKSE/skse64.log" | sort | uniq -c   # 8=DataLoaded 3=PostLoadGame 4=SaveGame
grep "(handle N)" "$SKSE/skse64.log"    # map a handle to its dll
```

Crash logs: `$SKSE/Crashlogs/`. `THANA_DEBUG=1` adds a Proton log (slow).

Two audit scripts, each with a trap:

- `check-missing-masters.py` — **must index `overwrite/`** (MO2's highest-priority "mod", 44 plugins here
  including `igpcpontdragon.esp`) and treat Skyrim/Update/Dawnguard/HearthFires/Dragonborn as *implicit*
  (they're absent from `plugins.txt`). Miss either and you get hundreds of phantom findings — I chased
  one for an hour and nothing was actually missing.
- `check-plugin-limits.py` — 1,928 enabled = 1,686 ESL-flagged + 242 full slots (cap 254). Legal.

---

## Undo

```bash
rm -rf "$GAME/Data" && cp -a "$HOME/MegaDrive/SkyrimModding/Skyrim Special Edition/Data" "$GAME/Data"
```

Mod renames reverse via `_ascii_rename_map.json`. Wine's original DLLs, the encrypted `.fx` shaders,
the preset `.fx.ini` files and every ini I touched all have `.bak`/`-backup` siblings in place.

---

## Files here

```
scripts/thana-khan-play              # launcher: SKSE via sniper runtime + Proton, no MO2
scripts/thana-khan-status            # post-run triage
scripts/deploy-mods.py               # hardlink mods into Data in MO2 priority order
scripts/deaccent-mod-folders.py      # transliterate accented mod folders (the big one)
scripts/check-missing-masters.py     # TES4 MAST audit
scripts/check-plugin-limits.py       # ESL vs full-slot accounting
config/dxvk.conf                     # Linux-appropriate replacement
config/settings-reference.md         # the ini values that matter, extracted from the working setup
config/skyrim-thana-khan.desktop     # launcher entry
```

See [`config/settings-reference.md`](config/settings-reference.md) for the exact values in use.
