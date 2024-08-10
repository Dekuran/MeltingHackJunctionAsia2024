//
//  Item.swift
//  Mommy
//
//  Created by Sae Nuruki on 2024/08/10.
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
