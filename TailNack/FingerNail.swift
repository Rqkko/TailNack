import SwiftData
import Foundation

@Model
class FingerNail {
    var name: String
    var sortIndex: Int
    var usageTimestamps: [Date] = []

    var usageCount: Int { usageTimestamps.count }
    var lastUsed: Date? { usageTimestamps.last }

    init(name: String, sortIndex: Int) {
        self.name = name
        self.sortIndex = sortIndex
    }
}
