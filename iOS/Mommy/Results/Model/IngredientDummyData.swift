//
//  IngredientDummyData.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

struct IngredientDummyData {
    static let ingredientRisks: [IngredientRisk] = [
        IngredientRisk(
            product: "Coca-Cola",
            ingredient: "Phosphoric Acid",
            ingredientType: "Acidulant",
            amount: nil, // null 값은 nil로 처리
            unit: "",
            responseNo: 19,
            responseId: "19",
            responseTimeStamp: 1723351032,
            userId: "id_19",
            pregnancyStatus: "embryo",
            pregnancyOrPostBirthWeeks: 35,
            riskScore: 1.0,
            riskCategory: "Low",
            riskDescription: "Phosphoric acid is generally considered safe but should be consumed in moderation during pregnancy.",
            riskSortOrder: 1,
            hexColor: "#00FF00"
        ),
        IngredientRisk(
            product: "Coca-Cola",
            ingredient: "Caffeine",
            ingredientType: "Stimulant",
            amount: nil,
            unit: "",
            responseNo: 19,
            responseId: "19",
            responseTimeStamp: 1723351032,
            userId: "id_19",
            pregnancyStatus: "embryo",
            pregnancyOrPostBirthWeeks: 35,
            riskScore: 0.0,
            riskCategory: "No Risk",
            riskDescription: "Caffeine in small amounts is generally safe during pregnancy.",
            riskSortOrder: 2,
            hexColor: "#00FF00"
        ),
        IngredientRisk(
            product: "Coca-Cola",
            ingredient: "Carbonated Water",
            ingredientType: "Base",
            amount: nil,
            unit: "",
            responseNo: 19,
            responseId: "19",
            responseTimeStamp: 1723351032,
            userId: "id_19",
            pregnancyStatus: "embryo",
            pregnancyOrPostBirthWeeks: 35,
            riskScore: nil, // null 값은 nil로 처리
            riskCategory: nil, // null 값은 nil로 처리
            riskDescription: "Carbonated water is safe and has no associated risks during pregnancy.",
            riskSortOrder: 3,
            hexColor: "#808080"
        ),
        IngredientRisk(
            product: "Coca-Cola",
            ingredient: "Sugar",
            ingredientType: "Sweetener",
            amount: nil,
            unit: "",
            responseNo: 19,
            responseId: "19",
            responseTimeStamp: 1723351032,
            userId: "id_19",
            pregnancyStatus: "embryo",
            pregnancyOrPostBirthWeeks: 35,
            riskScore: nil,
            riskCategory: nil,
            riskDescription: "Sugar should be consumed in moderation, but it does not pose a significant risk.",
            riskSortOrder: 4,
            hexColor: "#808080"
        ),
        IngredientRisk(
            product: "Coca-Cola",
            ingredient: "Caramel Color",
            ingredientType: "Color",
            amount: nil,
            unit: "",
            responseNo: 19,
            responseId: "19",
            responseTimeStamp: 1723351032,
            userId: "id_19",
            pregnancyStatus: "embryo",
            pregnancyOrPostBirthWeeks: 35,
            riskScore: nil,
            riskCategory: nil,
            riskDescription: "Caramel color is safe in the amounts typically found in food and beverages.",
            riskSortOrder: 5,
            hexColor: "#808080"
        ),
        IngredientRisk(
            product: "Coca-Cola",
            ingredient: "Natural Flavors",
            ingredientType: "Flavor",
            amount: nil,
            unit: "",
            responseNo: 19,
            responseId: "19",
            responseTimeStamp: 1723351032,
            userId: "id_19",
            pregnancyStatus: "embryo",
            pregnancyOrPostBirthWeeks: 35,
            riskScore: nil,
            riskCategory: nil,
            riskDescription: "Natural flavors are generally considered safe during pregnancy.",
            riskSortOrder: 6,
            hexColor: "#808080"
        )
    ]
}
