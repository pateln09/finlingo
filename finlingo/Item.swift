//
//  Item.swift
//  finlingo
//
//  Created by Neel Patel on 10/18/25.
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
