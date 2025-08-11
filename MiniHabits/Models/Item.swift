//
//  Item.swift
//  MiniHabits
//
//  Created by 轻舟 on 2025/8/7.
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
