//
//  IngredientDummyData.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

struct IngredientDummyData{
    static let ingredientRisks: [IngredientRisk] = [
        // Danger factor
        IngredientRisk(
            ingredient: "Caffeine",
            ingredientType: "Stimulant",
            riskScore: -5,
            riskCategory: "High",
            riskDescription: "Caffeine can increase blood pressure and heart rate, which can be harmful during pregnancy.",
            pregnancyStatus: "during",
            pregnancyOrPostBirthWeeks: 12,
            riskSortOrder: 1,
            hexColor: "#FF0000"
        ),
        IngredientRisk(
            ingredient: "Alcohol",
            ingredientType: "Stimulant",
            riskScore: -4,
            riskCategory: "High",
            riskDescription: "Alcohol consumption during pregnancy can lead to serious developmental issues for the baby.",
            pregnancyStatus: "during",
            pregnancyOrPostBirthWeeks: 0,
            riskSortOrder: 2,
            hexColor: "#FF0000"
        ),
        // Neutral factor
        IngredientRisk(
            ingredient: "Water",
            ingredientType: "Hydration",
            riskScore: 0,
            riskCategory: "Neutral",
            riskDescription: "Water is essential for hydration, but has no direct positive or negative impact.",
            pregnancyStatus: "during",
            pregnancyOrPostBirthWeeks: 20,
            riskSortOrder: 3,
            hexColor: "#0000FF"
        ),
        IngredientRisk(
            ingredient: "Fiber",
            ingredientType: "Dietary",
            riskScore: 0,
            riskCategory: "Neutral",
            riskDescription: "Fiber helps with digestion, but does not significantly impact pregnancy risk.",
            pregnancyStatus: "pre",
            pregnancyOrPostBirthWeeks: 10,
            riskSortOrder: 4,
            hexColor: "#808080"
        ),
        // Good factor
        IngredientRisk(
            ingredient: "Folic Acid",
            ingredientType: "Nutrient",
            riskScore: 4,
            riskCategory: "Low",
            riskDescription: "Folic acid is crucial for preventing neural tube defects in the developing baby.",
            pregnancyStatus: "pre",
            pregnancyOrPostBirthWeeks: 0,
            riskSortOrder: 5,
            hexColor: "#00FF00"
        ),
        IngredientRisk(
            ingredient: "Calcium",
            ingredientType: "Nutrient",
            riskScore: 5,
            riskCategory: "Low",
            riskDescription: "Calcium supports the development of strong bones and teeth for the baby.",
            pregnancyStatus: "during",
            pregnancyOrPostBirthWeeks: 16,
            riskSortOrder: 6,
            hexColor: "#00FF00"
        )
    ]
}
