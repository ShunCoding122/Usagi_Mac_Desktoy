import OSLog

enum Logger {
    static let app = OSLog(subsystem: "com.usagipet.mac", category: "app")
}
