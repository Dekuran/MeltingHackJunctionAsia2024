//
//  IngredientModel.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import Foundation
import SwiftUI

struct IngredientRisk: Codable, Identifiable {
    var id = UUID()
    let ingredient: String
    let ingredientType: String
    let riskScore: Int
    let riskCategory: String
    let riskDescription: String
    let pregnancyStatus: String
    let pregnancyOrPostBirthWeeks: Int
    let riskSortOrder: Int
    let hexColor: String
}

