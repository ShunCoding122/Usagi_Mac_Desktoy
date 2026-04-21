# UsagiPetMac

UsagiPetMac is a production-leaning macOS desktop pet (桌宠) built with AppKit + SpriteKit.

## Highlights
- Transparent borderless floating pet window.
- Global mouse and keyboard reaction with graceful permission fallback.
- Cursor-follow head/eyes with restrained motion.
- Activity-driven state machine: idle, typingSoft, typingFast, mouseFollow, clickReact, sleepy with blink/emotion overlays.
- Drag repositioning with persistent location.
- Menu bar controls and settings panel (SwiftUI).
- Launch at login via ServiceManagement.
- Placeholder layered asset pipeline with debug shape fallback.
- Designed with renderer protocols for future Live2D replacement.

## Architecture
- `App/`: lifecycle wiring and dependency graph.
- `Input/`: global/local event capture and permission handling.
- `State/`: activity estimation and deterministic runtime state output.
- `Rendering/`: animation blending and SpriteKit layered renderer.
- `Window/`: non-activating transparent panel + drag logic.
- `MenuBar/`: status item controls.
- `Settings/`: persisted settings and SwiftUI UI.
- `Models/`: constants/asset manifest.
- `Utilities/`: math/screen helpers.

## Permissions
Global keyboard monitoring typically requires **Accessibility** permission:
1. Open **System Settings → Privacy & Security → Accessibility**.
2. Add your built app and enable it.
3. Relaunch app if required.

If not granted, UsagiPetMac automatically falls back to local key monitoring while keeping full mouse behavior.

## Run
1. Open project in Xcode (macOS app target, Swift 5.9+).
2. Ensure bundle identifier and signing team are configured.
3. Build & run.
4. Use menu bar rabbit icon for controls.

## Packaging
- Use "Archive" in Xcode.
- Notarize/sign as normal macOS app if distributing.
- Accessibility prompts work best with signed app in `/Applications`.

## Replacing Placeholder Assets (Implementation Note)
Drop final PNGs into asset catalog (recommended) with the exact logical names:
- body_base, head_base, eyes_open, eyes_closed
- mouth_neutral, mouth_happy, blush
- left_ear, right_ear
- arm_left_idle, arm_left_typing
- arm_right_idle, arm_right_typing
- desk, accessory_optional

The layered node already binds these names. If an image is missing, debug shapes automatically render.

## Live2D Future TODO
1. Add `Live2DPetRenderer` conforming to `PetAnimationDriving`, `PetExpressionDriving`, and `PetRenderable`.
2. Map `PetRuntimeState` parameters to Live2D parameter IDs.
3. Add renderer factory in app bootstrap with runtime switch (Layered PNG vs Live2D).
4. Move current SpriteKit-only transform curves into backend-agnostic animation graph.
5. Implement asset hot-reload/dev tooling for model iteration.
6. Add lip-sync/audio-driven expression extension points.

## Notes
- Target: macOS 13+ (tested design target 14+).
- App uses `.accessory` activation policy for menu-bar-oriented behavior.
