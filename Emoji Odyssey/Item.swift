//
//  Item.swift
//  Emoji Odyssey
//
//  Created by Tharanitharan Muthuthirumaran on 3/1/25.
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
