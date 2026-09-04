# Values that matter, extracted from the working setup (2026-08-19).
# NOT drop-in files - the real ones live in the prefix/Data and are rewritten by the game.

## SkyrimPrefs.ini  (prefix: Documents/My Games/Skyrim Special Edition/)
  bFull Screen=0
  bBorderless=1
  bUse64bitsHDRRenderTarget=1
  fGamma=1.4000
  fShadowDistance=8145.0000
  iShadowMapResolution=2048

## enbseries.ini [COLORCORRECTION]  (game root; consumed by Effects 11, not ENB)
  UsePaletteTexture=false
  UseProceduralCorrection=true
  Brightness=1.0
  GammaCurve=1.0

## SSEDisplayTweaks.ini  (Data/SKSE/Plugins/)
  BorderlessUpscale = true
  ResolutionScale = 1.0
  Resolution = 3840x2160
  # 0.7 renders 2688x1512 upscaled - the fallback if 4K exceeds VRAM

## Community Shaders  (Data/SKSE/Plugins/CommunityShaders/SettingsUser.json)
  Screen Space GI: disabled  # CS's most expensive feature

## Native Microsoft DLLs  (stashed in ~/MegaDrive/SkyrimModding/_msvc-native/)
  concrt140.dll
  d3dcompiler_47.dll
  msvcp140.dll
  msvcp140_1.dll
  msvcp140_2.dll
  msvcp140_atomic_wait.dll
  msvcp140_codecvt_ids.dll
  vcruntime140.dll
  vcruntime140_1.dll
  vcruntime140_threads.dll
  x3daudio1_7.dll
  xactengine3_7.dll
  xapofx1_5.dll
  xaudio2_0.dll
  xaudio2_1.dll
  xaudio2_2.dll
  xaudio2_3.dll
  xaudio2_4.dll
  xaudio2_5.dll
  xaudio2_6.dll
  xaudio2_7.dll
  # all must ALSO be listed in WINEDLLOVERRIDES - Proton's overrides beat the registry

## Launcher environment  (~/.local/bin/thana-khan-play)
  PULSE_LATENCY_MSEC="${PULSE_LATENCY_MSEC:-60}"
  PROTON_ENABLE_NGX_UPDATER=1
  LANG=en_US.UTF-8

## SkyrimUpscaler.ini  - mod DISABLED, kept for reference only
  mDLSSGEnabled = false   # does NOT prevent the crash; the DXGI proxy installs on DLL load
