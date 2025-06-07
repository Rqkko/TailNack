import SwiftData
import Foundation

@Model
class FingerNail {
    var name: String
    var usageTimestamps: [Date] = []

    var usageCount: Int { usageTimestamps.count }
    var lastUsed: Date? { usageTimestamps.last }

    init(name: String) {
        self.name = name
    }
}
