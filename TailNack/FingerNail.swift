import SwiftData
import Foundation

@Model
class FingerNail {
    var name: String       // e.g., "Left Thumb", "Right Index"
    var usageCount: Int
    var lastUsed: Date?

    init(name: String, usageCount: Int = 0, lastUsed: Date? = nil) {
        self.name = name
        self.usageCount = usageCount
        self.lastUsed = lastUsed
    }
}
