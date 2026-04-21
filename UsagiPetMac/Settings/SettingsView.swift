import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: SettingsStore
    let permissionManager: PermissionManager

    var body: some View {
        Form {
            Section("Behavior") {
                Slider(value: $store.petScale, in: PetConfig.minScale...PetConfig.maxScale) {
                    Text("Pet Scale")
                }
                Toggle("Always On Top", isOn: $store.alwaysOnTop)
                Toggle("Click Through Mode", isOn: $store.clickThroughMode)
                Toggle("Launch at Login", isOn: $store.launchAtLogin)
            }

            Section("Reactions") {
                Slider(value: $store.followCursorIntensity, in: 0...1) { Text("Follow Cursor Intensity") }
                Slider(value: $store.typingReactionIntensity, in: 0...1) { Text("Typing Reaction Intensity") }
                Toggle("Enable Sound (placeholder)", isOn: $store.soundEnabled)
                Toggle("Show Debug Overlay", isOn: $store.debugOverlayEnabled)
            }

            Section("Permissions") {
                Text(permissionManager.hasAccessibilityAccess ? "Accessibility access granted." : "Accessibility access missing. Global keyboard monitoring will be limited.")
                Button("Open Accessibility Settings") {
                    permissionManager.openAccessibilityPreferences()
                }
            }

            Button("Apply") {
                store.saveAndBroadcast()
            }
        }
        .padding()
    }
}
