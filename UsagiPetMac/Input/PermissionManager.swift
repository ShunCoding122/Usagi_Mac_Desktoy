import ApplicationServices
import AppKit

final class PermissionManager {
    var hasAccessibilityAccess: Bool {
        AXIsProcessTrusted()
    }

    func ensureAccessibilityPermissionIfNeeded(prompt: Bool) {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: prompt] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    func openAccessibilityPreferences() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else { return }
        NSWorkspace.shared.open(url)
    }
}
