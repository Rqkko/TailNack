import SwiftData
import Foundation

@Model
class FingerNail {
    var name: String
    var sortIndex: Int
    var usageTimestamps: [Date] = []
    var size: Int?  // Optional, since not all nails may have a size set

    var usageCount: Int { usageTimestamps.count }
    var lastUsed: Date? { usageTimestamps.last }

    init(name: String, sortIndex: Int, size: Int? = nil) {
        self.name = name
        self.sortIndex = sortIndex
        self.size = size
    }
}
