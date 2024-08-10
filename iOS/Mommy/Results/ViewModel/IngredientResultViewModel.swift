//
//  IngredientResultViewModel.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

class IngredientRiskViewModel: ObservableObject {
    @Published var ingredientRisks: [IngredientRisk] = []
    
    init(ingredientRisks: [IngredientRisk] = []) {
        self.ingredientRisks = ingredientRisks
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://api.example.com") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let risks = try JSONDecoder().decode([IngredientRisk].self, from: data)
            DispatchQueue.main.async {
                self.ingredientRisks = risks
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
