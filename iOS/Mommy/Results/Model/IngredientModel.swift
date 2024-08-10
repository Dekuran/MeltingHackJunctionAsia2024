//
//  IngredientModel.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import Foundation
import SwiftUI

struct IngredientRisk: Codable, Identifiable {
    let id = UUID()
    let product: String
    let ingredient: String
    let ingredientType: String
    let amount: Double?
    let unit: String
    let responseNo: Int
    let responseId: String
    let responseTimeStamp: Int
    let userId: String
    let pregnancyStatus: String
    let pregnancyOrPostBirthWeeks: Int
    let riskScore: Double?
    let riskCategory: String?
    let riskDescription: String
    let riskSortOrder: Int
    let hexColor: String
}

