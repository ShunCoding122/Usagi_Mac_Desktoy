# Placeholder Art Replacement Note

1. Keep the existing layer naming contract in `PetAssetManifest.layerNames`.
2. Import final PNGs into `Assets.xcassets` with those exact names (without `.png`).
3. Match pivot assumptions used in `LayeredPetNode.setupNodes()`; adjust only local node positions if needed.
4. Keep transparent padding consistent across related layers to minimize transform drift.
5. If you need style variants, add suffix groups (e.g. `eyes_open_alt1`) and expose selected manifest at runtime.
