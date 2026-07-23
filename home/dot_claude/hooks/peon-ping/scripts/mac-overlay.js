#!/usr/bin/env osascript -l JavaScript
// mac-overlay.js — JXA Cocoa overlay notification for macOS
// Usage: osascript -l JavaScript mac-overlay.js <message> <color> <icon_path> <slot> <dismiss_seconds>
//
// Creates a borderless, always-on-top overlay on every screen.
// Dismisses automatically after <dismiss_seconds> seconds.
//
// TODO: click-to-focus — attempted but reliable multi-window targeting
// without Accessibility permission proved difficult. Options to revisit:
//   - Accessibility permission + AXRaise on specific window
//   - Cursor deep link / URL scheme if Cursor exposes one
//   - Track frontmost window ID via CGWindowListCopyWindowInfo at hook fire time

ObjC.import('Cocoa');

function run(argv) {
  var message  = argv[0] || 'peon-ping';
  var color    = argv[1] || 'red';
  var iconPath = argv[2] || '';
  var slot     = parseInt(argv[3], 10) || 0;
  var dismiss  = parseFloat(argv[4]) || 4;

  // Color map
  var r = 180/255, g = 0, b = 0;
  switch (color) {
    case 'blue':   r = 30/255;  g = 80/255;  b = 180/255; break;
    case 'yellow': r = 200/255; g = 160/255; b = 0;       break;
    case 'red':    r = 180/255; g = 0;       b = 0;       break;
  }

  var bgColor = $.NSColor.colorWithSRGBRedGreenBlueAlpha(r, g, b, 1.0);
  var winWidth = 500, winHeight = 80;

  $.NSApplication.sharedApplication;
  $.NSApp.setActivationPolicy($.NSApplicationActivationPolicyAccessory);

  var screens = $.NSScreen.screens;
  var screenCount = screens.count;
  var windows = [];

  for (var i = 0; i < screenCount; i++) {
    var screen = screens.objectAtIndex(i);
    var visibleFrame = screen.visibleFrame;

    var yOffset = 40 + slot * 90;
    var x = visibleFrame.origin.x + (visibleFrame.size.width - winWidth) / 2;
    var y = visibleFrame.origin.y + visibleFrame.size.height - winHeight - yOffset;
    var frame = $.NSMakeRect(x, y, winWidth, winHeight);

    var win = $.NSWindow.alloc.initWithContentRectStyleMaskBackingDefer(
      frame,
      $.NSWindowStyleMaskBorderless,
      $.NSBackingStoreBuffered,
      false
    );

    win.setBackgroundColor(bgColor);
    win.setAlphaValue(0.95);
    win.setLevel($.NSStatusWindowLevel);
    win.setIgnoresMouseEvents(true);

    win.setCollectionBehavior(
      $.NSWindowCollectionBehaviorCanJoinAllSpaces |
      $.NSWindowCollectionBehaviorStationary
    );

    win.contentView.wantsLayer = true;
    win.contentView.layer.cornerRadius = 12;
    win.contentView.layer.masksToBounds = true;

    var contentView = win.contentView;
    var textX = 10, textWidth = winWidth - 30;

    if (iconPath !== '' && $.NSFileManager.defaultManager.fileExistsAtPath(iconPath)) {
      var iconImage = $.NSImage.alloc.initWithContentsOfFile(iconPath);
      if (iconImage && !iconImage.isNil()) {
        var iconSize = 60;
        var iconView = $.NSImageView.alloc.initWithFrame(
          $.NSMakeRect(10, (winHeight - iconSize) / 2, iconSize, iconSize)
        );
        iconView.setImage(iconImage);
        iconView.setImageScaling($.NSImageScaleProportionallyUpOrDown);
        contentView.addSubview(iconView);
        textX = 10 + iconSize + 5;
        textWidth = winWidth - textX - 20;
      }
    }

    // Message label — vertically centered
    var font = $.NSFont.boldSystemFontOfSize(16);
    var textHeight = font.ascender - font.descender + font.leading + 4;
    var textY = (winHeight - textHeight) / 2;
    var label = $.NSTextField.alloc.initWithFrame(
      $.NSMakeRect(textX, textY, textWidth, textHeight)
    );
    label.setStringValue($(message));
    label.setBezeled(false);
    label.setDrawsBackground(false);
    label.setEditable(false);
    label.setSelectable(false);
    label.setTextColor($.NSColor.whiteColor);
    label.setAlignment($.NSTextAlignmentCenter);
    label.setFont(font);
    label.setLineBreakMode($.NSLineBreakByTruncatingTail);
    label.cell.setWraps(false);
    contentView.addSubview(label);

    win.orderFrontRegardless;
    windows.push(win);
  }

  // Auto-dismiss timer
  $.NSTimer.scheduledTimerWithTimeIntervalTargetSelectorUserInfoRepeats(
    dismiss,
    $.NSApp,
    'terminate:',
    null,
    false
  );

  $.NSApp.run;
}
