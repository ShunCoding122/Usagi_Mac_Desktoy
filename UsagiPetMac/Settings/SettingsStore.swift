import Foundation
import CoreGraphics
import ServiceManagement

enum SettingsChange {
    case all
}

final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    @Published var petScale: CGFloat
    @Published var alwaysOnTop: Bool
    @Published var launchAtLogin: Bool
    @Published var followCursorIntensity: CGFloat
    @Published var typingReactionIntensity: CGFloat
    @Published var soundEnabled: Bool
    @Published var clickThroughMode: Bool
    @Published var debugOverlayEnabled: Bool

    var rememberedPosition: CGPoint {
        get {
            CGPoint(x: defaults.double(forKey: Keys.posX), y: defaults.double(forKey: Keys.posY))
        }
        set {
            defaults.set(newValue.x, forKey: Keys.posX)
            defaults.set(newValue.y, forKey: Keys.posY)
        }
    }

    var onSettingsChanged: ((SettingsChange) -> Void)?

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let petScale = "petScale"
        static let alwaysOnTop = "alwaysOnTop"
        static let launchAtLogin = "launchAtLogin"
        static let followCursorIntensity = "followCursorIntensity"
        static let typingReactionIntensity = "typingReactionIntensity"
        static let soundEnabled = "soundEnabled"
        static let clickThroughMode = "clickThroughMode"
        static let debugOverlayEnabled = "debugOverlayEnabled"
        static let posX = "rememberedPosX"
        static let posY = "rememberedPosY"
    }

    private init() {
        petScale = defaults.object(forKey: Keys.petScale) as? CGFloat ?? PetConfig.defaultScale
        alwaysOnTop = defaults.object(forKey: Keys.alwaysOnTop) as? Bool ?? true
        launchAtLogin = defaults.object(forKey: Keys.launchAtLogin) as? Bool ?? false
        followCursorIntensity = defaults.object(forKey: Keys.followCursorIntensity) as? CGFloat ?? 0.8
        typingReactionIntensity = defaults.object(forKey: Keys.typingReactionIntensity) as? CGFloat ?? 1.0
        soundEnabled = defaults.object(forKey: Keys.soundEnabled) as? Bool ?? false
        clickThroughMode = defaults.object(forKey: Keys.clickThroughMode) as? Bool ?? false
        debugOverlayEnabled = defaults.object(forKey: Keys.debugOverlayEnabled) as? Bool ?? false
    }

    func saveAndBroadcast() {
        defaults.set(petScale, forKey: Keys.petScale)
        defaults.set(alwaysOnTop, forKey: Keys.alwaysOnTop)
        defaults.set(launchAtLogin, forKey: Keys.launchAtLogin)
        defaults.set(followCursorIntensity, forKey: Keys.followCursorIntensity)
        defaults.set(typingReactionIntensity, forKey: Keys.typingReactionIntensity)
        defaults.set(soundEnabled, forKey: Keys.soundEnabled)
        defaults.set(clickThroughMode, forKey: Keys.clickThroughMode)
        defaults.set(debugOverlayEnabled, forKey: Keys.debugOverlayEnabled)

        setLaunchAtLogin(enabled: launchAtLogin)
        onSettingsChanged?(.all)
    }

    private func setLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                // graceful no-op in dev unsigned environments
            }
        }
    }
}
