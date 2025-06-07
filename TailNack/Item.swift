//
//  Item.swift
//  TailNack
//
//  Created by Wongsathorn Chengcharoen on 7/6/2568 BE.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
