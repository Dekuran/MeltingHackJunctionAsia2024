//
//  IngredientResultView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct IngredientResultView: View {
    @StateObject private var viewModel: IngredientRiskViewModel
    
    // DI init, used Dummy data for test
    init(viewModel: IngredientRiskViewModel = IngredientRiskViewModel(ingredientRisks: IngredientDummyData.ingredientRisks)) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Result")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                Group {
                    riskSection(title: "Danger Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore < 0 }, titleColor: .red)
                    
                    riskSection(title: "Neutral Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore == 0 }, titleColor: .gray)
                    
                    riskSection(title: "Good Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore > 0 }, titleColor: .green)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func riskSection(title: String, risks: [IngredientRisk], titleColor: Color) -> some View {
        if !risks.isEmpty {
            Section(header: Text(title)
                        .font(.headline)
                        .foregroundColor(titleColor)) {
                ForEach(risks.sorted(by: { $0.riskSortOrder < $1.riskSortOrder })) { risk in
                    IngredientRiskView(risk: risk)
                }
            }
        }
    }
}


struct IngredientRiskView: View {
    let risk: IngredientRisk
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(risk.ingredient)
                    .font(.title2)
                    .foregroundColor(Color(hex: risk.hexColor))
                Spacer()
                Text("\(risk.riskScore)")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Text(risk.riskCategory)
                .font(.subheadline)
                .foregroundColor(.red)
            
            Text(risk.riskDescription)
                .font(.body)
            
            Text("Pregnancy Status: \(risk.pregnancyStatus)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text("Weeks: \(risk.pregnancyOrPostBirthWeeks)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Divider()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

// Generate Color based on Hex code
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    IngredientResultView()
}
